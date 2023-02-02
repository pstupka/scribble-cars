extends Node2D

onready var animation_player = $AnimationPlayer

onready var sfx = $Sfx
onready var jump_sfx = $JumpSfx
onready var car_fill = $AnimationPivot/Sprites/CarFill
onready var front_light_rays: Sprite = $AnimationPivot/FrontLight/FrontLightRays


export var speed := 150.0
export var can_change_color:bool = true
export var color : Color setget set_color

const PITCH_RAND = 0.05

func _ready() -> void:
	Events.connect("time_of_day_changed", self, "_on_time_of_day_changed")
	_on_time_of_day_changed(Globals.daynight)
	set_color(color)

func jump() -> void:
	animation_player.play("jump")
	jump_sfx.pitch_scale = rand_range(1.0 - PITCH_RAND, 1.0 + PITCH_RAND)
	jump_sfx.play()


func honk() -> void:
	for sound in sfx.get_children():
		if sound.is_playing(): return
	var honks_count = sfx.get_child_count()
	var honk = sfx.get_child(rand_range(0,honks_count))
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


func set_color(new_color) -> void:
	if not can_change_color: return
	color = new_color
	if car_fill:
		car_fill.self_modulate = new_color


func _on_time_of_day_changed(state):
	match state:
		Globals.DAY:
			front_light_rays.visible = false
		Globals.NIGHT:
			front_light_rays.visible = true
