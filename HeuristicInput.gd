extends LineEdit

var current_text: String

func _ready():
	current_text = str(GlobalVars.HEURISTIC_IMPORTANCE)
	self.text = current_text

func _on_text_changed(new_text: String):
	if new_text != "" and !new_text.ends_with("."):
		for character in new_text:
			if !"0123456789.".contains(character):
				self.text = current_text
				return
		GlobalVars.HEURISTIC_IMPORTANCE = float(new_text)
		update_count()

func _on_gui_input(event):
	if event is InputEventMouseButton:
		if current_text == "0":
			current_text = ""
			self.text = current_text

func update_count():
	if current_text != "":
		current_text = str(GlobalVars.HEURISTIC_IMPORTANCE)
		self.text = current_text
		self.caret_column = current_text.length()
	



func _on_focus_exited():
	if text.length() < 1:
		current_text = "0"
		GlobalVars.HEURISTIC_IMPORTANCE = 0.0
		self.text = current_text
