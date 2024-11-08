class_name Ant_ACS extends Sprite2D

@export var animation_player: AnimationPlayer = null
var city_nodes: Array[CityNode]
var passed_nodes: Array[CityNode] = []
var unvisited_nodes: Array[CityNode] = []
var used_edges: Array[Edge] = []
var start_index: int
var current_node_index: int
var current_destination: Vector2

var started: bool = false

signal report_solution(edges)

func init(cities: Array[CityNode], start_i: int = 0):
	city_nodes = cities
	#var rng = RandomNumberGenerator.new()
	#start_index = rng.randi_range(0, city_nodes.size()-1)
	start_index = start_i
	current_node_index = start_index
	position = city_nodes[start_index].get_city_pos()

func start():
	unvisited_nodes.append_array(city_nodes)
	unvisited_nodes.erase(city_nodes[start_index])
	passed_nodes.append(city_nodes[start_index])
	move_to(pick_destination())
	started = true

func _physics_process(delta):
	if started:
		position = position.move_toward(current_destination, GlobalVars.SIM_SPEED)
		if position== current_destination:
			if position == city_nodes[start_index].city_position and unvisited_nodes.is_empty():
				started = false
				passed_nodes.clear()
				#print(used_edges.size())
				var sol: Array[Edge] = []
				sol.append_array(used_edges)
				used_edges.clear()
				report_solution.emit(sol)
				animation_player.current_animation = "[stop]"
			else:
				passed_nodes.append(city_nodes[current_node_index])
				move_to(pick_destination())

func move_to(destination: CityNode):
	var edge = city_nodes[current_node_index].get_connection(destination)
	used_edges.append(edge)
	edge.set_pheromone_level((1 - GlobalVars.PHEROMONE_DECAY) * edge.pheromone_level + GlobalVars.PHEROMONE_DECAY * GlobalVars.INITIAL_PHEROMONES_ACS)
	edge.queue_redraw()
	current_node_index = city_nodes.find(destination)
	unvisited_nodes.erase(destination)
	current_destination = destination.city_position
	look_at(current_destination)
	rotate(1.5708)
	animation_player.current_animation = "walk"

func pick_destination() -> CityNode:
	if unvisited_nodes.is_empty():
		return city_nodes[start_index]
	
	var rng = RandomNumberGenerator.new()
	var q = rng.randf_range(0.0, 1.0)
	if q <= GlobalVars.EXPLOITATION_RATE:
		#var edges = city_nodes[current_node_index].connections
		var best_edge = unvisited_nodes[0].get_connection(city_nodes[current_node_index])
		for node in unvisited_nodes:
			var edge = city_nodes[current_node_index].get_connection(node)
			if edge.get_weight_ACS() > best_edge.get_weight_ACS():
				best_edge = edge
		if best_edge.start != city_nodes[current_node_index]:
			return best_edge.start
		else:
			return best_edge.end
	else:
		var generated = rng.randf_range(0.0, calculate_weights())
		var passed: float = 0.0
		
		for node in unvisited_nodes:
			var connection = city_nodes[current_node_index].get_connection(node)
			#passed += connection.get_weight()
			if passed + connection.get_weight_ACS() >= generated:
				return node
			else:
				passed += connection.get_weight_ACS()
			
	return city_nodes[start_index]

func calculate_weights() -> float:
	var total_weight: float = 0.0
	for node in unvisited_nodes:
		total_weight += city_nodes[current_node_index].get_connection(node).get_weight_ACS()
	#for connection in city_nodes[current_node_index].connections:
		#if !passed_nodes.has(connection.end):
		#	total_weight += GlobalVars.BASE_WEIGHT + connection.pheromone_level
	return total_weight
