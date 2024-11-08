class_name Edge extends Node2D

var start: CityNode
var end: CityNode

var length
var pheromone_level: float = 0.0000001

func _draw():
	var antialiasing = true
	if GlobalVars.CITY_COUNT > 30:
		antialiasing = false
	#$BaseLine.queue_redraw()
	if GlobalVars.ACS:
		#print(pheromone_level
		#var pink_alpha = (pheromone_level - GlobalVars.MIN_PHEROMONE) / (GlobalVars.MAX_PHEROMONE - GlobalVars.MIN_PHEROMONE)
		var pink_alpha = pheromone_level / (GlobalVars.INITIAL_PHEROMONES_ACS * 3.5)
		draw_line(start.get_city_pos(), end.get_city_pos(), Color(1, 0.411, 0.705, pink_alpha), 7, antialiasing)
	else:
		draw_line(start.get_city_pos(), end.get_city_pos(), Color(1, 0.411, 0.705, (pheromone_level) / (1 / length)), 6, antialiasing)

func set_points(a: CityNode, b: CityNode):
	$BaseLine.a = a
	$BaseLine.b = b
	
	start = a
	end = b
	
	length = a.get_city_pos().distance_to(b.get_city_pos())

func get_weight() -> float:
	var heuristic_value = 1.0 / length
	return (GlobalVars.BASE_WEIGHT * heuristic_value) * (pheromone_level * GlobalVars.BASE_PHEROMONE_STRENGTH)
	
func get_weight_ACS():
	var heuristic_value = 1.0 / length
	return pow(heuristic_value, GlobalVars.HEURISTIC_IMPORTANCE) * pheromone_level

func set_pheromone_level(new_pheromones: float):
	pheromone_level = new_pheromones
	#if pheromone_level < GlobalVars.MIN_PHEROMONE:
	#	GlobalVars.MIN_PHEROMONE = pheromone_level
	#elif pheromone_level > GlobalVars.MAX_PHEROMONE:
	#	GlobalVars.MAX_PHEROMONE = pheromone_level
