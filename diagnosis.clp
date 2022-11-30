(deftemplate Diagnosis
	(slot diagnosis-name)
	(multislot list-symptoms)
)

(deftemplate Symptoms
	(slot symptom-id)
)

(deffacts SymptomDiagnosis
	(Diagnosis(diagnosis-name 0)(list-symptoms HBsAg1 AntiHDV0 AntiHBc1 AntiHBs1))			    ;Uncertain Configuration
  (Diagnosis(diagnosis-name 0)(list-symptoms HBsAg1 AntiHDV0 AntiHBc0))				        ;Uncertain Configuration
	(Diagnosis(diagnosis-name 1)(list-symptoms HBsAg1 AntiHDV0 AntiHBc1 AntiHBs0 IgMAntiHBc1))	;Acute Infection			
	(Diagnosis(diagnosis-name 2)(list-symptoms HBsAg1 AntiHDV0 AntiHBc1 AntiHBs0 IgMAntiHBc0))	;Chronic Infection
	(Diagnosis(diagnosis-name 3)(list-symptoms HBsAg1 AntiHDV1))			                    ;Hepatitis B+D
	(Diagnosis(diagnosis-name 4)(list-symptoms HBsAg0 AntiHBs1 AntiHBc1)) 		                ;Cured
	(Diagnosis(diagnosis-name 5)(list-symptoms HBsAg0 AntiHBs1 AntiHBc0))                       ;Vaccinated
  (Diagnosis(diagnosis-name 6)(list-symptoms HBsAg0 AntiHBs0 AntiHBc1))                       ;Unclear (Possible resolved)
  (Diagnosis(diagnosis-name 7)(list-symptoms HBsAg0 AntiHBs0 AntiHBc0))                       ;Healthy not Vaccinated or suspicious
	(match inProgress))

(deffunction AskQuestion (?question)
	(printout t ?question)
	(bind ?answer (read))
	(if (lexemep ?answer)
		then (bind ?answer (lowcase ?answer)))
	(while (not (or (eq ?answer positive) (eq ?answer negative))) do
		(printout t ?question)
		(bind ?answer (read))
		(if (lexemep ?answer)
			then (bind ?answer (lowcase ?answer))))
	?answer
)

(deffunction PositiveorNegative (?question)
	(bind ?response (AskQuestion ?question))
	(if (eq ?response positive)
		then positive
		else negative)
)

(defrule AskHBsAg
    (not(HBsAg ?))
    =>
    (bind ?HBsAg (PositiveorNegative "HBsAg? "))
    (assert (HBsAg ?HBsAg))
    (if (eq ?HBsAg positive)
        then (assert (Symptoms(symptom-id HBsAg1)))
        else (assert (Symptoms(symptom-id HBsAg0))))
)

(defrule AskAntiHBs
    (and 
        (not(AntiHBs ?))
        (or 
            (and (HBsAg negative))
            (and (HBsAg positive) (AntiHDV negative) (AntiHBc positive))))
    =>
    (bind ?AntiHBs (PositiveorNegative "AntiHBs? "))
    (assert (AntiHBs ?AntiHBs))
    (if (eq ?AntiHBs positive)
        then (assert(Symptoms(symptom-id AntiHBs1)))
        else (assert(Symptoms(symptom-id AntiHBs0))))
)

(defrule AskAntiHBc
    (and 
        (not(AntiHBc ?))
        (or 
            (and (HBsAg negative) (AntiHBs ?))
            (and (HBsAg positive) (AntiHDV negative))))
    =>
    (bind ?AntiHBc (PositiveorNegative "AntiHBc? "))
    (assert (AntiHBc ?AntiHBc))
    (if (eq ?AntiHBc positive)
        then (assert(Symptoms(symptom-id AntiHBc1)))
        else (assert(Symptoms(symptom-id AntiHBc0))))
)

(defrule AskAntiHDV
    (HBsAg positive)
    (not(AntiHDV ?))
    =>
    (bind ?AntiHDV (PositiveorNegative "AntiHDV? "))
    (assert (AntiHDV ?AntiHDV))
    (if (eq ?AntiHDV positive)
        then (assert(Symptoms(symptom-id AntiHDV1)))
        else (assert(Symptoms(symptom-id AntiHDV0))))
)
(defrule AskIgMAntiHBc
    (HBsAg positive)
    (AntiHDV negative)
    (AntiHBc positive)
    (AntiHBs negative)
    (not(IgMAntiHBc ?))
    =>
    (bind ?IgMAntiHBc (PositiveorNegative "IgMAntiHBc? "))
    (assert (IgMAntiHBc ?IgMAntiHBc))
    (if (eq ?IgMAntiHBc positive)
        then (assert(Symptoms(symptom-id IgMAntiHBc1)))
        else (assert(Symptoms(symptom-id IgMAntiHBc0))))
)

(defrule All-symptoms
	(Diagnosis(diagnosis-name ?id))
	(forall(Diagnosis(diagnosis-name ?id)(list-symptoms $? ?symptom $?))
		(Symptoms(symptom-id ?symptom))) 
	=>
	(assert (matchID ?id))
)

(defrule Result1
	(matchID 0)
	=>
	(printout t "Hasil Prediksi: Unclear Configuration" crlf)
	(assert(match yes)))
	
(defrule Result1
	(matchID 1)
	=>
	(printout t "Hasil Prediksi: Acute Infection" crlf)
	(assert(match yes)))
	
(defrule Result2
	(matchID 2)
	=>
	(printout t "Hasil Prediksi: Chronic Infection" crlf)
	(assert(match yes)))
	
(defrule Result3
	(matchID 3)
	=>
	(printout t "Hasil Prediksi: Hepatitis B+D" crlf)
	(assert(match yes)))
	
(defrule Result4
	(matchID 4)
	=>
	(printout t "Hasil Prediksi: Cured" crlf)
	(assert(match yes)))
				
(defrule Result5	
	(matchID 5)
	=>
	(printout t "Hasil Prediksi: Vaccinated" crlf)
	(assert(match yes)))	

(defrule Result6	
	(matchID 6)
	=>
	(printout t "Hasil Prediksi: Unclear (Possibly Resolved)" crlf)
	(assert(match yes)))	

(defrule Result7	
	(matchID 7)
	=>
	(printout t "Hasil Prediksi: Healthy not Vaccinated or suspicious" crlf)
	(assert(match yes)))	
	
(defrule startUp
	(match inProgress)
	=>
	(printout t "Thank you for choosing this expert system. Please answer the following questions." crlf))