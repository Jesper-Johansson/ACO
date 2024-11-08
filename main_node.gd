extends Node2D

@export var cities_group: Node = null;
var ant_resource = preload("res://ant.tscn")
var ACS_ant_resource = preload("res://ant_ACS.tscn")
var cityNode = preload("res://city_node.tscn")
var edgeNode = preload("res://edge_node.tscn")
var cities: Array[CityNode] = []
var edges: Array[Edge] = []
var edges_visible: bool = true
var city_offset = GlobalVars.CITY_SIZE + (GlobalVars.CITY_SIZE * 2)
var start_label: Label
@export var ant_group: Node2D

var iteration = 1
var ants: Array = []
var solutions: Array[Solution] = []

var paused: bool = true
var best_solution: Solution = Solution.new([], INF)
var best_global_solution: Solution = Solution.new([], INF)

# Called when the node enters the scene tree for the first time.
func _ready():
	start_label = $StartLabel
	
	var positions = generate_random_positions(GlobalVars.CITY_COUNT)
	spawn_cities(positions)
	
	generate_edges()

func spawn_cities(positions):
	for city in positions:
		var node: CityNode = cityNode.instantiate()
		node.set_city_pos(city)
		cities_group.add_child(node)
		cities.append(node)
	position_start_label()
		
func generate_random_positions(amount: int):
	if GlobalVars.CITY_COUNT > 30:
		GlobalVars.CITY_SIZE = (50 * (pow((1 - 0.034), GlobalVars.CITY_COUNT - 30)))
		city_offset = GlobalVars.CITY_SIZE + (GlobalVars.CITY_SIZE * 2)
	cities = []
	var x_min: int = $Ground.position.x + 75;
	var y_min: int = $Ground.position.y + 75;
	var x_max: int = $Ground.position.x + $Ground.scale.x - 75
	var y_max: int = $Ground.position.y + $Ground.scale.y - 100
	
	var positions = [];
	
	var rng = RandomNumberGenerator.new()
	var random_x
	var random_y
	while true:
		random_x = rng.randi_range(x_min, x_max)
		random_y = rng.randi_range(y_min, y_max)
		if check_overlap(Vector2(random_x, random_y), positions):
			continue
		else:
			positions.append(Vector2(random_x, random_y))
			if positions.size() == amount:
				break
	
	return positions

func check_overlap(a: Vector2, b):
	for pos in b:	
		if (abs(a.x - pos.x) < city_offset) && (abs(a.y - pos.y) < city_offset):
			return true
	return false	

func generate_edges():
	if edges.size() > 0:
		$Ground.remove_child($Ground/Edges)
		var edges_group: Node2D = Node2D.new()
		edges_group.set_name("Edges")
		edges_group.visible = edges_visible
		$Ground.add_child(edges_group)
		edges = []
	for i in range(cities.size()):
		for k in range(i, cities.size()):
			if i != k:
				var edge = edgeNode.instantiate()
				edge.set_points(cities[i], cities[k])
				$Ground/Edges.add_child(edge)
				edges.append(edge)
				cities[i].add_connection(edge)
				cities[k].add_connection(edge)
	#print(edges.size())

func _on_new_pos_button_pressed():
	var positions = generate_random_positions(GlobalVars.CITY_COUNT)
	$Ground.remove_child($Ground/Cities)
	cities_group = Node.new()
	cities_group.set_name("Cities")
	$Ground.add_child(cities_group)
	spawn_cities(positions)
	generate_edges()

func _on_show_edges_check_toggled(button_pressed):
	pass # Replace with function body.
	edges_visible = button_pressed
	$Ground/Edges.visible = edges_visible

func position_start_label():
	start_label.position.x = cities[0].get_city_pos().x - GlobalVars.CITY_SIZE
	start_label.position.y = cities[0].get_city_pos().y + GlobalVars.CITY_SIZE * 1.25
	start_label.size.x = GlobalVars.CITY_SIZE * 2

func spawn_ants():
	for i in range(GlobalVars.ANT_AMOUNT):
		var ant: Ant = ant_resource.instantiate()
		var ant_offset: Vector2
		var rng = RandomNumberGenerator.new()
		ant_offset = Vector2(rng.randi_range(-i*5, i*5), rng.randi_range(-i*5, i*5))
		
		ant.init(cities, 0, ant_offset)
		ants.append(ant)
		ant.report_solution.connect(_on_ant_finished)
		
		ant_group.add_child(ant)
