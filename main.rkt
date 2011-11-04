#lang racket
(require net/url
         "../json/main.rkt")

(define webdriver
  (class object%
    (super-new) ;;Init Superclass
    
    ;;Initialization values
    ;;(init browser) ;; Only one browser, chrome, currently supported

    ;;Private fields
    (define current-browser "chrome")
    (define port  "9515")
    (define domain "localhost")
    (define protocal "http://")
    (define server (string-append protocal domain ":" port))
    (define current-session null)

    ;;Method definitions
    ;;returns a string which cant be parsed as json
    (define/public (get-status)
      (request "/status" 'get ""))

    (define/public (post-session [capabilities (hasheq
                                                'desiredCapabilities
                                                (hasheq 'browserName "chrome"
                                                        'javascriptEnabled #t
                                                        'takesScreenshot #t
                                                        'handlesAlerts #t
                                                        'cssSelectorsEnabled #t
                                                        'acceptSslCerts #t
                                                        'nativeEvents #t))])
      (substring (hash-ref (request "/session" 'post capabilities) 'value) 9))

    (define/public (get-session id)
      (request "/session" 'get (string-append "/" id)))
    
    (define/public (delete-session id)
      (request "/session" 'delete (string-append "/" id))
      (set! current-session null))

    (define/public (post-timeouts-async-script wait)
      (when (null? current-session)
        (error "No session"))
      (request (string-append "/session/" current-session 
                              "/timeouts/async_script")
               'post (hasheq 'ms wait)))

    (define/public (post-timeouts-implicit-wait wait)
      (when (null? current-session)
        (error "No session"))
      (request (string-append "/session/" current-session 
                              "/timeouts/implicit_wait")
               'post (hasheq 'ms wait)))

    ;;returns a string which cant be parsed as json
    (define/public (get-window-handle)
      (when (null? current-session)
        (error "No session"))
      (request "/session" 'get (string-append current-session 
                                              "/window_handle")))

    (define/public (get-window-handles)
      (when (null? current-session)
        (error "No session"))
      (request "/session" 'get (string-append current-session 
                                              "/window_handles")))
    
    (define/public (get-url url)
      (when (null? current-session)
        (error "No session"))
      (request "/session" 'get (string-append "/" current-session "/" url)))

    (define/public (post-url url)
      (when (null? current-session)
        (error "No session"))
      (request (string-append "/session/" current-session "/url") 'post (hasheq 'url url)))
    
    (define/public (post-forward)
      (when (null? current-session)
        (error "No session"))
      (request (string-append "/session/" current-session "/forward") 'post))
    
    (define/public (post-back)
      (when (null? current-session)
        (error "No session"))
      (request (string-append "/session/" current-session "/back") 'post))
    
    (define/public (post-refresh)
      (when (null? current-session)
        (error "No session"))
      (request (string-append "/session/" current-session "/refresh") 'post))

    ;;Not yet implemented
    ;;/session/:sessionId/execute
    ;;/session/:sessionId/execute_async
    
    ;;Returns base64 encoded png
    (define/public (get-screenshot)
      (when (null? current-session)
        (error "No session"))
      (request "/session" 'get (string-append "/" current-session "/screenshot")))



    ;;Abstractions over protocol
    (define/public (new-session)
      (set! current-session (post-session)))

    (define/public (get-current-session-id)
      current-session)

    ;;Private methods
    (define (request path [type 'get] [data ""])
      (cond
       [(eqv? 'get type)
        (call/input-url
         (string->url (string-append server path data))
         get-pure-port
         (λ (ip)
            (if (equal? path "/status")
                (let ([data (read ip)])
                  (hasheq 'status data))
                (read-json ip))))]
       [(eqv? 'post type)
        (call/input-url
         (string->url (string-append server path))
         (λ (url)
            (post-pure-port url (string->bytes/utf-8 (jsexpr->json data))))
         (λ (ip)
            (read-json ip)))]
       [(eqv? 'delete type)
        (call/input-url
         (string->url (string-append server path data))
         delete-pure-port
         (λ (ip)
            (read-json ip)))]
       [else (error "http method not implemented")]))
    ))

(define a (new webdriver))

;;(send a get-status)
;;(send a post-session)
;;(send a get-session (send a post-session))
;;(send a delete-session (send a post-session))
(begin
  (send a new-session)
  ;; (send a get-current-session-id)
  ;; (send a get-window-handle)
  (send a post-url "http://www.google.com")
  )

