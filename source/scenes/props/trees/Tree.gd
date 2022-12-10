extends Area2D

export var spawn_apple_timer = 10.0

onready var animation_player = $AnimationPlayer
onready var fruit_scene = preload("res://source/scenes/props/Fruit.tscn")
onready var spawn_position = $Pivot/SpawnPosition

func _ready() -> void:
	randomize()


func make_fruit() -> void:
	animation_player.play("make_fruit")

func spawn_fruit() -> void:
	var fruit = fruit_scene.instance()
	fruit.target_position = spawn_position.global_position
	get_tree().current_scene.get_node("Actors").add_child(fruit)
	fruit.global_position = spawn_position.global_position	
