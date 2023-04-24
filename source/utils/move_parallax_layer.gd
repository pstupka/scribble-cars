extends ParallaxLayer

export var speed :float = 20

func _process(delta):
	motion_offset.x += speed * delta
