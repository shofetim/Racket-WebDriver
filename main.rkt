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
      (request  (string-append "/session/" current-session 
                               "/timeouts/async_script")
                'post (hasheq 'ms wait)))

    (define/public (post-timeouts-implicit-wait wait)
      (when (null? current-session)
        (error "No session"))
      (request (string-append "/session/" current-session 
                              "/timeouts/implicit_wait")
               'post (hasheq 'ms wait)))

    (define/public (get-window-handle)
      (when (null? current-session)
        (error "No session"))
      (request "/session" 
               'get
               (string-append current-session "/window_handle")))

    (define/public (get-window-handles)
      (when (null? current-session)
        (error "No session"))
      (request "/session" 
               'get
               (string-append current-session "/window_handles")))
    
    (define/public (get-url url)
      (when (null? current-session)
        (error "No session"))
      (request "/session" 'get (string-append "/" current-session "/" url)))

    (define/public (post-url url)
      (when (null? current-session)
        (error "No session"))
      (request (string-append "/session/" current-session "/url") 
               'post
               (hasheq 'url url)))
    
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
      (request "/session" 
               'get 
               (string-append "/" current-session "/screenshot")))

    (define/public (get-ime-available_engines)
      (when (null? current-session)
        (error "No session"))
      (request "/session" 
               'get
               (string-append "/" current-session "/ime/available_engines/")))

    (define/public (get-ime-active-engine)
      (when (null? current-session)
        (error "No session"))
      (request "/session" 
               'get
               (string-append "/" current-session "/ime/active_engine/")))

    (define/public (get-ime-activated)
      (when (null? current-session)
        (error "No session"))
      (request "/session" 
               'get
               (string-append "/" current-session "/ime/activated/")))

    (define/public (get-cookie)
      (when (null? current-session)
        (error "No session"))
      (request "/session" 
               'get
               (string-append "/" current-session "/cookie/")))

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
      (request "/session" 
               'get
               (string-append "/" current-session "/element/" arg)))

    (define/public (get-element-text arg)
      (when (null? current-session)
        (error "No session"))
      (request "/session" 
               'get
               (string-append "/" current-session "/element/" arg "/text")))

    (define/public (get-element-name arg)
      (when (null? current-session)
        (error "No session"))
      (request "/session" 
               'get
               (string-append "/" current-session "/element/" arg "/name")))

    (define/public (get-element-selected arg)
      (when (null? current-session)
        (error "No session"))
      (request "/session" 
               'get
               (string-append "/" current-session "/element/" arg "/selected")))

    (define/public (get-element-enabled)
      (when (null? current-session)
        (error "No session"))
      (request "/session" 
               'get
               (string-append "/" current-session "/element-enabled")))

    (define/public (get-element-attribute arg)
      (when (null? current-session)
        (error "No session"))
      (request "/session" 
               'get 
               (string-append "/" current-session "/element-attribute/" arg)))

    (define/public (get-element-equals arg1 arg2)
      (when (null? current-session)
        (error "No session"))
      (request "/session" 
               'get
               (string-append "/" current-session "/element/" arg1
                              "/equals/" arg2)))

    (define/public (get-element-displayed arg)
      (when (null? current-session)
        (error "No session"))
      (request "/session" 
               'get
               (string-append "/" current-session "/element/" 
                              arg "/displayed")))

    (define/public (get-element-location arg)
      (when (null? current-session)
        (error "No session"))
      (request "/session" 
               'get
               (string-append "/" current-session "/element/"
                              arg "/location")))

    (define/public (get-element-location-in-view arg)
      (when (null? current-session)
        (error "No session"))
      (request "/session" 
               'get
               (string-append "/" current-session "/element"
                              arg "/location_in_view")))

    (define/public (get-element-size arg)
      (when (null? current-session)
        (error "No session"))
      (request "/session" 
               'get
               (string-append "/" current-session "/element" arg "/size")))

    (define/public (get-element-css arg1 arg2)
      (when (null? current-session)
        (error "No session"))
      (request "/session" 
               'get (string-append "/" current-session "/element/" arg1
                                   "/css/" arg2)))

    (define/public (get-orientation)
      (when (null? current-session)
        (error "No session"))
      (request "/session" 
               'get
               (string-append "/" current-session "/orientation")))

    (define/public (get-alert-text)
      (when (null? current-session)
        (error "No session"))
      (request "/session" 
               'get
               (string-append "/" current-session "/alert_text")))

    (define/public (delete-window)
      (when (null? current-session)
        (error "No session"))
      (request "/session" 
               'delete
               (string-append "/" current-session "/window")))

    (define/public (delete-cookie [name null])
      (when (null? current-session)
        (error "No session"))
      (if (null? name)
          (request "/session" 'delete 
                   (string-append "/" current-session "/cookie"))
          (request "/session" 'delete 
                   (string-append "/" current-session "/cookie/" name))))

    (define/public (post-ime-deactivate)
      (when (null? current-session)
        (error "No session"))
      (request (string-append "/session/" current-session "/ime/deactivate")
               'post))

    (define/public (post-ime-activate arg)
      (when (null? current-session)
        (error "No session"))
      (request (string-append "/session/" current-session "/ime/activate") 
               'post arg))

    (define/public (post-frame arg)
      (when (null? current-session)
        (error "No session"))
      (request (string-append "/session/" current-session "/frame") 'post arg))
    
    (define/public (post-window arg)
      (when (null? current-session)
        (error "No session"))
      (request (string-append "/session/" current-session "/window") 'post arg))
    
    (define/public (post-cookie arg)
      (when (null? current-session)
        (error "No session"))
      (request (string-append "/session/" current-session "/cookie")
               'post arg))
    
    (define/public (post-element arg)
      (when (null? current-session)
        (error "No session"))
      (request (string-append "/session/" current-session "/element") 
               'post arg))

    (define/public (post-elements arg)
      (when (null? current-session)
        (error "No session"))
      (request (string-append "/session/" current-session "/elements")
               'post arg))

    (define/public (post-active)
      (when (null? current-session)
        (error "No session"))
      (request (string-append "/session/" current-session "/active") 'post))

    (define/public (post-id-element id arg)
      (when (null? current-session)
        (error "No session"))
      (request (string-append "/session/" current-session "/element/" 
                              id "/element") 'post arg))

    (define/public (post-id-elements id arg)
      (when (null? current-session)
        (error "No session"))
      (request (string-append "/session/" current-session "/element/" 
                              id "/elements") 'post arg))

    (define/public (post-element-click id)
      (when (null? current-session)
        (error "No session"))
      (request (string-append "/session/" current-session "/element/" 
                              id "/click") 'post arg))

    (define/public (post-element-submit id)
      (when (null? current-session)
        (error "No session"))
      (request (string-append "/session/" current-session "/element/" 
                              id "/submit") 'post arg))

    (define/public (post-element-value id arg)
      (when (null? current-session)
        (error "No session"))
      (request (string-append "/session/" current-session "/element/" 
                              id "/value") 'post arg))

    (define/public (post-keys arg)
      (when (null? current-session)
        (error "No session"))
      (request (string-append "/session/" current-session "/keys") 'post arg))

    (define/public (post-element-clear id)
      (when (null? current-session)
        (error "No session"))
      (request (string-append "/session/" current-session 
                              "/element/" id "/clear") 'post))

    (define/public (post-orientation arg)
      (when (null? current-session)
        (error "No session"))
      (request (string-append "/session/" current-session "/orientation") 
               'post arg))

    (define/public (post-alert-text arg)
      (when (null? current-session)
        (error "No session"))
      (request (string-append "/session/" current-session "/alert_text") 
               'post arg))

    (define/public (post-accept-alert)
      (when (null? current-session)
        (error "No session"))
      (request (string-append "/session/" current-session "/accept_alert")
               'post))

    (define/public (post-dismiss-alert)
      (when (null? current-session)
        (error "No session"))
      (request (string-append "/session/" current-session "/dismiss_alert") 
               'post))

    (define/public (post-move-to arg)
      (when (null? current-session)
        (error "No session"))
      (request (string-append "/session/" current-session "/moveto") 
               'post arg))

    (define/public (post-click arg)
      (when (null? current-session)
        (error "No session"))
      (request (string-append "/session/" current-session "/click") 
               'post arg))

    (define/public (post-button-down)
      (when (null? current-session)
        (error "No session"))
      (request (string-append "/session/" current-session "/buttondown")
               'post))

    (define/public (post-button-up)
      (when (null? current-session)
        (error "No session"))
      (request (string-append "/session/" current-session "/buttonup") 'post))

    (define/public (post-doubleclick)
      (when (null? current-session)
        (error "No session"))
      (request (string-append "/session/" current-session "/doubleclick") 
               'post))

    (define/public (post-touch-click arg)
      (when (null? current-session)
        (error "No session"))
      (request (string-append "/session/" current-session "/touch/click") 
               'post arg))

    (define/public (post-touch-down arg)
      (when (null? current-session)
        (error "No session"))
      (request (string-append "/session/" current-session "/touch/down")
               'post arg))

    (define/public (post-touch-up arg)
      (when (null? current-session)
        (error "No session"))
      (request (string-append "/session/" current-session "/touch/up")
               'post arg))

    (define/public (post-touch-move arg)
      (when (null? current-session)
        (error "No session"))
      (request (string-append "/session/" current-session "/touch/move")
               'post arg))

    (define/public (post-touch-scroll arg)
      (when (null? current-session)
        (error "No session"))
      (request (string-append "/session/" current-session "/touch/scroll")
               'post arg))

    (define/public (post-touch-doubleclick arg)
      (when (null? current-session)
        (error "No session"))
      (request (string-append "/session/" current-session "/touch/doubleclick") 
               'post arg))

    (define/public (post-touch-longclick arg)
      (when (null? current-session)
        (error "No session"))
      (request (string-append "/session/" current-session "/touch/longclick") 
               'post arg))

    (define/public (post-touch-flick arg)
      (when (null? current-session)
        (error "No session"))
      (request (string-append "/session/" current-session "/touch/flick") 
               'post arg))

    (define/public (post-execute arg)
      (when (null? current-session)
        (error "No session"))
      (request 
       (string-append "/session/" current-session "/execute") 
       'post arg))

    (define/public (post-execute-async arg)
      (when (null? current-session)
        (error "No session"))
      (request 
       (string-append "/session/" current-session "/execute_async") 
       'post arg))

    ;;Abstractions over protocol
    (define/public (new-session)
      (set! current-session (post-session))))

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
     [else (error "http method not implemented")])))