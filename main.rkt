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
(define (show! x) (set-piece-on-board-shown?! x true))
(define (kill! x) (display (string-append (text x) " is killed")) (newline))
(struct bomb ())
(struct flag ())
(struct mine ())
(define piece piece-on-board-piece)
(define shown? piece-on-board-shown?)
(struct normal-piece (rank))
(defgeneric movable?
  (method [(_ normal-piece?)] true)
  (method [(_ bomb?)] true)
  (method [(_ flag?)] false)
  (method [(_ mine?)] false))
(define (text p) (if (shown? p) (name (piece p)) unknown-piece-text))
(defgeneric name
  (method [(p normal-piece?)]
          (let ((r (rank p)))
            (cond [((eq? r 1) "command officer")]
                  [((eq? r 2) "general")]
                  [((eq? r 3) "division leader")]
                  [((eq? r 4) "brigadier")]
                  [((eq? r 5) "colonel")]
                  [((eq? r 6) "lieutenant colonel")]
                  [((eq? r 7) "captain")]
                  [((eq? r 8) "platoon leader")]
                  [((eq? r 9) "combat engineer")])))
  (method [(_ bomb?)] "bomb")
  (method [(_ flag?)] "flag")
  (method [(_ mine?)] "mine"))
(define rank normal-piece-rank)
(define combat-engineer? (and? normal-piece? (lambda (p) (eq? (rank p) 9))))
(defgeneric collide!
  (method [(attack (compose? (list normal-piece? piece))) (defense (compose? (list normal-piece? piece)))]
          (if (<= (rank (piece attack)) (rank (piece defense))) (kill! defense) void)
          (if (<= (rank (piece defense)) (rank (piece attack))) (kill! attack) void))
  (method [(attack (compose? (list bomb? piece))) (defense true)]
          (kill! attack)
          (kill! defense))
  (method [(attack true) (defense (compose? (list bomb? piece)))]
          (kill! attack)
          (kill! defense))
  (method [(attack (compose? (list bomb? piece))) (defense (compose? (list bomb? piece)))]
          (kill! attack)
          (kill! defense))
  (method [(attack true) (defense (compose? (list flag? piece)))]
          (kill! defense))
  (method [(attack (compose? (list not combat-engineer? piece))) (defense (compose? (list mine? piece)))]
          (kill! attack)
          (kill! defense))
  (method [(attack (compose? (list combat-engineer? piece))) (defense (compose? (list mine? piece)))]
          (kill! defense)))
(collide! (piece-on-board (bomb) true 1 1 1) (piece-on-board (bomb) false 1 1 1))
(struct player (name handler))
(module+ main
  (display help-text))
