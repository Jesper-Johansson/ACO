extends Node2D

var a
var b

func _draw():
	var thickness = 6.0
	var alpha = 0.3
	var antialiasing = true
	if GlobalVars.CITY_COUNT > 25:
		thickness = (6.0 * (pow((1 - 0.045), GlobalVars.CITY_COUNT - 25)))
		alpha = (0.3 * (pow((1 - 0.045), GlobalVars.CITY_COUNT - 25)))
		antialiasing = false
	draw_line(a.get_city_pos(), b.get_city_pos(), Color(0.5, 0.5, 0.5, 0.3), thickness, true)
