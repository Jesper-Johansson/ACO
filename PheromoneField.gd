extends Control

func _on_plus_button_pressed():
	GlobalVars.BASE_PHEROMONE_STRENGTH += 1
	$AmountInput.update_count()

func _on_minus_button_pressed():
	GlobalVars.BASE_PHEROMONE_STRENGTH -= 1
	if GlobalVars.BASE_PHEROMONE_STRENGTH < 0:
		GlobalVars.BASE_PHEROMONE_STRENGTH = 0
	$AmountInput.update_count()
