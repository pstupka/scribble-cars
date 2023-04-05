extends RigidBody2D

onready var explode_sprite: Particles2D = $ExplodeSprite
onready var sprite: Sprite = $Sprite
onready var collision: CollisionPolygon2D = $Collision


func _on_Asteroid_body_entered(body: Node) -> void:
	collision.set_deferred("disabled", true)
	explode_sprite.initialize(sprite.texture)
	sprite.hide()
	
	var tween = create_tween()
	tween.tween_callback(self, "queue_free").set_delay(2.5)
