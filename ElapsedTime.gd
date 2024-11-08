extends Label

var milliseconds = 0
var seconds = 0
var minutes = 0

var last = 0

var timer_started: bool = false

func _process(delta):
	if timer_started:
		var tick_delta = Time.get_ticks_msec() - last
		last = Time.get_ticks_msec()
		milliseconds += tick_delta
		while milliseconds > 999:
			seconds += 1
			milliseconds -= 1000
		while seconds > 59:
			minutes += 1
			seconds -= 60
		update_text()


func _on_start_button_pressed():
	last = Time.get_ticks_msec()
	reset()
	timer_started = true
	
func reset():
	milliseconds = 0
	seconds = 0
	minutes = 0
	update_text()
	
func update_text():
	text = "Elapsed time:\n%02d" % minutes + ":%02d" % seconds + ":%03d" % milliseconds


func _on_stop_button_pressed():
	timer_started = false
