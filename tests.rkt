#lang racket

(require rackunit
         "main.rkt")

(define-simple-check (check-ok? response)
  (eq? (hash-ref response 'status) 0))

(define drv (new webdriver))

(test-case
 "Server status"
 ;;Check that diver has ok status
 (check-equal? (send drv get-status) '#hasheq((status . ok)))
 (send drv new-session)
 ;;Check that session creation works
 (check (λ (1st 2nd) (1st 2nd)) string? (send drv get-current-session-id))
 (send drv delete-session (send drv get-current-session-id)))


(test-case
 "Main API tests"
 (send drv new-session) ;;Setup

 ;;----------------------------------------------------------------------
 (check-ok? (send drv post-timeouts-async-script 1000))
 (check-ok? (send drv post-timeouts-implicit-wait 1000))
 (send drv post-url "http://www.google.com")
 (check-ok? (send drv get-url))
 (check-equal? (hash-ref (send drv get-url) 'value) "http://www.google.com/")
 (check-ok? (send drv post-url "http://www.google.com/mail"))
 (check-ok? (send drv post-back))
 (check-ok? (send drv post-forward))
 (check-ok? (send drv post-refresh))
 (check-ok? (send drv get-ime-available-engines))
 (check-ok? (send drv post-frame null))
 (check-ok? (send drv delete-window))
 (check-ok? (send drv get-cookie))
 (check-ok? (send drv delete-cookie))
 (check-ok? (send drv delete-cookie "name"))
 (check-ok? (send drv get-source))
 (check-ok? (send drv get-title))
 

 ;;----------------------------------------------------------------------

 ;;Teardown
 (send drv delete-session (send drv get-current-session-id)))





(test-suite "Failing tests"
 (test-case
 "Faling tests"
 (send drv new-session) ;;Setup

 ;;----------------------------------------------------------------------
 ;; Failing and I cant find why
 (check-ok? (send drv post-execute 
                  (hasheq 'value
                          (hasheq 'script "document.write('<h1>Hello World</h1>');"
                                  'args "Hello World")
                          'script "document.write('<h1>Hello World</h1>');"
                          'args "Hello World")))

 ;; Failing and I cant find why
 (check-ok? (send drv post-execute-async
                  (hasheq 'value
                          (hasheq 'script "document.write('<h1>Hello World</h1>');"
                                  'args "Hello World")
                          'script "document.write('<h1>Hello World</h1>');"
                          'args "Hello World")))


 (check-ok? (send drv get-screenshot)) ;;Not currently supported on linux

 ;;Apperently not implemented, they don't return the expected results,
 ;;though they return with an ok status
 (check-ok? (send drv get-ime-available-engines))
 (check-ok? (send drv get-ime-active-engine))
 (check-ok? (send drv get-ime-activated))

 ;;The POST version is what the API draft specifies, but its not
 ;;supported by chrome, the DELETE method is though.
 (check-ok? (send drv post-ime-deactivate))
 (check-ok? (send drv delete-ime-deactivate))
 (check-ok? (send drv post-ime-activate (hasheq 'engine "english")))

 ;;Only returns an EOF in chrome, which kills the json parser
 (check-ok? (send drv get-window-handle))
 (check-ok? (send drv get-window-handles))
 ;;Seems to work fine, but need the handle from the above to be any good.
 (check-ok? (send drv post-window (hasheq 'name "Fred"))) 

 ;;POST returns 405 request for GET HEAD DELETE
 (check-ok? (send drv post-window-size (hasheq 'width 100
                                               'height 100)))
 ;;GET returns nonsense, with OK status
 (check-ok? (send drv get-window-size))

 ;;405 GET HEAD DELETE
 (check-ok? (send drv post-window-size (hasheq 'x 100
                                               'y 100)))
 ;;Returns nonsense
 (check-ok? (send drv get-window-size))

 ;;Chrome internal error
 (check-ok? (send drv post-cookie (hasheq 'cookie (hasheq 'name "test cookie"
                                              'value "6cb3992a-0a0c-11e1-a194-485b3973ae15"
                                              'path "./"
                                              'domain "noionlabs.com"
                                              'secure #t
                                              'expiry (+ (current-seconds) 360)))))
 
 ;;----------------------------------------------------------------------

 ;;Teardown
 (send drv delete-session (send drv get-current-session-id)))
)