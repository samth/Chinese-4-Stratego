#lang racket/base
(require racket/class)
(require racket/bool)
(require racket/generic)
(require gls)
(module+ test
  (require rackunit))

(module+ test)
(define help-text "This is the board game stratego. For more detail see wikipedia.")
(define unknown-piece-text "?")
(struct piece-on-board (piece shown? pos board player) #:mutable)
(define (kill! x) (display (string-append (text (piece x)) " is killed")) (newline))
(define (compose f g) (lambda (x) (f (g x))))
(struct bomb ())
(define piece piece-on-board-piece)
(defgeneric text
  (method [(_ bomb?)] "bomb"))
(struct normal-piece (power))
(define power normal-piece-power)

(defgeneric collide!
  (method [(attack (compose? (list normal-piece? piece))) (defense (compose? (list normal-piece? piece)))]
          (if (<= (power (piece attack)) (power (piece defense))) (kill! attack) void)
          (if (<= (power (piece defense)) (power (piece attack))) (kill! defense) void))
  (method [(attack (compose? (list bomb? piece))) (defense true)]
          (kill! attack)
          (kill! defense))
  (method [(attack true) (defense (compose? (list bomb? piece)))]
          (kill! attack)
          (kill! defense))
  (method [(attack (compose? (list bomb? piece))) (defense (compose? (list bomb? piece)))]
          (kill! attack)
          (kill! defense)))
(collide! (piece-on-board (bomb) 1 1 1 1) (piece-on-board (bomb) 1 1 1 1))
(struct player (name handler))
(module+ main
  (display help-text))
