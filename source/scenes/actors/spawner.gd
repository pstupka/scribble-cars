extends Area2D

onready var spawn_timer: Timer = $SpawnTimer

export var scene_to_spawn: PackedScene = null

func _ready() -> void:
	randomize()
	spawn_timer.wait_time += rand_range(-2, 2)


func _on_VisibilityNotifier2D_screen_exited() -> void:
	spawn_timer.start()


func _on_VisibilityNotifier2D_screen_entered() -> void:
	spawn_timer.stop()


func _on_SpawnTimer_timeout() -> void:
	if scene_to_spawn and get_parent().get_child_count() < 30:
		var scene = scene_to_spawn.instance()
		get_parent().add_child(scene)
		scene.global_position.x = global_position.x
		scene.global_position.y = global_position.y + rand_range(-10.0, 10.0)
		scene.fixed_y_position = scene.global_position.y