func spawn_ants_ACS():
	var rng = RandomNumberGenerator.new()
	var generated_start_indexes: Array[int] = []
	if cities.size() > GlobalVars.ANT_AMOUNT:
		var i = 0
		while i < GlobalVars.ANT_AMOUNT:
			var generated = rng.randi_range(0, cities.size()-1)
			if !generated_start_indexes.has(generated):
				generated_start_indexes.append(generated)
				i += 1
			
	else:
		for ant in range(0, GlobalVars.ANT_AMOUNT):
			generated_start_indexes.append(rng.randi_range(0, cities.size()-1))
			
	for i in range(GlobalVars.ANT_AMOUNT):
		var ant: Ant_ACS = ACS_ant_resource.instantiate()
		ant.init(cities, generated_start_indexes.pop_front())
		ants.append(ant)
		ant.report_solution.connect(_on_ACS_ant_finished) 
		ant_group.add_child(ant)

func _on_ant_finished(solution: Array[Edge]):
	#print(solution)
	#print(solution.size())
	var total_length: float = 0.0
	for edge: Edge in solution:
		total_length += edge.length
	var solution_obj = Solution.new(solution, total_length)
	solutions.append(solution_obj)
	if solution_obj.length < best_solution.length:
		best_solution = solution_obj
	if solutions.size() == ants.size():
		calculate_pheromones()
		begin_next_iteration()

var best_ACS_solution: Solution = Solution.new([], INF)
var best_global_ACS_solution: Solution = Solution.new([], INF)
func _on_ACS_ant_finished(solution: Array[Edge]):
	pass
	var total_length: float = 0.0
	for edge: Edge in solution:
		total_length += edge.length
	var solution_obj = Solution.new(solution, total_length)
	solutions.append(solution_obj)
	if total_length < best_ACS_solution.length:
		best_ACS_solution = solution_obj
		if total_length < best_global_ACS_solution.length:
			best_global_ACS_solution = solution_obj
	if solutions.size() == ants.size():
		calculate_pheromones_ACS()
		begin_next_iteration()
func calculate_pheromones():
	#print("Iteration " + str(iteration))
	#for edge in best_solution.edges:
		#edge.pheromone_level += 1
		#edge.queue_redraw()
	#print(solutions.size())
	for solution in solutions:
		for edge in solution.edges:
			edge.pheromone_level += 1 / solution.length
			#edge.pheromone_level += (1 * ((best_solution.length/solution.length)*(best_solution.length/solution.length)))
	for edge in edges:
		edge.pheromone_level = edge.pheromone_level * (1 - GlobalVars.PHEROMONE_DECAY)
		edge.queue_redraw()
func calculate_pheromones_ACS():
	for edge in edges:
		var delta_pheromone = 0.0
		if best_ACS_solution.edges.has(edge):
			delta_pheromone = pow(best_global_ACS_solution.length, -1)
		edge.set_pheromone_level(edge.pheromone_level * (1.0 - GlobalVars.PHEROMONE_DECAY) + GlobalVars.PHEROMONE_DECAY * delta_pheromone)
		
	#for edge in best_ACS_solution.edges:
	#	if best_global_ACS_solution.edges.has(edge):
	#		edge.pheromone_level += GlobalVars.PHEROMONE_DECAY * pow(best_global_ACS_solution.length, -1)
	#GlobalVars.HIGHEST_PHEROMONE = 0.0
	#for edge in edges:
	#	edge.pheromone_level = edge.pheromone_level * (1.0 - GlobalVars.PHEROMONE_DECAY)
	#	if edge.pheromone_level > GlobalVars.HIGHEST_PHEROMONE:
	#		GlobalVars.HIGHEST_PHEROMONE = edge.pheromone_level
	for edge in edges:
		edge.queue_redraw()
