extends Particles2D

func _ready():
	one_shot = true
	emitting = false

func initialize(sprite : Texture):
	var buffered_position = global_transform
	set_as_toplevel(true)
	global_transform = buffered_position
	process_material.set_shader_param("emission_box_extents", 
		Vector3(sprite.get_width() / 2.0, sprite.get_height() / 2.0, 1))
	process_material.set_shader_param("sprite", sprite)
	emitting = true

