extends CharacterBody2D

@export var dialogue_box: Control

var is_chatting = false
var player_in_chat_zone = false
var player = null

@onready var animated_sprite = $AnimatedSprite2D

func _ready():
	animated_sprite.play("idle")

	$chat_detection.body_entered.connect(_on_chat_detection_body_entered)
	$chat_detection.body_exited.connect(_on_chat_detection_body_exited)
	
	if dialogue_box:
		dialogue_box.dialogue_finished.connect(_on_dialogue_finished)
	else:
		push_warning("Dialogue Box is not assigned to CoffeeShopOwner in the Inspector!")

func _unhandled_input(event):
	if player_in_chat_zone and event.is_action_pressed("ui_accept"):
		if not is_chatting:
			get_viewport().set_input_as_handled()
			start_chatting()

func start_chatting():
	is_chatting = true
	animated_sprite.play("idle")
	if dialogue_box:
		dialogue_box.start()

# --- Area2D SIGNALS ---
func _on_chat_detection_body_entered(body):
	print("Something entered the zone: ", body.name) # Temporary print to test collision
	if body.has_method("player"): 
		player = body
		player_in_chat_zone = true
		print("Valid Player detected! Press ENTER to talk.")

func _on_chat_detection_body_exited(body):
	if body.has_method("player"):
		player_in_chat_zone = false
		player = null
		print("Player left the zone.")

func _on_dialogue_finished():
	await get_tree().create_timer(0.1).timeout
	is_chatting = false
