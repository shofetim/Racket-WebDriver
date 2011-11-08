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
      (check-session)
      (request  (string-append "/session/" current-session 
                               "/timeouts/async_script")
                'post (hasheq 'ms wait)))

    (define/public (post-timeouts-implicit-wait wait)
      (check-session)
      (request (string-append "/session/" current-session 
                              "/timeouts/implicit_wait")
               'post (hasheq 'ms wait)))

    (define/public (get-window-handle)
      (check-session)
      (request "/session" 
               'get
               (string-append current-session "/window_handle")))

    (define/public (get-window-handles)
      (check-session)
      (request "/session" 
               'get
               (string-append current-session "/window_handles")))
    
    (define/public (get-url)
      (check-session)
      (request "/session" 'get (string-append "/" current-session "/url")))

    (define/public (post-url url)
      (check-session)
      (request (string-append "/session/" current-session "/url") 
               'post
               (hasheq 'url url)))
    
    (define/public (post-forward)
      (check-session)
      (request (string-append "/session/" current-session "/forward") 
               'post
               (hasheq 'value "")))
    
    (define/public (post-back)
      (check-session)
      (request (string-append "/session/" current-session "/back") 
               'post
               (hasheq 'value "")))
    
    (define/public (post-refresh)
      (check-session)
      (request (string-append "/session/" current-session "/refresh") 
               'post
               (hasheq 'value "")))

    ;;Returns base64 encoded png
    (define/public (get-screenshot)
      (check-session)
      (request "/session" 
               'get 
               (string-append "/" current-session "/screenshot")))

    (define/public (get-ime-available-engines)
      (check-session)
      (request "/session" 
               'get
               (string-append "/" current-session "/ime/available_engines")))

    (define/public (get-ime-active-engine)
      (check-session)
      (request "/session" 
               'get
               (string-append "/" current-session "/ime/active_engine")))

    (define/public (get-ime-activated)
      (check-session)
      (request "/session" 
               'get
               (string-append "/" current-session "/ime/activated")))

    (define/public (get-cookie)
      (check-session)
      (request "/session" 
               'get
               (string-append "/" current-session "/cookie")))

    (define/public (get-source)
      (check-session)
      (request "/session" 'get (string-append "/" current-session "/source")))

    (define/public (get-title)
      (check-session)
      (request "/session" 'get (string-append "/" current-session "/title")))

    (define/public (get-element arg)
      (check-session)
      (request "/session" 
               'get
               (string-append "/" current-session "/element/" arg)))

    (define/public (get-element-text arg)
      (check-session)
      (request "/session" 
               'get
               (string-append "/" current-session "/element/" arg "/text")))

    (define/public (get-element-name arg)
      (check-session)
      (request "/session" 
               'get
               (string-append "/" current-session "/element/" arg "/name")))

    (define/public (get-element-selected arg)
      (check-session)
      (request "/session" 
               'get
               (string-append "/" current-session "/element/" arg "/selected")))

    (define/public (get-element-enabled)
      (check-session)
      (request "/session" 
               'get
               (string-append "/" current-session "/element-enabled")))

    (define/public (get-element-attribute arg)
      (check-session)
      (request "/session" 
               'get 
               (string-append "/" current-session "/element-attribute/" arg)))

    (define/public (get-element-equals arg1 arg2)
      (check-session)
      (request "/session" 
               'get
               (string-append "/" current-session "/element/" arg1
                              "/equals/" arg2)))

    (define/public (get-element-displayed arg)
      (check-session)
      (request "/session" 
               'get
               (string-append "/" current-session "/element/" 
                              arg "/displayed")))

    (define/public (get-element-location arg)
      (check-session)
      (request "/session" 
               'get
               (string-append "/" current-session "/element/"
                              arg "/location")))

    (define/public (get-element-location-in-view arg)
      (check-session)
      (request "/session" 
               'get
               (string-append "/" current-session "/element"
                              arg "/location_in_view")))

    (define/public (get-element-size arg)
      (check-session)
      (request "/session" 
               'get
               (string-append "/" current-session "/element" arg "/size")))

    (define/public (get-element-css arg1 arg2)
      (check-session)
      (request "/session" 
               'get (string-append "/" current-session "/element/" arg1
                                   "/css/" arg2)))

    (define/public (get-orientation)
      (check-session)
      (request "/session" 
               'get
               (string-append "/" current-session "/orientation")))

    (define/public (get-alert-text)
      (check-session)
      (request "/session" 
               'get
               (string-append "/" current-session "/alert_text")))

    (define/public (get-window-size [handle "current"])
      (check-session)
      (request "/session" 
               'get
               (string-append "/" current-session "/window/" handle "/size")))

    (define/public (get-window-position [handle "current"])
      (check-session)
      (request "/session" 
               'get
               (string-append "/" current-session "/window/" handle "/position")))


    (define/public (delete-window)
      (check-session)
      (request "/session" 
               'delete
               (string-append "/" current-session "/window")))

    (define/public (delete-cookie [name null])
      (check-session)
      (if (null? name)
          (request "/session" 'delete 
                   (string-append "/" current-session "/cookie"))
          (request "/session" 'delete 
                   (string-append "/" current-session "/cookie/" name))))

    (define/public (post-ime-deactivate)
      (check-session)
      (request (string-append "/session/" current-session "/ime/deactivate")
               'post
               (hasheq 'value "")))

    (define/public (delete-ime-deactivate)
      (check-session)
      (request (string-append "/session/" current-session "/ime/deactivate")
               'delete))

    (define/public (post-ime-activate arg)
      (check-session)
      (request (string-append "/session/" current-session "/ime/activate") 
               'post arg))

    (define/public (post-frame arg)
      (check-session)
      (request (string-append "/session/" current-session "/frame") 
               'post 
               (hasheq 'value arg)))
    
    (define/public (post-window arg)
      (check-session)
      (request (string-append "/session/" current-session "/window") 
               'post
               arg))

    (define/public (post-window-size arg [handle "current"])
      (check-session)
      (request (string-append "/session/" current-session "/window/" handle "/size") 
               'post
               arg))

    (define/public (post-window-position arg [handle "current"])
      (check-session)
      (request (string-append "/session/" current-session "/window/" handle "/position") 
               'post
               arg))
    
    (define/public (post-cookie arg)
      (check-session)
      (request (string-append "/session/" current-session "/cookie")
               'post arg))
    
    (define/public (post-element arg)
      (check-session)
      (request (string-append "/session/" current-session "/element") 
               'post arg))

    (define/public (post-elements arg)
      (check-session)
      (request (string-append "/session/" current-session "/elements")
               'post arg))

    (define/public (post-active)
      (check-session)
      (request (string-append "/session/" current-session "/active") 'post))

    (define/public (post-id-element id arg)
      (check-session)
      (request (string-append "/session/" current-session "/element/" 
                              id "/element") 'post arg))

    (define/public (post-id-elements id arg)
      (check-session)
      (request (string-append "/session/" current-session "/element/" 
                              id "/elements") 'post arg))

    (define/public (post-element-click id)
      (check-session)
      (request (string-append "/session/" current-session "/element/" 
                              id "/click") 'post))

    (define/public (post-element-submit id)
      (check-session)
      (request (string-append "/session/" current-session "/element/" 
                              id "/submit") 'post (hasheq 'value '())))

    (define/public (post-element-value id arg)
      (check-session)
      (request (string-append "/session/" current-session "/element/" 
                              id "/value") 'post arg))

    (define/public (post-keys arg)
      (check-session)
      (request (string-append "/session/" current-session "/keys") 'post arg))

    (define/public (post-element-clear id)
      (check-session)
      (request (string-append "/session/" current-session 
                              "/element/" id "/clear") 'post))

    (define/public (post-orientation arg)
      (check-session)
      (request (string-append "/session/" current-session "/orientation") 
               'post arg))

    (define/public (post-alert-text arg)
      (check-session)
      (request (string-append "/session/" current-session "/alert_text") 
               'post arg))

    (define/public (post-accept-alert)
      (check-session)
      (request (string-append "/session/" current-session "/accept_alert")
               'post))

    (define/public (post-dismiss-alert)
      (check-session)
      (request (string-append "/session/" current-session "/dismiss_alert") 
               'post))

    (define/public (post-move-to arg)
      (check-session)
      (request (string-append "/session/" current-session "/moveto") 
               'post arg))

    (define/public (post-click arg)
      (check-session)
      (request (string-append "/session/" current-session "/click") 
               'post arg))

    (define/public (post-button-down)
      (check-session)
      (request (string-append "/session/" current-session "/buttondown")
               'post))

    (define/public (post-button-up)
      (check-session)
      (request (string-append "/session/" current-session "/buttonup") 'post))

    (define/public (post-doubleclick)
      (check-session)
      (request (string-append "/session/" current-session "/doubleclick") 
               'post))

    (define/public (post-touch-click arg)
      (check-session)
      (request (string-append "/session/" current-session "/touch/click") 
               'post arg))

    (define/public (post-touch-down arg)
      (check-session)
      (request (string-append "/session/" current-session "/touch/down")
               'post arg))

    (define/public (post-touch-up arg)
      (check-session)
      (request (string-append "/session/" current-session "/touch/up")
               'post arg))

    (define/public (post-touch-move arg)
      (check-session)
      (request (string-append "/session/" current-session "/touch/move")
               'post arg))

    (define/public (post-touch-scroll arg)
      (check-session)
      (request (string-append "/session/" current-session "/touch/scroll")
               'post arg))

    (define/public (post-touch-doubleclick arg)
      (check-session)
      (request (string-append "/session/" current-session "/touch/doubleclick") 
               'post arg))

    (define/public (post-touch-longclick arg)
      (check-session)
      (request (string-append "/session/" current-session "/touch/longclick") 
               'post arg))

    (define/public (post-touch-flick arg)
      (check-session)
      (request (string-append "/session/" current-session "/touch/flick") 
               'post arg))

    (define/public (post-execute arg)
      (check-session)
      (request 
       (string-append "/session/" current-session "/execute") 
       'post arg))

    (define/public (post-execute-async arg)
      (check-session)
      (request 
       (string-append "/session/" current-session "/execute_async") 
       'post arg))

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

    (define (check-session)
      (when (null? current-session)
        (error "No session")))
    ))

(provide webdriver)