	
;FACTS ASSERTED BY GAME INPUT, INFO ABOUT THE ACTUAL TICK OF THE GAME
(deftemplate BLINKY
	(slot edible (type SYMBOL))
	(slot edibleTime (type INTEGER))
	(slot nearestGhost (type SYMBOL))
	(slot distanceNearestGhost (type INTEGER))
	(slot distanceToPacmanNearestPPill (type INTEGER))
	(slot distancePacman (type INTEGER))
)
	
(deftemplate INKY
	(slot edible (type SYMBOL))
	(slot edibleTime (type INTEGER))
	(slot nearestGhost (type SYMBOL))
	(slot distanceNearestGhost (type INTEGER))
	(slot distanceToPacmanNearestPPill (type INTEGER))
	(slot distancePacman (type INTEGER))
)
	
(deftemplate PINKY
	(slot edible (type SYMBOL))
	(slot edibleTime (type INTEGER))
	(slot nearestGhost (type SYMBOL))
	(slot distanceNearestGhost (type INTEGER))
	(slot distanceToPacmanNearestPPill (type INTEGER))
	(slot distancePacman (type INTEGER))
)

(deftemplate SUE
	(slot edible (type SYMBOL))
	(slot edibleTime (type INTEGER))
	(slot nearestGhost (type SYMBOL))
	(slot distanceNearestGhost (type INTEGER))
	(slot distanceToPacmanNearestPPill (type INTEGER))
	(slot distancePacman (type INTEGER))
)
	
(deftemplate MSPACMAN
    (slot nearestGhost (type SYMBOL))
    (slot distanceNearestGhost (type INTEGER))
    (slot nearestEdibleGhost (type SYMBOL))
    (slot distanceNearestEdibleGhost (type INTEGER))
    (slot nearestPPill (type INTEGER))
    (slot distanceNearestPPill (type INTEGER))
)	

(deftemplate INFO
	(slot numberOfLives (type INTEGER))
	(slot timeLeft (type INTEGER))
	(slot level (type INTEGER))
	(slot score (type INTEGER))
	(slot numberPillsLeft (type INTEGER))
	(slot numberPPillsLeft (type INTEGER))
)


;POSSIBLE ACTION FACTS (X = ghost name in capital letters {BLINKY, INKY, PINKY, SUE})
; XrandomMove: Descripcion => Movimiento aleatorio 
;             Extra Facts necesarios => ninguno
; XchasePacman: Descripcion => Perseguir a MsPacMan 
;          Extra Facts necesarios => ninguno
; XchaseGhost: Descripcion => Ir hacia otro de los fantasmas 
;          Extra Facts necesarios => ghost
; XmoveToPPill: Descripcion => Ir hacia la ubicacion de una powerPill 
;           Extra Facts necesarios => powerPillNode
; XrunAway: Descripcion => Huir de MsPacMan 
;           Extra Facts necesarios => ninguno
; XrunAwayFromGhost: Descripcion => Alejarse de uno de los fanstasmas
;                    Extra Facts necesarios => ghost
; XrunAwayFromPosition: Descripcion => Alejarse de una posicion
;                       Extra Facts necesarios => position


;DEFINITION OF THE ACTION FACT
(deftemplate ACTION
	(slot id)
	(slot info (default ""))
	(slot ghost (type SYMBOL))
	(slot powerPillNode (type INTEGER))
	(slot position (type INTEGER))
)


;DEFINITION OF THE RULES
;EXAMPLES:
(defrule BLINKYsepararseInky
	(BLINKY (distanceNearestGhost ?d)) (test (not (= ?d -1)))
	(INKY (nearestGhost ?gg))
	(test (= ?gg BLINKY)) (test (< ?d 25))
	=>
	(assert (ACTION (id BLINKYrunAwayFromGhost) (info "Inky esta muy cerca --> separarse de el") (ghost INKY)))
)
(defrule BLINKYsepararseSue
	(BLINKY (distanceNearestGhost ?d)) (test (not (= ?d -1)))
	(SUE (nearestGhost ?gg))
	(test (= ?gg BLINKY)) (test (< ?d 10))
	=>
	(assert (ACTION (id BLINKYrunAwayFromGhost) (info "Sue esta muy cerca --> separarse de el") (ghost SUE)))
)
(defrule BLINKYsepararsePinky
	(BLINKY (distanceNearestGhost ?d)) (test (not (= ?d -1)))
	(PINKY (nearestGhost ?gg))
	(test (= ?gg BLINKY)) (test (< ?d 10))
	=>
	(assert (ACTION (id BLINKYrunAwayFromGhost) (info "Pinky esta muy cerca --> separarse de el") (ghost PINKY)))
)
;----Separarse de sus compañeros para cazar



(defrule BLINKYhuye
	(BLINKY (edible true))
	=>
	(assert (ACTION (id BLINKYrunAway) (info "Comestible --> huir")))
)
(defrule BLINKYhuye2
	(declare (salience 1))
	(MSPACMAN (distanceNearestPPill ?n))
	(test (< ?n 30))
	=>
	(assert (ACTION (id BLINKYrunAway) (info "Comestible en breve --> huir")))
)

	
(defrule BLINKYaPorMsPacMan
	(BLINKY (edible false) (distancePacman ?d)) (test (not (= ?d -1)))
	(test (< ?d 200))
	=>
	(assert (ACTION (id BLINKYchasePacman) (info "MsPacMan vulnerable --> perseguir")))
)

(defrule BLINKYaleatorio
	=>
	(assert (ACTION (id BLINKYrandomMove) (info "Ninguna regla se cumple --> mover aleatoriamente")))
)