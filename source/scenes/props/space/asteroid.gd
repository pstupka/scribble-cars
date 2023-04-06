extends RigidBody2D

onready var explode_sprite: Particles2D = $ExplodeSprite
onready var sprite: Sprite = $Sprite
onready var collision: CollisionPolygon2D = $Collision

export(Resource) var asteroid_data

func _ready() -> void:
	if asteroid_data: return
	randomize()
	asteroid_data = load("res://source/scenes/props/space/asteroid_%d.tres" % [randi() % 2 + 1])
	sprite.texture = load(asteroid_data.sprite_path)
	collision.polygon = asteroid_data.collision_polygon

func _on_Asteroid_body_entered(_body: Node) -> void:
	collision.set_deferred("disabled", true)
	explode_sprite.initialize(sprite.texture)
	sprite.hide()
	
	var tween = create_tween()

	tween.parallel().tween_callback(self, "queue_free").set_delay(2.001)
	
