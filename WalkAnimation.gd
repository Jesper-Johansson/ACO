extends AnimationPlayer

func _process(delta):
	speed_scale = 12 * (GlobalVars.SIM_SPEED / 300)
