extends Control

func _on_plus_button_pressed():
	GlobalVars.BASE_WEIGHT += 1
	$AmountInput.update_count()

func _on_minus_button_pressed():
	GlobalVars.BASE_WEIGHT -= 1
	if GlobalVars.BASE_WEIGHT < 0:
		GlobalVars.BASE_WEIGHT = 0
	$AmountInput.update_count()
