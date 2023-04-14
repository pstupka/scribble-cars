extends Control

onready var menu_button_content := [
	preload("res://source/scenes/actors/car_templates/car_template.tscn"),
	preload("res://source/scenes/actors/car_templates/bus3.tscn"),
	null,
	preload("res://source/scenes/props/space/menu_rocket_button.tscn")
]

onready var machine = $Car



func _ready() -> void:
	OS.set_window_maximized(true) # TODO: Make it on splash screen
	
	randomize()
	
	machine.set_animation_loop("move", true)
	machine.animation_player.play("move")

func _input(event: InputEvent) -> void:
	pass


