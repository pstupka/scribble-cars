extends Node2D
onready var stars_bg: ParallaxLayer = $ParallaxBackground/Stars
onready var player = $YSort/Rocket
onready var collectables: Node2D = $Collectables


func _ready() -> void:
	for star in stars_bg.get_children():
		star.modulate = Color(randf(), 0.0, 0.0)
		star.scale = star.scale * (randf() * 0.6 + 0.4)


func _process(delta: float) -> void:
	for collectable in collectables.get_children():
		collectable.global_position = \
			Vector2(wrapf(collectable.global_position.x, player.global_position.x - 2000, player.global_position.x + 2000),\
			wrapf(collectable.global_position.y, player.global_position.y - 2000, player.global_position.y + 2000))
	
