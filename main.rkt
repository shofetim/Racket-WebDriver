#lang racket

(require net/url)

(define port  "9515")
(define domain "localhost")
(define protocal "http://")
(define server (string-append protocal domain ":" port))


(define (try methode command)
  (call/input-url
   (string->url (string-append server command))
   (λ (methode)
      (cond [(equal? 'post method) post-pure-port]
            [else get-pure-port]))
   (λ (ip)
      (copy-port ip (current-output-port))
      (newline))
   (list "User-Agent: racket")))


(call/input-url
 (string->url (string-append server "/session"))
 post-pure-port
 (λ (ip)
    (copy-port ip (current-output-port))
    (newline))
 " "
 (list "User-Agent: racket"))

(define ip (post-pure-port (string->url "http://localhost:9515/session") (string->bytes/utf-8 "1")))
(copy-port ip (current-output-port))