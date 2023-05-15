extends Node2D

onready var animation_player = $AnimationPlayer

onready var sfx = $Sfx
onready var jump_sfx = $JumpSfx
onready var car_fill = $AnimationPivot/Sprites/CarFill
onready var front_light_rays: Sprite = $AnimationPivot/FrontLight/FrontLightRays
onready var ladder_pivot: Node2D = $AnimationPivot/Sprites/LadderPivot
onready var shadow_ladder_pivot: Node2D = $ShadowPivot/LadderPivot
onready var cat_collision = $AnimationPivot/Sprites/LadderPivot/CatDiscovery/CatCollision



export var speed := 150.0
export var can_change_color:bool = true
export var color : Color setget set_color
export var ladder_speed := 0.5
export var max_ladder_angle_deg := 40.0
export var min_ladder_angle_deg := 0.0

const PITCH_RAND = 0.05

var is_jumping := false
var is_moving_ladder := false setget set_is_moving_ladder

var tween : SceneTreeTween = null

func _ready() -> void:
	randomize()
	var _err = Events.connect("time_of_day_changed", self, "_on_time_of_day_changed")
	_on_time_of_day_changed(Globals.daynight)
	set_color(color)
	set_animation_loop("move", false)
	
	speed += randf() * 40.0 - 20.0
	is_jumping = false
	ladder_pivot.rotation_degrees = min_ladder_angle_deg
	shadow_ladder_pivot.rotation_degrees = -min_ladder_angle_deg/2


func _input(event):
	if Input.is_action_pressed("jump") and not is_moving_ladder and ladder_pivot.rotation_degrees != max_ladder_angle_deg:
		tween_ladder(max_ladder_angle_deg)
#		ladder_pivot.rotate(delta * ladder_speed)
#		ladder_pivot.rotation_degrees = clamp(ladder_pivot.rotation_degrees, min_ladder_angle_deg, max_ladder_angle_deg)
#		shadow_ladder_pivot.rotation_degrees = -ladder_pivot.rotation_degrees/2
	if Input.is_action_pressed("lights") and not is_moving_ladder and ladder_pivot.rotation_degrees != min_ladder_angle_deg:
		tween_ladder(min_ladder_angle_deg)
#		ladder_pivot.rotate(-delta * ladder_speed)
#		ladder_pivot.rotation_degrees = clamp(ladder_pivot.rotation_degrees, min_ladder_angle_deg, max_ladder_angle_deg)
#		shadow_ladder_pivot.rotation_degrees = -ladder_pivot.rotation_degrees/2

#
#func _process(delta: float) -> void:
#	if Input.is_action_pressed("jump"):
#		ladder_pivot.rotate(delta * ladder_speed)
#		ladder_pivot.rotation_degrees = clamp(ladder_pivot.rotation_degrees, min_ladder_angle_deg, max_ladder_angle_deg)
#		shadow_ladder_pivot.rotation_degrees = -ladder_pivot.rotation_degrees/2
#	if Input.is_action_pressed("lights"):
#		ladder_pivot.rotate(-delta * ladder_speed)
#		ladder_pivot.rotation_degrees = clamp(ladder_pivot.rotation_degrees, min_ladder_angle_deg, max_ladder_angle_deg)
#		shadow_ladder_pivot.rotation_degrees = -ladder_pivot.rotation_degrees/2

func tween_ladder(ladder_rot: float) -> void:
	if tween:
		if tween.is_valid():
			tween.kill()
	tween = create_tween()
	is_moving_ladder = true
	var ladder_time = (ladder_rot - ladder_pivot.rotation_degrees)/(max_ladder_angle_deg-min_ladder_angle_deg)
	tween.tween_property(ladder_pivot, "rotation_degrees", ladder_rot, abs(ladder_time))
	tween.parallel().tween_property(shadow_ladder_pivot, "rotation_degrees", -ladder_rot/2, abs(ladder_time))
	tween.tween_callback(self, "set_is_moving_ladder", [false])
	cat_collision.set_deferred("disabled", !cat_collision.disabled)
	
func jump() -> void:
	pass
#	if is_jumping: return 
#
#	is_jumping = true
#	animation_player.play("jump")
#	jump_sfx.pitch_scale = rand_range(1.0 - PITCH_RAND, 1.0 + PITCH_RAND)
#	jump_sfx.play()


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


func set_animation_loop(anim_name: String, loop: bool) -> void:
	animation_player.get_animation(anim_name).set_loop(loop)


func set_is_moving_ladder(moving: bool) -> void:
	is_moving_ladder = moving


func _on_time_of_day_changed(state):
	match state:
		Globals.DAY:
			front_light_rays.visible = false
		Globals.NIGHT:
			front_light_rays.visible = true


func _on_CatDiscovery_area_entered(area):
	pass # Replace with function body.
