extends Control

func _on_plus_button_pressed():
	GlobalVars.SIM_SPEED += 1
	$AmountInput.update_count()

func _on_minus_button_pressed():
	GlobalVars.SIM_SPEED -= 1
	if GlobalVars.SIM_SPEED < 0:
		GlobalVars.SIM_SPEED = 0
	$AmountInput.update_count()

func _on_start_button_pressed():
	$Label.modulate.a = 0.5
	$AmountInput.modulate.a = 0.5
func _on_stop_button_pressed():
	$Label.modulate.a = 1.0
	$AmountInput.modulate.a = 1.0