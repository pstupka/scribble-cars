extends KinematicBody2D

onready var animation_player = $Car/AnimationPlayer
onready var front_light := $Car/AnimationPivot/FrontLight
onready var back_light := $Car/AnimationPivot/BackLight
onready var sfx = $Car/Sfx
onready var jump_sfx = $Car/JumpSfx
onready var pivot: Node2D = $Car

export var pitch_randomness = 0.05

export var speed := 150.0
var direction := Vector2.ZERO
var previous_direction := Vector2.ZERO
export var is_jumping = false
var velocity

func _ready() -> void:
	randomize()
	is_jumping = false
	pivot.scale.x = -1
	Events.connect("time_of_day_changed", self, "_on_time_of_day_changed")
	animation_player.connect("animation_finished", self, "_on_car_animation_finished")
	
	if OS.get_name() != "Android" and OS.get_name() != "HTML5": 
		$MobileControls.queue_free()


func _input(event):
	if event.is_action_pressed("jump") and not is_jumping:
		is_jumping = true
		if (Input.get_connected_joypads().size() > 0):
			Input.start_joy_vibration(0, 0.3, 0.0, 0.1)
		if OS.get_name() == "Android" or OS.get_name() == "HTML5":
			Input.vibrate_handheld(100)

		animation_player.play("jump")
		jump_sfx.pitch_scale = rand_range(1.0 - pitch_randomness, 1.0 + pitch_randomness)
		jump_sfx.play()
		
	if event.is_action_pressed("honk"):
		for sound in sfx.get_children():
			if sound.is_playing(): return
		var honks_count = sfx.get_child_count()
		var honk = sfx.get_child(rand_range(0,honks_count))
		honk.pitch_scale = rand_range(1.0 - pitch_randomness, 1.0 + pitch_randomness)
		honk.play()
		var tween = create_tween()
		if (Input.get_connected_joypads().size() > 0):
			Input.start_joy_vibration(0, 0.4, 0.0, 0.4)
		if OS.get_name() == "Android" or OS.get_name() == "HTML5":
			Input.vibrate_handheld(400)
		tween.tween_property(pivot, "scale:y", 1.2, 0.15) 
		tween.tween_property(pivot, "scale:y", 1.0, 0.15)
		tween.tween_property(pivot, "scale:y", 1.2, 0.15)
		tween.tween_property(pivot, "scale:y", 1.0, 0.15)


func _physics_process(delta: float) -> void:
	previous_direction = direction
	direction.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	direction.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	
	
	position.x += speed * delta * direction.x
	if direction.x != 0:
		if sign(previous_direction.x) != sign(direction.x):
			flip()
	
#	velocity = move_and_slide(speed * direction)
	position.y += speed * delta * direction.y
	position.y = clamp(position.y, Globals.ROAD_MIN_POSITION, Globals.ROAD_MAX_POSITION)
	
	if not is_jumping and not animation_player.is_playing():
		if direction:
			animation_player.play("move")


func flip() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(pivot, "scale:x", -sign(direction.x), 0.2)


func change_car():
	if is_jumping: return


func _on_time_of_day_changed(state):
	match state:
		Globals.DAY:
			front_light.enabled = false
			back_light.enabled = false
		Globals.NIGHT:
			front_light.enabled = true
			back_light.enabled = true


func _on_car_animation_finished(anim_name: String):
	if (anim_name == "jump"):
		is_jumping = false


func _on_WrapAreaL_area_entered(area):
	if area.is_in_group("wrapable"):
		area.global_position.x = $WrapAreaL/TargetPosition.global_position.x


func _on_WrapAreaR_area_entered(area):
	if area.is_in_group("wrapable"):
		area.global_position.x = $WrapAreaR/TargetPosition.global_position.x
