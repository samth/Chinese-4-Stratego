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
(struct piece (text))
(struct piece-on-board (piece pos board shown?) #:mutable)
(define kill! error)
(define (compose f g) (lambda (x) (f (g x))))
(struct normal-piece piece (power))
(defgeneric collide!
  (method [(attack (compose normal-piece? piece-on-board-piece)) (defense (compose normal-piece? piece-on-board-piece))]
          (if (<= (normal-piece-power (piece-on-board-piece attack)) (normal-piece-power (piece-on-board-piece defense))) (kill! attack) void)
          (if (<= (normal-piece-power (piece-on-board-piece defense)) (normal-piece-power (piece-on-board-piece attack))) (kill! attack) void)))
(module+ main
  (display help-text))
