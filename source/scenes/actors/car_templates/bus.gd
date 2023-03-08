extends Node2D

onready var animation_player := $AnimationPlayer

onready var sfx = $Sfx
onready var jump_sfx = $JumpSfx
onready var car_fill = $AnimationPivot/Sprites/CarFill
onready var front_light_rays: Sprite = $AnimationPivot/FrontLight/FrontLightRays
onready var bus_doors: Sprite = $AnimationPivot/Sprites/BusDoors
onready var passenger_collision: CollisionShape2D = $PassengerDiscovery/PassengerCollision
onready var passenger_enter_collision: CollisionShape2D = $PassengerEnter/PassengerEnterCollision
onready var open_door_sfx: AudioStreamPlayer = $OpenDoorSfx

export var speed := 150.0
export var can_change_color:bool = true
export var color : Color setget set_color

const PITCH_RAND = 0.05
enum State {IDLE, MOVE, JUMP}
var current_state = State.IDLE
var doors_open = false
var doors_init_color



func _ready() -> void:
	randomize()
	Events.connect("time_of_day_changed", self, "_on_time_of_day_changed")
	_on_time_of_day_changed(Globals.daynight)
	set_color(color)
	set_animation_loop("move", false)
	
	speed += randf() * 40.0 - 20.0
	doors_init_color = bus_doors.self_modulate

func jump() -> void:
	animation_player.play("jump")
	jump_sfx.pitch_scale = rand_range(1.0 - PITCH_RAND, 1.0 + PITCH_RAND)
	jump_sfx.play()
	if doors_open:
		doors()


func honk(random:bool = true) -> void:
	var parent = get_parent()
	if parent is Player \
		and parent.velocity.length() == 0\
		and animation_player.current_animation != "jump": 
			doors()
			return
	for sound in sfx.get_children():
		if sound.is_playing(): return
	var honks_count = sfx.get_child_count()
	var honk 
	if random: honk = sfx.get_child(rand_range(0,honks_count))
	else:
		honk = sfx.get_child(0)
	honk.pitch_scale = rand_range(1.0 - PITCH_RAND, 1.0 + PITCH_RAND)
	honk.play()
	var tween = create_tween()
	if (Input.get_connected_joypads().size() > 0):
		Input.start_joy_vibration(0, 0.4, 0.0, 0.4)
	if OS.get_name() == "Android" or OS.get_name() == "HTML5":
		Input.vibrate_handheld(200)
	tween.tween_property($AnimationPivot, "scale:y", 1.2, 0.15) 
	tween.tween_property($AnimationPivot, "scale:y", 1.0, 0.15)
	tween.tween_property($AnimationPivot, "scale:y", 1.2, 0.15)
	tween.tween_property($AnimationPivot, "scale:y", 1.0, 0.15)


func doors() -> void:
	var doors_tween = create_tween()
	var doors_color = doors_init_color
	
	doors_open = !doors_open
	passenger_collision.set_deferred("disabled", !doors_open)
	passenger_enter_collision.set_deferred("disabled", !doors_open)
	if doors_open:
		doors_color = Color("4b80ca")

	doors_tween.tween_property(bus_doors, "self_modulate", doors_color, 0.3)
	open_door_sfx.play()


func set_color(new_color) -> void:
	if not can_change_color: return
	color = new_color
	if car_fill:
		car_fill.self_modulate = new_color


func set_animation_loop(anim_name: String, loop: bool) -> void:
	animation_player.get_animation(anim_name).set_loop(loop)


func _on_time_of_day_changed(state):
	match state:
		Globals.DAY:
			front_light_rays.visible = false
		Globals.NIGHT:
			front_light_rays.visible = true


func _on_AnimationPlayer_animation_started(anim_name: String) -> void:
	if anim_name == "move" and doors_open:
		doors()
