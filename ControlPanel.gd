extends Panel

func _on_start_button_pressed():
	$StartButton.disabled = true
	$StopButton.disabled = false
	
	$NewPosButton.disabled = true
	
	$CityAmountField/PlusButton.disabled = true
	$CityAmountField/MinusButton.disabled = true
	$CityAmountField/AmountInput.focus_mode = FOCUS_NONE
	
	$AntAmountField/PlusButton.disabled = true
	$AntAmountField/MinusButton.disabled = true
	$AntAmountField/AmountInput.focus_mode = FOCUS_NONE
	
	$ACSCheck.disabled = true

func _on_stop_button_pressed():
	$StartButton.disabled = false
	$StopButton.disabled = true
	
	$NewPosButton.disabled = false
	
	$CityAmountField/PlusButton.disabled = false
	$CityAmountField/MinusButton.disabled = false
	$CityAmountField/AmountInput.focus_mode = FOCUS_CLICK
	
	$AntAmountField/PlusButton.disabled = false
	$AntAmountField/MinusButton.disabled = false
	$AntAmountField/AmountInput.focus_mode = FOCUS_CLICK
	
	$ACSCheck.disabled = false
	
func _on_acs_check_toggled(toggled_on):
	$EdgeWeightField/PlusButton.disabled = toggled_on
	$EdgeWeightField/MinusButton.disabled = toggled_on
	$PheromoneField/PlusButton.disabled = toggled_on
	$PheromoneField/MinusButton.disabled = toggled_on
	$ExploitationField/PlusButton.disabled = !toggled_on
	$ExploitationField/MinusButton.disabled = !toggled_on
	$HeuristicField/PlusButton.disabled = !toggled_on
	$HeuristicField/MinusButton.disabled = !toggled_on
	if toggled_on:
		GlobalVars.PHEROMONE_DECAY = 0.1
		$EdgeWeightField/AmountInput.focus_mode = FOCUS_NONE
		$EdgeWeightField/AmountInput.modulate.a = 0.5
		$EdgeWeightField/Label.modulate.a = 0.5
		$PheromoneField/AmountInput.focus_mode = FOCUS_NONE
		$PheromoneField/AmountInput.modulate.a = 0.5
		$PheromoneField/Label.modulate.a = 0.5
		$ExploitationField/AmountInput.modulate.a = 1.0
		$ExploitationField/Label.modulate.a = 1.0
		$HeuristicField/AmountInput.modulate.a = 1.0
		$HeuristicField/Label.modulate.a = 1.0
	else:
		GlobalVars.PHEROMONE_DECAY = 0.4
		$EdgeWeightField/AmountInput.focus_mode = FOCUS_CLICK
		$EdgeWeightField/AmountInput.modulate.a = 1.0
		$EdgeWeightField/Label.modulate.a = 1.0
		$PheromoneField/AmountInput.focus_mode = FOCUS_CLICK
		$PheromoneField/AmountInput.modulate.a = 1.0
		$PheromoneField/Label.modulate.a = 1.0
		$ExploitationField/AmountInput.modulate.a = 0.5
		$ExploitationField/Label.modulate.a = 0.5
		$HeuristicField/AmountInput.modulate.a = 0.5
		$HeuristicField/Label.modulate.a = 0.5
		
	$DecayField/AmountInput.update_count()


func _on_import_button_pressed():
	$ImportPanel.visible = true
func _on_cancel_button_pressed():
	$ImportPanel.visible = false
func _on_confirm_button_pressed():
	var imported_text: String = $ImportPanel/TextEdit.text
	imported_text = imported_text.strip_edges(true, true)
	var extracted_nodes: Array = []
	print(JSON.stringify(imported_text))
	
	
			
