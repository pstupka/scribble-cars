extends RigidBody2D


onready var sprite: Sprite = $Sprite
onready var collision: CollisionPolygon2D = $Collision
onready var boing_stream: AudioStreamPlayer = $BoingStream


onready var explosion_scn = preload("res://source/scenes/props/space/explode_sprite.tscn")
var explosion = null

export(Resource) var asteroid_data

var player_rocket = null

func _ready() -> void:
	if asteroid_data: return
	randomize()
	asteroid_data = load("res://source/scenes/props/space/asteroid_%d.tres" % [randi() % 4 + 1])
	sprite.texture = load(asteroid_data.sprite_path)
	collision.polygon = asteroid_data.collision_polygon
	
	applied_force = rand_range(100, 5000) * Vector2.RIGHT.rotated(deg2rad(rand_range(0.0, 360)))


func _integrate_forces(state: Physics2DDirectBodyState) -> void:
	if not player_rocket: return
	
	var xform = state.get_transform()
	xform.origin = Vector2(wrapf(xform.origin.x, player_rocket.global_position.x - 5000, player_rocket.global_position.x + 5000),\
			wrapf(xform.origin.y, player_rocket.global_position.y - 5000, player_rocket.global_position.y + 5000))
	state.set_transform(xform)


func _on_Asteroid_body_entered(_body: Node) -> void:
	if is_instance_valid(explosion): return
	collision.set_deferred("disabled", true)
	explosion = explosion_scn.instance()
	add_child(explosion)
	explosion.initialize(sprite.texture)
	sprite.hide()
	
	var tween = create_tween()
	tween.parallel().tween_callback(explosion, "queue_free").set_delay(2.001)
	boing_stream.play()
	Globals.vibrate()

func _on_screen_exited() -> void:
	collision.set_deferred("disabled", false)
	sprite.show()
