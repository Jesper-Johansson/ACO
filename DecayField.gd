extends Control

func _on_plus_button_pressed():
	GlobalVars.PHEROMONE_DECAY += 0.1
	$AmountInput.update_count()

func _on_minus_button_pressed():
	GlobalVars.PHEROMONE_DECAY -= 0.1
	if GlobalVars.PHEROMONE_DECAY < 0:
		GlobalVars.PHEROMONE_DECAY= 0
	$AmountInput.update_count()
