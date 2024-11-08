class_name Ant extends Sprite2D

@export var animation_player: AnimationPlayer = null
var city_nodes: Array[CityNode]
var passed_nodes: Array[CityNode] = []
var unvisited_nodes: Array[CityNode] = []
var used_edges: Array[Edge] = []
var start_index: int
var current_node_index: int
var current_destination: Vector2

var pos_offset: Vector2
var started: bool = false

var nodes_visited: int = 0

signal report_solution(edges)

func init(cities: Array[CityNode], start: int = 0, position_offset: Vector2 = Vector2(0, 0)):
	city_nodes = cities
	start_index = start_index
	current_node_index = start_index
	#passed_nodes.append(city_nodes[start_index])
	pos_offset = position_offset
	
	position = city_nodes[start_index].get_city_pos() + position_offset

func _physics_process(delta):
	if !GlobalVars.PAUSED && started:
		position = position.move_toward(current_destination + pos_offset, GlobalVars.SIM_SPEED)
		if position - pos_offset == current_destination:
			if position - pos_offset == city_nodes[start_index].city_position and unvisited_nodes.is_empty():
				started = false
				passed_nodes.clear()
				#print(used_edges.size())
				var sol: Array[Edge] = []
				sol.append_array(used_edges)
				used_edges.clear()
				report_solution.emit(sol)
				idle()
			else:
				passed_nodes.append(city_nodes[current_node_index])
				move_to(pick_destination())
func start():
	unvisited_nodes.append_array(city_nodes)
	unvisited_nodes.erase(city_nodes[start_index])
	passed_nodes.append(city_nodes[start_index])
	move_to(pick_destination())
	started = true
func move_to(destination: CityNode):
	used_edges.append(city_nodes[current_node_index].get_connection(destination))
	current_node_index = city_nodes.find(destination)
	unvisited_nodes.erase(destination)
	current_destination = destination.city_position
	look_at(current_destination)
	rotate(1.5708)
	walk()
	

func pick_destination() -> CityNode:
	if unvisited_nodes.is_empty():
		return city_nodes[start_index]
	
	var rng = RandomNumberGenerator.new()
	var generated = rng.randf_range(0.0, calculate_weights())
	var passed: float = 0.0
	
	for node in unvisited_nodes:
		var connection = city_nodes[current_node_index].get_connection(node)
		#passed += connection.get_weight()
		if passed + connection.get_weight() >= generated:
			return node
		else:
			passed += connection.get_weight()
		
	
	#var destination: CityNode
	#while true:
		#if passed >= generated:
		#	break
	#	for connection in city_nodes[current_node_index].connections:
		#	if !passed_nodes.has(connection.end):
	#			var connection_weight = GlobalVars.BASE_WEIGHT + connection.pheromone_level
	#			if passed + connection_weight > generated:
	#				used_edges.append(connection)
	#				current_node_index = city_nodes.find(connection.end)
	#				return connection.end
	#			passed += connection_weight
	# If a next node cannot be found, all nodes have been traveled to; return to the start
	#for connection in city_nodes[current_node_index].connections:
	#	if connection.end == city_nodes[start_index]:
	#		used_edges.append(connection)
	return city_nodes[start_index]

func calculate_weights() -> float:
	var total_weight: float = 0.0
	for node in unvisited_nodes:
		total_weight += city_nodes[current_node_index].get_connection(node).get_weight()
	#for connection in city_nodes[current_node_index].connections:
		#if !passed_nodes.has(connection.end):
		#	total_weight += GlobalVars.BASE_WEIGHT + connection.pheromone_level
	return total_weight
	

func _ready():
	pass

func walk():
	animation_player.current_animation = "walk"

func idle():
	animation_player.current_animation = "[stop]"
