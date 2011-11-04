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

    ;;Method definitions
    (define/public (get-status)
      (request "/status"))

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

    ;;Private methods
    (define (request path [type 'get] [data ""])
      (cond
       [(eqv? 'get type)
        (call/input-url
         (string->url (string-append server path))
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
       [else (error "http method not implemented")]))
    ))

(define a (new webdriver))
(send a get-status)
;;(send a post-session)



