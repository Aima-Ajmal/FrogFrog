extends Control

signal dialogue_finished

@export_file("*.json") var d_file: String

var dialogue = []
var current_dialogue_id = -1
var d_active = false

@onready var nine_patch_rect = $NinePatchRect
@onready var name_label = $NinePatchRect/Name
@onready var text_label = $NinePatchRect/Text

func _ready():
	nine_patch_rect.visible = false
	
	set_process_input(true)

func _input(event):
	if event is InputEventKey and event.pressed and event.keycode == KEY_T:
		start()
		return

	if not d_active:
		return
	
	if event.is_action_pressed("ui_accept"):
		get_viewport().set_input_as_handled()
		next_script()

func start():
	if d_active:
		return
	d_active = true
	nine_patch_rect.visible = true
	dialogue = load_dialogue()
	current_dialogue_id = -1
	next_script()

func load_dialogue() -> Array:
	if d_file == "":
		push_error("Dialogue file path is empty!")
		return []
		
	var file = FileAccess.open(d_file, FileAccess.READ)
	if file:
		var json_string = file.get_as_text()
		var parsed_data = JSON.parse_string(json_string)
		if parsed_data is Array:
			return parsed_data
		else:
			push_error("JSON file must be formatted as an Array [ ... ]")
	else:
		push_error("Could not read file at: " + d_file)
	return []

func next_script():
	current_dialogue_id += 1
	
	if current_dialogue_id >= dialogue.size():
		d_active = false
		nine_patch_rect.visible = false
		emit_signal("dialogue_finished")
		return
	
	name_label.text = dialogue[current_dialogue_id]["name"]
	text_label.text = dialogue[current_dialogue_id]["text"]
