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

    ;;Returns base64 encoded png
    (define/public (get-screenshot)
      (when (null? current-session)
        (error "No session"))
      (request "/session" 'get (string-append "/" current-session "/screenshot")))

    (define/public (get-ime-available_engines)
      (when (null? current-session)
        (error "No session"))
      (request "/session" 'get (string-append "/" current-session "/ime/available_engines/")))

    (define/public (get-ime-active-engine)
      (when (null? current-session)
        (error "No session"))
      (request "/session" 'get (string-append "/" current-session "/ime/active_engine/")))

    (define/public (get-ime-activated)
      (when (null? current-session)
        (error "No session"))
      (request "/session" 'get (string-append "/" current-session "/ime/activated/")))

    (define/public (get-cookie)
      (when (null? current-session)
        (error "No session"))
      (request "/session" 'get (string-append "/" current-session "/cookie/")))

    (define/public (get-source)
      (when (null? current-session)
        (error "No session"))
      (request "/session" 'get (string-append "/" current-session "/source")))

    (define/public (get-title)
      (when (null? current-session)
        (error "No session"))
      (request "/session" 'get (string-append "/" current-session "/title")))

    (define/public (get-element arg)
      (when (null? current-session)
        (error "No session"))
      (request "/session" 'get (string-append "/" current-session "/element/" arg)))

    (define/public (get-element-text arg)
      (when (null? current-session)
        (error "No session"))
      (request "/session" 'get (string-append "/" current-session "/element/" arg "/text")))

    (define/public (get-element-name arg)
      (when (null? current-session)
        (error "No session"))
      (request "/session" 'get (string-append "/" current-session "/element/" arg "/name")))

    (define/public (get-element-selected arg)
      (when (null? current-session)
        (error "No session"))
      (request "/session" 'get (string-append "/" current-session 
                                              "/element/" arg "/selected")))

    (define/public (get-element-enabled)
      (when (null? current-session)
        (error "No session"))
      (request "/session" 'get (string-append "/" current-session "/element-enabled")))

    (define/public (get-element-attribute arg)
      (when (null? current-session)
        (error "No session"))
      (request "/session" 'get (string-append "/" current-session 
                                              "/element-attribute/" arg)))

    (define/public (get-element-equals arg1 arg2)
      (when (null? current-session)
        (error "No session"))
      (request "/session" 'get (string-append "/" current-session 
                                              "/element/" arg1 "/equals/" arg2)))

    (define/public (get-element-displayed arg)
      (when (null? current-session)
        (error "No session"))
      (request "/session" 'get (string-append "/" current-session "/element/" 
                                              arg "/displayed")))

    (define/public (get-element-location arg)
      (when (null? current-session)
        (error "No session"))
      (request "/session" 'get (string-append "/" current-session "/element/"
                                              arg "/location")))

    (define/public (get-element-location-in-view arg)
      (when (null? current-session)
        (error "No session"))
      (request "/session" 'get (string-append "/" current-session "/element"
                                              arg "/location_in_view")))

    (define/public (get-element-size arg)
      (when (null? current-session)
        (error "No session"))
      (request "/session" 'get (string-append "/" current-session "/element"
                                              arg "/size")))

    (define/public (get-element-css arg1 arg2)
      (when (null? current-session)
        (error "No session"))
      (request "/session" 'get (string-append "/" current-session "/element"
                                              arg1 "/css/" arg2)))

    (define/public (get-orientation)
      (when (null? current-session)
        (error "No session"))
      (request "/session" 'get (string-append "/" current-session "/orientation")))

    (define/public (get-alert-text)
      (when (null? current-session)
        (error "No session"))
      (request "/session" 'get (string-append "/" current-session "/alert_text")))

    (define/public (delete-window)
      (when (null? current-session)
        (error "No session"))
      (request "/session" 'delete (string-append "/" current-session "/window")))

    (define/public (delete-cookie [name null])
      (when (null? current-session)
        (error "No session"))
      (if (null? name)
          (request "/session" 'delete (string-append "/" current-session "/cookie"))
          (request "/session" 'delete (string-append "/" current-session "/cookie/" name))))

    ;;TODO
    ;;Not yet implemented
    ;;/session/:sessionId/execute
    ;;/session/:sessionId/execute_async

    (define/public (post-ime-deactivate)
      (when (null? current-session)
        (error "No session"))
      (request (string-append "/session/" current-session "/refresh") 'post))
    
    ;; post
    ;; /ime/deactivate
    ;; /ime/activate
    ;; /frame
    ;; /window
    ;; /cookie
    ;; /element
    ;; /elements
    ;; /element/active
    ;; /element/:id/element
    ;; /element/:id/elements
    ;; /element/:id/click
    ;; /element/:id/submit
    ;; /element/:id/value
    ;; /keys
    ;; /element/:id/clear
    ;; /orientation
    ;; /alert_text
    ;; /accept_alert
    ;; /dismiss_alert
    ;; /moveto
    ;; /click
    ;; /buttondown
    ;; /buttonup
    ;; /doubleclick
    ;; /touch/click
    ;; /touch/down
    ;; /touch/up
    ;; /touch/move
    ;; /touch/scroll
    ;; /touch/doubleclick
    ;; /touch/longclick
    ;; /touch/flick




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
       [else (error "http method not implemented")]))))

