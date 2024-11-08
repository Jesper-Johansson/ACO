extends Control

func _on_plus_button_pressed():
	GlobalVars.HEURISTIC_IMPORTANCE += 0.1
	$AmountInput.update_count()

func _on_minus_button_pressed():
	GlobalVars.HEURISTIC_IMPORTANCE-= 0.1
	if GlobalVars.HEURISTIC_IMPORTANCE < 0:
		GlobalVars.HEURISTIC_IMPORTANCE = 0
	$AmountInput.update_count()
