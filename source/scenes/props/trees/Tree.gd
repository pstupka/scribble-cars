extends Area2D

onready var pop_sfx = $PopSfx


export var spawn_apple_timer = 10.0

onready var animation_player = $AnimationPlayer
onready var fruit_scene = preload("res://source/scenes/props/Fruit.tscn")
onready var spawn_position = $Pivot/SpawnPosition
onready var shadow: Node2D = $Shadow

export var pitch_randomness = 0.05

func _ready() -> void:
	randomize()
	Events.connect("time_of_day_changed", self, "_on_time_of_day_changed")
	_on_time_of_day_changed(Globals.daynight)


func make_fruit() -> void:
	animation_player.play("make_fruit")

func spawn_fruit() -> void:
	var fruit = fruit_scene.instance()
	fruit.target_position = spawn_position.global_position
	get_tree().current_scene.get_node("Actors").add_child(fruit)
	fruit.global_position = spawn_position.global_position	
	pop_sfx.pitch_scale = rand_range(1.0 - pitch_randomness, 1.0 + pitch_randomness)
	pop_sfx.play()

func _on_time_of_day_changed(_state):
	pass


