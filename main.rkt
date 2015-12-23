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
(define (kill! x) (display (string-append (text (pobp x)) " is killed")) (newline))
(define (compose f g) (lambda (x) (f (g x))))
(define (text n) "...")
(struct normal-piece (power))
(struct bomb ())
(define pobp piece-on-board-piece)
(define power normal-piece-power)
(define (const x) (lambda _ x))
(defgeneric collide!
  (method [(attack (compose normal-piece? pobp)) (defense (compose normal-piece? pobp))]
          (if (<= (power (pobp attack)) (power (pobp defense))) (kill! attack) void)
          (if (<= (power (pobp defense)) (power (pobp attack))) (kill! defense) void))
  (method [(attack (compose? (list bomb? pobp))) (defense true)]
          (kill! attack)
          (kill! defense))
  (method [(attack true) (defense (compose? (list bomb? pobp)))]
          (kill! attack)
          (kill! defense))
  (method [(attack (compose? (list bomb? pobp))) (defense (compose? (list bomb? pobp)))]
          (kill! attack)
          (kill! defense)))
(collide! (piece-on-board (bomb) 1 1 1 1) (piece-on-board (bomb) 1 1 1 1))
(struct player (name handler))
(module+ main
  (display help-text))
