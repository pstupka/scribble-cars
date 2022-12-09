extends Area2D

export var spawn_apple_timer = 10.0

onready var animation_player = $AnimationPlayer
onready var apple_scene = preload("res://source/scenes/props/Apple.tscn")
onready var spawn_apple = $Pivot/SpawnApplePosition

func _ready() -> void:
	randomize()


func make_apple() -> void:
	animation_player.play("make_apple")

func spawn_apple() -> void:
	var apple = apple_scene.instance()
	apple.target_position = spawn_apple.global_position
	get_tree().current_scene.get_node("Actors").add_child(apple)
	apple.global_position = spawn_apple.global_position	
