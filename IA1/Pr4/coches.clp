
	
;FACTS ASSERTED BY GAME INPUT, INFO ABOUT THE ACTUAL TICK OF THE GAME

; economia: poder adquisitivo del cliente o cuanto esta dispuesto a gastar por su auto
; autonomia: viaje mas largo que va a realizar el cliente o autonomia que precisa del auto
; ptos_recarga: facilidad que tiene para encontrar puntos de recarga en su entorno
; modelos: núero de modelos a la venta de la tecnología 
; potencia: requerimientos en potencia del cliente (remolques, performance)
; km_anuales: uso del coche para tener en cuenta consumo y reparaciones
; conciencia: valor que le da el cliente a las emisiones de su vehiculo

;;;;;;;;;;;;;;;;;;
;;;DEFFUNCTIONS;;;
;;;;;;;;;;;;;;;;;;

(deffunction ask-question (?question $?allowed-values)
   (printout t ?question)
   (bind ?answer (read))
   (if (lexemep ?answer) 
       then (bind ?answer (lowcase ?answer)))
   (while (not (member$ ?answer ?allowed-values)) do
      (printout t ?question)
      (bind ?answer (read))
      (if (lexemep ?answer) 
          then (bind ?answer (lowcase ?answer))))
   ?answer)

(deffunction yes-or-no-p (?question)
   (bind ?response (ask-question ?question yes no y n))
   (if (or (eq ?response yes) (eq ?response y))
       then yes 
       else no))

;DEFINITION OF THE RULES

(defrule determine-economia ""
   (not (economia ?))
   (not (eleccion ?))
   =>
   (assert (economia (ask-question "¿Cuanto quieres gastar anualmente (como maximo) en mantenimiento en tu coche? (2000 10000 50000)" 2000 10000 50000))))

(defrule determine-autonomia ""
   (not (autonomia ?))
   (not (eleccion ?))
   =>
   (assert (autonomia (ask-question "¿De cuantos cientos de km es el viaje mas largo que piensas hacer con el coche sin parar? (200 500 800 +800)" 200 500 800 +800))))

(defrule determine-ptos_recarga ""
   (not (ptos_recarga ?))
   (not (eleccion ?))
   =>
   (assert (ptos_recarga (ask-question "¿Del 1 al 5 cuanto te importa desplazarte para repostar/recargar? (Siendo 5 me perturba mucho, y 1 me da igual) " 1 2 3 4 5))))
   
(defrule determine-modelos ""
   (not (modelos ?))
   (not (eleccion ?))
   =>
   (assert (modelos (ask-question "Del 1 al 5 cuanto te impaorta tener una amplia oferta de modelos " 1 2 3 4 5))))
   
(defrule determine-potencia ""
   (not (potencia ?))
   (not (eleccion ?))
   =>
   (assert (potencia (ask-question "¿Que importancia le das a una entrega rápida de potencia por parte del motor del 1 al 5? " 1 2 3 4 5))))
   
(defrule determine-km_anuales ""
   (not (km_anuales ?))
   (not (eleccion ?))
   =>
   (assert (km_anuales (ask-question "En miles de km, cual es el uso que hara del coche anualmente (10 20 30 40 50)" 10 20 30 40 50))))
   
(defrule determine-conciencia ""
   (not (conciencia ?))
   (not (eleccion ?))
   =>
   (assert (conciencia (ask-question "Cual es la minima etiqueta medioambiental que esta dispuesto a admitir en su coche nuevo? (cero/eco/b/c/d)? " cero eco b c d))))

;;;;;;;;;;;;;;;;;;
;;;CHOICE RULES;;;;;;;;;;;;;;;;;;;;;
(defrule electrico ""
   (not (electrico ?))(gasolina no)(diesel no)(hibrido no)(gnc no)(glp no)(enchufable no)
   =>
   (assert (eleccion electrico))))

(defrule gasolina ""
   (not (gasolina ?))(electrico no)(diesel no)(hibrido no)(gnc no)(glp no)(enchufable no)
   =>
   (assert (eleccion gasolina))))

(defrule diesel ""
   (not (diesel ?))(gasolina no)(electrico no)(hibrido no)(gnc no)(glp no)(enchufable no)
   =>
   (assert (eleccion diesel))))

(defrule hibrido ""
   (not (hibrido ?))(gasolina no)(electrico no)(diesel no)(gnc no)(glp no)(enchufable no)
   =>
   (assert (eleccion hibrido))))

(defrule gnc ""
   (not (gnc ?))(gasolina no)(electrico no)(hibrido no)(diesel no)(glp no)(enchufable no)
   =>
   (assert (eleccion gnc))))

(defrule glp ""
   (not (glp ?))(gasolina no)(electrico no)(hibrido no)(gnc no)(diesel no)(enchufable no)
   =>
   (assert (eleccion glp))))

(defrule enchufable ""
   (not (enchufable ?))(gasolina no)(electrico no)(hibrido no)(gnc no)(glp no)(diesel no)
   =>
   (assert (eleccion enchufable))))


;;;;;;;;;;;;;;;
;;;DESCARTES;;;
;;;;;;;;;;;;;;;

(defrule conc-eco ""
   (conciencia eco)
   =>
   (assert (gasolina no) (diesel no) (gnc no) (glp no))))

