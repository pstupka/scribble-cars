extends Node2D
onready var stars_bg: ParallaxLayer = $ParallaxBackground/Stars
onready var player = $Actors/Rocket
onready var collectables: Array

onready var star_scene := preload("res://source/scenes/props/space/collectable_star.tscn")

export var scene_type = "space"

func _ready() -> void:
	for star in stars_bg.get_children():
		star.modulate = Color(randf(), 0.0, 0.0)
		star.scale = star.scale * (randf() * 0.6 + 0.4)

	for i in 50:
		var new_star = star_scene.instance()
		collectables.append(new_star)
		$Collectables.add_child(new_star)
		new_star.global_position = Vector2(randf() * 4000 - 2000, randf() * 4000 - 2000)
	
	for asteroid in $Actors/Asteroids.get_children():
		asteroid.player_rocket = player
	
	Globals.score = 0


func _process(_delta: float) -> void:
	for collectable in collectables:
		collectable.global_position = \
			Vector2(wrapf(collectable.global_position.x, player.global_position.x - 2000, player.global_position.x + 2000),\
			wrapf(collectable.global_position.y, player.global_position.y - 2000, player.global_position.y + 2000))

