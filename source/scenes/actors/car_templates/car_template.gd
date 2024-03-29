extends Node2D
class_name MachineTemplate

onready var animation_player = $AnimationPlayer

onready var sfx = $Sfx
onready var jump_sfx = $JumpSfx
onready var car_fill = $AnimationPivot/Sprites/CarFill
onready var front_light_rays: Sprite = $AnimationPivot/FrontLight/FrontLightRays
onready var shadow_pivot = $ShadowPivot


export var speed := 150.0
export var can_change_color:bool = true
export var color : Color setget set_color

const PITCH_RAND = 0.05

var is_jumping := false

func _ready() -> void:
	randomize()
	var _err = Events.connect("time_of_day_changed", self, "_on_time_of_day_changed")
	_on_time_of_day_changed(Globals.daynight)
	set_color(color)
	set_animation_loop("move", false)
	
	speed += randf() * 40.0 - 20.0
	
	is_jumping = false
	front_light_rays.self_modulate = Color("#808080")


func jump() -> void:
	if is_jumping: return 
	
	is_jumping = true
	animation_player.play("jump")
	jump_sfx.pitch_scale = rand_range(1.0 - PITCH_RAND, 1.0 + PITCH_RAND)
	jump_sfx.play()


func honk(random:bool = true) -> void:
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
	Globals.vibrate()
	
	tween.tween_property($AnimationPivot, "scale:y", 1.2, 0.15)
	tween.parallel().tween_property(shadow_pivot, "scale:y", 1.2, 0.15) 
	tween.tween_property($AnimationPivot, "scale:y", 1.0, 0.15)
	tween.parallel().tween_property(shadow_pivot, "scale:y", 1.0, 0.15)
	tween.tween_property($AnimationPivot, "scale:y", 1.2, 0.15)
	tween.parallel().tween_property(shadow_pivot, "scale:y", 1.2, 0.15)
	tween.tween_property($AnimationPivot, "scale:y", 1.0, 0.15)
	tween.parallel().tween_property(shadow_pivot, "scale:y", 1.0, 0.15)


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


func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == "jump":
		is_jumping = false
	match anim_name:
		"jump": is_jumping = false
		"move": animation_player.play("move")
