extends Area2D

var type = "Apple" setget set_type

export var initial_speed = 100.0
var target_position := Vector2.ZERO
var speed := Vector2.ZERO
export var body_gravity := -10.0 


onready var collision_shape_2d = $CollisionShape2D

onready var apple = $Sprites/Apple
onready var grape = $Sprites/Grape
onready var sprites = $Sprites


var is_destroying = false

func _ready():
	randomize()
	target_position.y = rand_range(Globals.ROAD_MIN_POSITION, Globals.ROAD_MAX_POSITION)
	
	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BOUNCE)
	tween.tween_property(self, "position:y", target_position.y, 2.0)
	
	tween.parallel()\
		.set_trans(Tween.TRANS_LINEAR)\
		.tween_property(self, "position:x", target_position.x + rand_range(-100,100), 2.0)
	
	tween.tween_callback(collision_shape_2d, "set_deferred", ["disabled", false])

	if randf() > 0.5:
		set_type("Grape")

func set_type(type) -> void:
	match type:
		"Apple":
			apple.visible = true
			grape.visible = false
		"Grape":
			apple.visible = false
			grape.visible = true

func destroy() -> void:
	if not is_destroying:
		is_destroying = true
		var tween = create_tween()
		tween.tween_property(sprites, "modulate", Color("00ffffff"), 0.4)
		tween.tween_callback(self, "queue_free").set_delay(1.0)


func _on_Apple_body_entered(body):
	if body.is_in_group("player"):
		$Particles2D.emitting = true
		destroy()


func _on_DestroyTimer_timeout():
	destroy()
