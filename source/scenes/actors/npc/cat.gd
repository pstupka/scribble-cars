extends Area2D


onready var meow_stream_player: AudioStreamPlayer2D = $Meow
onready var animation_player: AnimationPlayer = $AnimationPlayer
onready var sprite: Sprite = $AnimationPivot/Sprite
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
	var cat_no = randi() % 3 + 1
	
	if cat_no == 2:
		sprite.position.y -= 10
	
	sprite.texture = load("res://assets/sprites/npc/cat%d.png" % cat_no)
	meow_stream_player.pitch_scale = rand_range(1.0, 1.0 + PITCH_RAND)
	speed += rand_range(0, 20)
	
	direction.x = rand_range(-0.5, 0.5)
	direction = direction.normalized()
	fixed_y_position = global_position.y


func _process(delta: float) -> void:
	if target:
		global_position += speed * delta * global_position.direction_to(target.global_position)
		return
	
	match current_state:
		State.MOVE: 
			global_position += speed * delta * direction / 2.0
			global_position.y = lerp(global_position.y, fixed_y_position, delta)


func enter_bus() -> void:
	set_process(false)

	var tween = create_tween()
	collision_shape_2d.set_deferred("disabled", true)
	bus_collision.set_deferred("disabled", true)
	tween.tween_property(sprite, "rotation_degrees", 360.0*2, 0.6)
	tween.parallel().tween_property(sprite, "scale", Vector2.ZERO, 0.6)
	tween.tween_callback(self, "hide")
	tween.tween_callback(self, "queue_free").set_delay(2.0)
	
	Globals.score = wrapi(Globals.score + 1, 1, 100)
	var score_particles = particles_template.instance()
	get_tree().current_scene.add_child(score_particles)
	score_particles.global_position = global_position


func next_state() -> void:
	match current_state:
		State.IDLE: 
			current_state = State.MOVE
			animation_player.play("move")
		State.MOVE: 
			current_state = State.IDLE
			animation_player.play("idle")


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
		target = area
		animation_player.play("move")
	if area.is_in_group("passengerEnter"):
		enter_bus()


func _on_BusDiscover_area_exited(_area: Area2D) -> void:
	target = null
	animation_player.play("move")


func _on_Timer_timeout() -> void:
	if not target: next_state()
	direction.x = rand_range(-0.5, 0.5)
	direction = direction.normalized()
	$Timer.wait_time = rand_range(5.0, 10.0)
