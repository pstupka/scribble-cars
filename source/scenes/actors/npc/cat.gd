extends Area2D


onready var meow_stream_player: AudioStreamPlayer2D = $Meow
onready var animation_player: AnimationPlayer = $AnimationPlayer
onready var sprite = $AnimationPivot/SFXAnimPivot/Sprite
onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
onready var bus_collision: CollisionShape2D = $BusDiscover/CollisionShape2D


const PITCH_RAND = 0.4
enum State {IDLE, MOVE, GO_TO_TARGET}
var current_state = State.IDLE
var previous_state = null

var target = null
var speed := 30.0
var direction := Vector2.LEFT
var fixed_y_position : float

var particles_template = preload("res://source/utils/score_particles.tscn")


func _ready() -> void:
	randomize()
	var cat_no = randi() % 5 + 1
	
	sprite.texture = load("res://assets/sprites/npc/cat%d.png" % cat_no)
	sprite.offset.y = -sprite.texture.get_size().y / 2

	meow_stream_player.pitch_scale = rand_range(1.0, 1.0 + PITCH_RAND)


func collect() -> void:
	var tween = create_tween()
	collision_shape_2d.set_deferred("disabled", true)
	bus_collision.set_deferred("disabled", true)
	tween.tween_property(sprite, "rotation_degrees", 360.0*2, 0.6)
	tween.parallel().tween_property(sprite, "scale", Vector2.ZERO, 0.6)
	tween.tween_callback(sprite, "hide")
#	tween.tween_callback(self, "queue_free").set_delay(2.0)
	
	Globals.score = wrapi(Globals.score + 1, 1, 100)
	var score_particles = particles_template.instance()
	get_tree().current_scene.add_child(score_particles)
	score_particles.global_position = sprite.global_position


func meow() -> void:
	meow_stream_player.play()
	
	var tween = create_tween()
	tween.tween_property(sprite, "scale:x", 0.4, 0.9)
	tween.parallel().tween_property(sprite, "scale:y", 0.65, 0.9)
	tween.tween_property(sprite, "scale:x", 0.5, 1.3).set_delay(0.2)
	tween.parallel().tween_property(sprite, "scale:y", 0.5, 1.3).set_delay(0.2)


func _on_Cat_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		meow()


func _on_BusDiscover_area_entered(area: Area2D) -> void:
	if area.is_in_group("passengerDiscover"):
		collect()


func _on_VisibilityNotifier2D_screen_exited():
	if collision_shape_2d.disabled:
		collision_shape_2d.set_deferred("disabled", false)
		bus_collision.set_deferred("disabled", false)
		sprite.rotation_degrees = 0
		sprite.scale = Vector2(0.5, 0.5)
		sprite.show()
