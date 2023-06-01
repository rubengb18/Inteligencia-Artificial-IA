;FACTS ASSERTED BY GAME INPUT, INFO ABOUT THE ACTUAL TICK OF THE GAME
(deftemplate GHOSTS
	(slot anyChasing (type SYMBOL))
	(slot numberOfChasing (type INTEGER))
	(slot closestChasing (type SYMBOL))
	(slot distanceClosestChasing (type INTEGER))
	(slot secondChasing (type SYMBOL))
	(slot distanceSecondChasing (type INTEGER))
	(slot thirdChasing (type SYMBOL))
	(slot distanceThirdChasing (type INTEGER))
	(slot fourthChasing (type SYMBOL))
	(slot distanceFourthChasing (type INTEGER))
	(slot anyEdible (type SYMBOL))
	(slot allEdible (type SYMBOL))
	(slot closestEdible (type SYMBOL))
	(slot distanceClosestEdible (type INTEGER))
)

(deftemplate MSPACMAN
	(slot msPacManNode (type INTEGER))
	(slot msPacManMove (type SYMBOL))
)
	
(deftemplate INFO
	(slot nearestPill (type INTEGER))
	(slot distanceNearestPill (type INTEGER))
	(slot nearestPPill (type INTEGER))
	(slot distanceNearestPPill (type INTEGER))
	(slot numberOfLives (type INTEGER))
	(slot timeLeft (type INTEGER))
	(slot level (type INTEGER))
	(slot score (type INTEGER))
	(slot numberPillsLeft (type INTEGER))
	(slot numberPPillsLeft (type INTEGER))
)


;POSSIBLE ACTION FACTS
; randomMove: Descripcion => Movimiento aleatorio 
;             Extra Facts necesarios => ninguno
; runAway: Descripcion => Huir de un fantasma dado 
;          Extra Facts necesarios => ghost
; survive: Descripcion => Huir de los fantasmas no comestibles mas cercanos 
;          Extra Facts necesarios => closestChasing, secondChasing
; goToPill: Descripcion => Ir hacia la ubicacion de una pill
;           Extra Facts necesarios => pillNode
; goToPowerPill: Descripcion => Ir hacia la ubiacion de una powerPill 
;                Extra Facts necesarios => powerPillNode
; chaseGhost: Descripcion => Perseguir a un fantasma sea comestible o no
;             Extra Facts necesarios => ghost


;DEFINITION OF THE ACTION FACT
(deftemplate ACTION
	(slot id)
	(slot info (default ""))
	(slot pillNode (type INTEGER))
	(slot powerPillNode (type INTEGER))
	(slot ghost (type SYMBOL))
	(slot closestChasing (type SYMBOL))
	(slot secondChasing (type SYMBOL))
)


;DEFINITION OF THE RULES

(defrule MSPACMANrunsAway
	(declare (salience 1))
	(GHOSTS (anyChasing true) (closestChasing ?c) (distanceClosestChasing ?d))
	(test (<= ?d 50))
	=>
	(assert 
	(ACTION (id runAway) (info "Fantasma no comestible cerca --> huir de el") (ghost ?c))
	)
)

(defrule MSPACMANrandomMove
	(declare (salience -1))
	(GHOSTS (anyChasing true))
	=>
	(assert 
	(ACTION (id randomMove) (info "Fantasma no comestible lejos --> mover aleatoriamente"))
	)
)

(defrule MSPACMANeatpill
	(declare (salience -1))
	(INFO (nearestPill ?p) (distanceNearestPill ?d))
	(test (<= ?d 40))
	=>
	(assert 
	(ACTION (id goToPill) (info "Pill cerca --> me la como") (pillNode ?p))
	)
)

(defrule MSPACMANhurryup
	(declare (salience -1))
	(INFO (nearestPill ?p) (distanceNearestPill ?d) (timeLeft ?t))
	(test (<= ?t 1000))
	(test (<= ?d 150))
	=>
	(assert 
	(ACTION (id goToPill) (info "Hay que acabar --> a por pills") (pillNode ?p))
	)
)

(defrule MSPACMANchase
	(GHOSTS (allEdible true) (closestEdible ?c) (distanceClosestEdible ?d))
	(test (<= ?d 100))
	=>
	(assert 
	(ACTION (id chaseGhost) (info "Fanstasmas no peligrosos --> perseguir al mas cercano si está cerca") (ghost ?c))
	)
)

(defrule MSPACMANchaseconditional
	(GHOSTS (anyEdible true) (closestEdible ?c) (distanceClosestChasing ?dc) (distanceClosestEdible ?de) )
	(test (>= ?dc 60))
	(test (<= ?de 40))
	=>
	(assert 
	(ACTION (id chaseGhost) (info "Fanstasmas no peligrosos --> perseguir al mas cercano si está cerca") (ghost ?c))
	)
)

(defrule MSPACMANgotoppill
	(INFO (nearestPPill ?pp) (distanceNearestPPill ?d) )
	(GHOSTS (anyEdible false) (anyChasing true) (distanceClosestChasing ?dc))
	(test (<= ?d 40))
	(test (> ?d -1))
	(test (<= ?dc 40))
	=>
	(assert 
	(ACTION (id goToPowerPill) (info "PowerPill cerca --> Comer PowerPill") (powerPillNode ?pp))
	)
)



