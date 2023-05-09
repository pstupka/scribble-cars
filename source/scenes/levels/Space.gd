extends Node2D


onready var stars = $ParallaxBackground/Stars/Stars

onready var player = $Actors/Rocket
onready var collectables: Array

onready var star_scene := preload("res://source/scenes/props/space/collectable_star.tscn")
onready var enter_tweener = $EnterTweener

export var scene_type = "space"

func _ready() -> void:
	for star in stars.get_children():
		star.modulate = Color(randf(), 0.0, 0.0)
		star.scale = star.scale * (randf() * 0.6 + 0.4)

	for i in 50:
		var new_star = star_scene.instance()
		collectables.append(new_star)
		$Collectables.add_child(new_star)
		new_star.global_position = Vector2(randf() * 4000 - 2000, randf() * 4000 - 2000)
		if new_star.global_position.length() < 100.0:
			new_star.global_position.x += sign(new_star.global_position.x) * 200.0
			new_star.global_position.y += sign(new_star.global_position.y) * 200.0


	for asteroid in $Actors/Asteroids.get_children():
		asteroid.player_rocket = player
	
	Globals.score = 0
	
	yield(get_tree().create_timer(0.1),"timeout")
	get_tree().paused = true
	var _err = enter_tweener.connect("enter_tween_completed", self, "_on_enter_tween_completed")
	enter_tweener.apply_tween()


func _process(_delta: float) -> void:
	for collectable in collectables:
		collectable.global_position = \
			Vector2(wrapf(collectable.global_position.x, player.global_position.x - 2000, player.global_position.x + 2000),\
			wrapf(collectable.global_position.y, player.global_position.y - 2000, player.global_position.y + 2000))


func _on_enter_tween_completed():
	get_tree().paused = false
