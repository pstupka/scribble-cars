extends KinematicBody2D

onready var car := $Car

export var pitch_randomness = 0.05


var direction := Vector2.ZERO
var previous_direction := Vector2.ZERO
export var is_jumping = false
var velocity

var car_templates : Array = [
	preload("res://source/scenes/actors/car_templates/car1.tscn"),
	preload("res://source/scenes/actors/car_templates/car_police.tscn"),
	preload("res://source/scenes/actors/car_templates/car_template.tscn"),
]


func _ready() -> void:
	randomize()
	is_jumping = false

	car.animation_player.connect("animation_finished", self, "_on_car_animation_finished")
	
	if OS.get_name() != "Android" and OS.get_name() != "HTML5": 
		$MobileControls.queue_free()


func _input(event):
	if event.is_action_pressed("jump") and not is_jumping:
		is_jumping = true
		if (Input.get_connected_joypads().size() > 0):
			Input.start_joy_vibration(0, 0.3, 0.0, 0.1)
		if OS.get_name() == "Android" or OS.get_name() == "HTML5":
			Input.vibrate_handheld(100)
		car.jump()
		
	if event.is_action_pressed("honk"):
		car.honk()
	
	if event.is_action_pressed("change_car"):
		change_car()
	
func _physics_process(delta: float) -> void:
	previous_direction = direction
	direction.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	direction.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	

	if direction.x != 0:
		if sign(previous_direction.x) != sign(direction.x):
			flip()
	
#	velocity = move_and_slide(speed * direction)
	position += car.speed * delta * direction
	position.y = clamp(position.y, Globals.ROAD_MIN_POSITION, Globals.ROAD_MAX_POSITION)
	
	if not is_jumping and not car.animation_player.is_playing():
		if direction:
			car.animation_player.play("move")


func flip() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(car, "scale:x", -sign(direction.x), 0.2)


func change_car():
	if is_jumping: return
	var face_direction = sign(car.scale.x)
	car.visible = false
	car.animation_player.stop()
	car.queue_free()
	var new_car_tmpl = car_templates.pop_front()
	var new_car = new_car_tmpl.instance()
	
	car_templates.push_back(new_car_tmpl)
	
	add_child(new_car)
	car = new_car
	car.scale.x = face_direction
	
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween.tween_property(car, "scale:y", 1.0, 1.2).from(0.0)
	
	car.animation_player.connect("animation_finished", self, "_on_car_animation_finished")


func _on_car_animation_finished(anim_name: String):
	if (anim_name == "jump"):
		is_jumping = false
	if anim_name == "move" and not direction:
		car.animation_player.stop(true)
		


func _on_WrapAreaL_area_entered(area):
	if area.is_in_group("wrapable"):
		area.global_position.x = $WrapAreaL/TargetPosition.global_position.x


func _on_WrapAreaR_area_entered(area):
	if area.is_in_group("wrapable"):
		area.global_position.x = $WrapAreaR/TargetPosition.global_position.x
