	
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
(defrule SUEsepararseBlinky
	(SUE (distanceNearestGhost ?d)) (test (not (= ?d -1)))
	(BLINKY (nearestGhost ?gg))
	(MSPACMAN (distanceNearestPPill ?n))
	(test (= ?gg SUE)) (test (< ?d 10)) (test (< ?n 40))
	=>
	(assert (ACTION (id SUErunAwayFromGhost) (info "Blinky y Pacman estan cerca --> separarse de el") (ghost BLINKY)))
)


(defrule SUEdefiendePowerPill
	(SUE (edibleTime ?t) (distanceToPacmanNearestPPill ?p)) (test (not (= ?p -1)))
	(MSPACMAN (nearestPPill ?np))
	(INFO (numberPPillsLeft ?pp))
	(test (< ?t 10)) (test (< ?pp 2))
	=>
	(assert (ACTION (id SUEmoveToPPill) (info "Mas cerca de powerpill que MsPacMan --> Defender powerpill") (powerPillNode ?np)))
)

(defrule SUEconBlinky
	
	=>
	(assert (ACTION (id SUEchaseGhost) (info "Para cazar con Blinky ----> voy con el") (ghost BLINKY)))
)

(defrule SUEhuye
	(SUE (edible true))
	=>
	(assert (ACTION (id SUErunAway) (info "Comestible --> huir")))
)
(defrule SUEhuye2
	(declare (salience 1))
	(MSPACMAN (distanceNearestPPill ?n))
	(test (< ?n 80))
	=>
	(assert (ACTION (id SUErunAway) (info "Comestible en breve --> huir")))
)
	
(defrule SUEaPorMsPacMan
	(SUE (edible false) (distancePacman ?d)) (test (not (= ?d -1)))
	(test (< ?d 35))
	=>
	(assert (ACTION (id SUEchasePacman) (info "MsPacMan vulnerable --> perseguir")))
)

(defrule SUEaleatorio
	=>
	(assert (ACTION (id SUErandomMove) (info "Ninguna regla se cumple --> mover aleatoriamente")))
)