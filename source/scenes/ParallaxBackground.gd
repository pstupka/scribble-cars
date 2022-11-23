extends ParallaxBackground

const GAME_SIZE := Vector2(600, 1024)

onready var clouds: = [
	preload("res://source/scenes/props/Cloud1.tscn"),
	preload("res://source/scenes/props/Cloud2.tscn"),
]

export var layers_number = 5
export var max_clouds_per_layer = 30
export var speed = 30.0

var velocity_x = 10.0

func _ready() -> void:
	randomize()
		
	for parallax_id in layers_number:
		var parallax_layer = ParallaxLayer.new()
		parallax_layer.motion_mirroring = GAME_SIZE
		add_child(parallax_layer)
	

		parallax_layer.motion_scale = Vector2.ONE / (layers_number - parallax_id)
		for i in max_clouds_per_layer / (parallax_id + 2):
			var cloud = clouds[randi() % 2].instance()
			parallax_layer.add_child(cloud)
			cloud.scale = Vector2.ONE / (layers_number - parallax_id + 1)
			cloud.global_position = Vector2(randf() * GAME_SIZE.x, randf() * GAME_SIZE.y/5)


func _process(delta: float) -> void:
	velocity_x = lerp(velocity_x, speed, delta)
	
	for layer in get_children():
		if layer.get_index() > 0:
			layer.motion_offset.x += layer.motion_scale.x * velocity_x * delta
