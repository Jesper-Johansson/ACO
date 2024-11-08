extends LineEdit

var current_text: String

func _ready():
	current_text = str(GlobalVars.PHEROMONE_DECAY)
	self.text = current_text
	if current_text.length() == 0:
		current_text = "0"
		self.text = current_text

func _on_text_changed(new_text: String):
	if new_text.length() == 0:
		new_text = "0"
	for character in new_text:
		if !"0123456789".contains(character):
			return
	while true:
		if new_text.length() > 1 && new_text.begins_with("0"):
			new_text = new_text.erase(0, 1)
		else:
			break
	if int(new_text) < 0:
		new_text = str(0)
	GlobalVars.PHEROMONE_DECAY= float(new_text)
	update_count()

func _on_gui_input(event):
	if event is InputEventMouseButton:
		if current_text == "0":
			current_text = ""
			self.text = current_text

func update_count():
	current_text = str(GlobalVars.PHEROMONE_DECAY)
	self.text = current_text
	self.caret_column = current_text.length()
	



func _on_focus_exited():
	if current_text == "":
		current_text = "0"
		self.text = current_text
