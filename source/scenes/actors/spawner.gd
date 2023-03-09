extends Area2D

export var scene_to_spawn: PackedScene = null


func _ready() -> void:
	randomize()


func _on_VisibilityNotifier2D_screen_exited() -> void:
	$SpawnTimer.start()


func _on_VisibilityNotifier2D_screen_entered() -> void:
	$SpawnTimer.stop()


func _on_SpawnTimer_timeout() -> void:
	if scene_to_spawn and get_child_count() < 30:
		var scene = scene_to_spawn.instance()
		add_child(scene)
		scene.global_position.y += rand_range(-10,10)
