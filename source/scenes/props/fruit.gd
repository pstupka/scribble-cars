extends Area2D

onready var mniam_sfx = $MniamSfx
export var pitch_randomness = 0.05

var type = "Apple" setget set_type

export var initial_speed = 100.0
var target_position := Vector2.ZERO
var speed := Vector2.ZERO
export var body_gravity := -10.0 


onready var collision_shape_2d = $CollisionShape2D

onready var apple = $Sprites/Apple
onready var pear = $Sprites/Pear
onready var sprites = $Sprites

var particles_template = preload("res://source/utils/score_particles.tscn")

var is_destroying = false

func _ready():
	randomize()
	target_position.y = rand_range(Globals.ROAD_MIN_POSITION, Globals.ROAD_MAX_POSITION)
	
	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BOUNCE)
	tween.tween_property(self, "position:y", target_position.y, 2.0)
	tween.parallel().tween_property(sprites, "scale:y", 1.0, 2.0).from(0.7)
	
	tween.parallel()\
		.set_trans(Tween.TRANS_LINEAR)\
		.tween_property(self, "position:x", target_position.x + rand_range(50,150) * sign(rand_range(-1,1)) , 2.0)
	
	tween.tween_callback(collision_shape_2d, "set_deferred", ["disabled", false])

	if randf() > 0.5:
		set_type("Pear")

func set_type(new_type) -> void:
	match new_type:
		"Apple":
			apple.visible = true
			pear.visible = false
		"Pear":
			apple.visible = false
			pear.visible = true

func destroy(emit_particles: bool = false) -> void:
	if is_destroying: return
	var tween = create_tween()

	if emit_particles: 
		Globals.score = wrapi(Globals.score + 1, 1, 100)
		var score_particles = particles_template.instance()
		get_tree().current_scene.add_child(score_particles)
		score_particles.global_position = global_position
		tween.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)

	
	is_destroying = true
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.parallel().tween_property(sprites, "modulate", Color("00ffffff"), 0.4)
	tween.tween_callback(self, "queue_free").set_delay(1.0)


func emit_particles() -> void:
	var tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)


func _on_Apple_body_entered(body):
	if body.is_in_group("player"):
		mniam_sfx.pitch_scale = rand_range(1.0 - pitch_randomness, 1.0 + pitch_randomness)
		mniam_sfx.play()
		destroy(true)
		

func _on_DestroyTimer_timeout():
	destroy()
