class_name CityNode extends Node2D

var city_position: Vector2
var size = GlobalVars.CITY_SIZE;

var connections: Array[Edge] = []

# Called when the node enters the scene tree for the first time.
func _ready():
	self.z_index = 2
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _draw():
	#raw_rect(Rect2(city_position.x - (size/2), city_position.y - (size/2), city_position.x + (size/2), city_position.y + (size/2)), Color.GREEN)
	draw_circle(city_position, size, Color.from_string("#3F7CAC", Color.BLACK))
	
func get_city_pos() -> Vector2:
	return city_position;
	
func set_city_pos(pos: Vector2):
	city_position = pos;

func add_connection(edge: Edge):
	connections.append(edge)

func get_connection(to_node) -> Edge:
	for connection in connections:
		if connection.end == to_node or connection.start == to_node:
			return connection 
	return null
