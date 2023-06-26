extends Area2D

onready var hey: AudioStreamPlayer2D = $Hey

onready var sfx: AudioStreamPlayer2D 
onready var animation_player: AnimationPlayer = $AnimationPlayer
onready var sprite: Sprite = $AnimationPivot/SFXAnimPivot/Sprite
onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
onready var bus_collision: CollisionShape2D = $BusDiscover/CollisionShape2D
onready var sfx_anim_pivot: Node2D = $AnimationPivot/SFXAnimPivot
onready var umbrella: Sprite = $AnimationPivot/SFXAnimPivot/Umbrella

const PITCH_RAND = 0.2
enum State {IDLE, MOVE, GO_TO_TARGET}
var current_state = State.IDLE
var previous_state = null

var target = null
var speed := 30.0
var direction := Vector2.LEFT
var fixed_y_position : float

var particles_template = preload("res://source/utils/score_particles.tscn")

var type

var npc_types := {
	"res://assets/sprites/npc/human1.png": Vector2(-30, -62),
	"res://assets/sprites/npc/human2.png": Vector2(-30, -105),
	"res://assets/sprites/npc/human3.png": Vector2(-30, -105),
	"res://assets/sprites/npc/human4.png": Vector2(-32, -95),
	"res://assets/sprites/npc/human5.png": Vector2(-32, -110),
	"res://assets/sprites/npc/human6.png": Vector2(-27, -87),
	"res://assets/sprites/npc/human7.png": Vector2(-30, -68),
	"res://assets/sprites/npc/human8.png": Vector2(-12, -150),
	"res://assets/sprites/npc/human9.png": Vector2(-12, -94),
	"res://assets/sprites/npc/human10.png": Vector2(-12, -70),
	"res://assets/sprites/npc/human11.png": Vector2(-30, -105),
	"res://assets/sprites/npc/human12.png": Vector2(-30, -105),
	"res://assets/sprites/npc/human13.png": Vector2(-30, -105),
	"res://assets/sprites/npc/human14.png": Vector2(-30, -105),
	"res://assets/sprites/npc/human15.png": Vector2(-30, -105),
	"res://assets/sprites/npc/human16.png": Vector2(-30, -105),
	"res://assets/sprites/npc/human17.png": Vector2(-30, -105),
}

export var can_discover: = true

func _ready() -> void:
	randomize()

	type = npc_types.keys()
	type = type[randi() % type.size()]
	
	sprite.texture = load(type)
	sprite.position.y = -sprite.texture.get_size().y / 4

	sfx = hey

	umbrella.position = npc_types[type]

	sfx.pitch_scale = rand_range(1.0 - PITCH_RAND/2, 1.0 + PITCH_RAND)
	animation_player.playback_speed = sfx.pitch_scale
	speed += rand_range(0, 20)
	
	direction.x = rand_range(-0.5, 0.5)
	direction = direction.normalized()
	fixed_y_position = global_position.y
	
	$Timer.wait_time = rand_range(1.0, 10.0)
	$Timer.start()
	
	bus_collision.disabled = !can_discover
	
	Events.connect("rain_state_changed", self, "_on_rain_state_changed")
	
	umbrella.modulate = Globals.available_colors[randi() % Globals.available_colors.size()]


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


func play_sfx() -> void:
	if randf() < 0.3: return
	sfx.play()
	
	var tween = create_tween()
	tween.tween_property(sfx_anim_pivot, "scale:x", 0.9, 0.9)
	tween.parallel().tween_property(sfx_anim_pivot, "scale:y", 1.2, 0.9)
	tween.tween_property(sfx_anim_pivot, "scale:x", 1.0, 1.3).set_delay(0.2)
	tween.parallel().tween_property(sfx_anim_pivot, "scale:y", 1.0, 1.3).set_delay(0.2)


func _on_Cat_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		play_sfx()


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


func _on_rain_state_changed(state: bool) -> void:
	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	if state: 
		umbrella.show()
		tween.tween_property(umbrella, "scale:x", 0.8, 1.3).from(0.0)
		tween.parallel().tween_property(umbrella, "scale:y", 0.8, 0.4).from(0.0)
	else:
		
		tween.tween_property(umbrella, "scale:x", 0.1, 0.3).from(0.8)
		tween.parallel().tween_property(umbrella, "scale:y", 0.0, 0.7).from(0.8).set_delay(0.1)
		tween.tween_callback(umbrella, "hide")