func begin_next_iteration():
	# For stats
	var unique_edges: Array[Edge] = []
	for solution in solutions:
		for edge in solution.edges:
			if !unique_edges.has(edge):
				unique_edges.append(edge)
	$StatsPanel/EdgesUsed.text = "Edges in use:\n%.2f" % unique_edges.size()
	iteration+=1
	$StatsPanel/Iteration.text = "Iteration #" + str(iteration)
	solutions.clear()
	if GlobalVars.ACS:
		$StatsPanel/Best.text = "Best solution:\n%.2f" % best_ACS_solution.length
	else:
		$StatsPanel/Best.text = "Best solution:\n%.2f" % best_solution.length
		
	if best_solution.length < best_global_solution.length:
		best_global_solution = best_solution
		$StatsPanel/GlobalBest.text = "Globally best:\n%.2f" % best_global_solution.length
	elif best_ACS_solution.length < best_global_solution.length:
		best_global_solution = best_ACS_solution
		$StatsPanel/GlobalBest.text = "Globally best:\n%.2f" % best_global_solution.length
	best_solution = Solution.new([], INF)
	best_ACS_solution = Solution.new([], INF)
	
	for ant in ants:
		ant.start()
		
func set_initial_pheromones_ACS():
	# Based on https://www.researchgate.net/publication/220616869_An_Analysis_of_Several_Heuristics_for_the_Traveling_Salesman_Problem
	# The idea is to base the initial pheromone values on a very rough estimation of a good route
	var unused_nodes: Array = []
	unused_nodes.append_array(cities)
	#print(unused_nodes.size())
	#print(cities.size())
	var estimation_length = 0.0
	estimation_length += unused_nodes.front().get_city_pos().distance_to(unused_nodes.back().get_city_pos())
	var nearest = unused_nodes[0]
	for node in cities:
		unused_nodes.erase(node)
		for neighbor in unused_nodes:
			if node.get_city_pos().distance_to(neighbor.get_city_pos()) < node.get_city_pos().distance_to(nearest.get_city_pos()):
				nearest = neighbor
		estimation_length += node.get_city_pos().distance_to(nearest.get_city_pos())
		
	GlobalVars.INITIAL_PHEROMONES_ACS = pow((cities.size() * estimation_length), -1)
	for edge:Edge in edges:
		edge.pheromone_level = GlobalVars.INITIAL_PHEROMONES_ACS
		edge.queue_redraw()
	
	#GlobalVars.MIN_PHEROMONE = GlobalVars.INITIAL_PHEROMONES_ACS
	#GlobalVars.MAX_PHEROMONE = GlobalVars.INITIAL_PHEROMONES_ACS * (1.0 - GlobalVars.PHEROMONE_DECAY) + GlobalVars.PHEROMONE_DECAY * pow(estimation_length, -1)
	
	pass
func _on_start_button_pressed():
	$StatsPanel/Best.text = "Best solution:\n-"
	$StatsPanel/GlobalBest.text = "Globally best:\n-"
	$StatsPanel/EdgesUsed.text = "Edges in use:\n-"
	if GlobalVars.CITY_COUNT != cities.size():
		_on_new_pos_button_pressed()
		
	if GlobalVars.ACS:
		set_initial_pheromones_ACS()
		spawn_ants_ACS()
	else:
		spawn_ants()
	if GlobalVars.CITY_COUNT > 30:
		for ant: Node2D in ants:
			ant.scale.x = (0.2 * (pow((1 - 0.01), GlobalVars.CITY_COUNT - 30)))
			ant.scale.y = (0.2 * (pow((1 - 0.01), GlobalVars.CITY_COUNT - 30)))
	iteration += 1
	$StatsPanel/Iteration.text = "Iteration #" + str(iteration)
	for ant in ants:
		ant.start()
	
func _on_stop_button_pressed():
	for ant in ants:
		ant_group.remove_child(ant)
	ants.clear()
	best_global_solution = Solution.new([], INF)
	best_global_ACS_solution = Solution.new([], INF)
	iteration = 0

func _on_reset_button_pressed():
	if GlobalVars.ACS:
		for edge:Edge in edges:
			edge.pheromone_level = GlobalVars.INITIAL_PHEROMONES_ACS
			#GlobalVars.MIN_PHEROMONE = GlobalVars.INITIAL_PHEROMONES_ACS
			#GlobalVars.MAX_PHEROMONE = GlobalVars.INITIAL_PHEROMONES_ACS
			edge.queue_redraw()
	else:
		for edge in edges:
			edge.pheromone_level = 0.0000001
			edge.queue_redraw()


func _on_acs_check_toggled(toggled_on):
	GlobalVars.ACS = toggled_on
	start_label.visible = !toggled_on
	