(defrule conc-cero ""
   (conciencia cero)
    =>
   (assert (gasolina no)(diesel no)(hibrido no)(gnc no)(glp no)(enchufable no))))

(defrule conc-b ""
   (conciencia b) 
   =>
   (assert (diesel no)))

  
(defrule ptos_recarga-muyimp ""
	(ptos_recarga ?p)
        (test (= ?p 5)) 
   =>
   (assert (electrico no)(enchufable no)))

(defrule ptos_recarga-imp ""
	(ptos_recarga ?p)
        (test (> ?p 3))
   =>
   (assert (gnc no)))

(defrule autonomia-+800 ""
	(autonomia +800) 
   =>
   (assert (electrico no)))

(defrule econ/km-gasolina ""
       (km_anuales ?km) (economia ?econ)
       (test (< ?econ (* (+ 5 95) ?km)))
   =>
   (assert (gasolina no)))

(defrule econ/km-diesel ""
       (km_anuales ?km) (economia ?econ)
       (test (< ?econ (* (+ 5 66) ?km)))
   =>
   (assert (diesel no)))

(defrule econ/km-hibrido ""
       (km_anuales ?km) (economia ?econ)
       (test (< ?econ (* (+ 10 75) ?km)))
   =>
   (assert (hibrido no)))

(defrule econ/km-enchufable ""
       (km_anuales ?km) (economia ?econ)
       (test (< ?econ (* (+ 10 55) ?km)))
   =>
   (assert (enchufable no)))

(defrule econ/km-glp ""
       (km_anuales ?km) (economia ?econ)
       (test (< ?econ (* (+ 7 64) ?km)))
   =>
   (assert (glp no)))

(defrule econ/km-gnc ""
       (km_anuales ?km) (economia ?econ)
       (test (< ?econ (* (+ 7 39) ?km)))
   =>
   (assert (gnc no)))

(defrule econ/km-electrico ""
       (km_anuales ?km) (economia ?econ)
       (test (< ?econ (* (+ 7 30) ?km)))
   =>
   (assert (electrico no)))

(defrule modelo-imp ""
       (modelos ?m)
       (test (> ?m 3))
   =>
   (assert (gnc no)(glp no)))

(defrule modelo-muyimp ""
       (modelos ?m)
       (test (= ?m 5))
   =>
   (assert (enchufable no)(electrico no)))

(defrule potrncia-imp ""
       (potencia ?p)
       (test (> ?p 3))
   =>
   (assert (gnc no)(diesel no)))

(defrule potrncia-muyimp ""
       (potencia ?p)
       (test (= ?p 5))
   =>
   (assert (glp no)(gasolina no)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;STARTUP AND CONCLUSION RULES;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defrule system-banner ""
  (declare (salience 10))
  =>
  (printout t crlf crlf)
  (printout t "Sistema experto de recomendación de coches")
  (printout t crlf crlf))

(defrule print-eleccion ""
  (declare (salience 5))
  (eleccion ?item)
  =>
  (printout t crlf crlf)
  (printout t "Eleccion sugerida:")
  (printout t crlf crlf)  (printout t "El vehiculo que cumple sus especificaciones es")
  (format t " %s%n%n%n" ?item))
  (defrule print-elecciones ""  (declare (salience 4))  (not (eleccion ?))(conciencia ?)(km_anuales ?)(potencia ?)(modelos ?)(ptos_recarga ?)(autonomia ?)(economia ?)  =>  (printout t crlf crlf)  (printout t "Elecciones sugeridas:")  (printout t crlf crlf)  (printout t "Los vehiculos que cumple sus especificaciones son "))    (defrule print-elec-gas ""  (not (gasolina no))(not (eleccion ?))(conciencia ?)(km_anuales ?)(potencia ?)(modelos ?)(ptos_recarga ?)(autonomia ?)(economia ?)  =>  (printout t "gasolina "))    (defrule print-elec-die ""  (not (diesel  no))(not (eleccion ?))(conciencia ?)(km_anuales ?)(potencia ?)(modelos ?)(ptos_recarga ?)(autonomia ?)(economia ?)  =>  (printout t "diesel "))    (defrule print-elec-elec ""  (not (electrico no))(not (eleccion ?))(conciencia ?)(km_anuales ?)(potencia ?)(modelos ?)(ptos_recarga ?)(autonomia ?)(economia ?)  =>  (printout t "electrico "))    (defrule print-elec-hib ""  (not (hibrido no))(not (eleccion ?))(conciencia ?)(km_anuales ?)(potencia ?)(modelos ?)(ptos_recarga ?)(autonomia ?)(economia ?)  =>  (printout t "hibrido "))    (defrule print-elec-ench ""  (not (enchufable no))(not (eleccion ?))(conciencia ?)(km_anuales ?)(potencia ?)(modelos ?)(ptos_recarga ?)(autonomia ?)(economia ?)  =>  (printout t "enchufable "))    (defrule print-elec-gnc ""  (not (gnc no))(not (eleccion ?))(conciencia ?)(km_anuales ?)(potencia ?)(modelos ?)(ptos_recarga ?)(autonomia ?)(economia ?)  =>  (printout t "gnc "))    (defrule print-elec-glp ""  (not (glp no))(not (eleccion ?))(conciencia ?)(km_anuales ?)(potencia ?)(modelos ?)(ptos_recarga ?)(autonomia ?)(economia ?)  =>  (printout t "glp "))