extends KinematicBody2D
class_name Player

onready var car 
onready var camera: Camera2D = $Camera2D


export var pitch_randomness = 0.05
export(float, -300.0, 150.0) var camera_y_offset = -70.0

var direction := Vector2.ZERO
var previous_direction := Vector2.ZERO
var is_flipping := false 
var velocity

var _car_index = 0

func _ready() -> void:
	randomize()
	camera.position.y = camera_y_offset
	car = Globals.car_templates[ Globals.available_cars[owner.scene_type][0]].instance()
	add_child(car)
	
	car.animation_player.connect("animation_finished", self, "_on_car_animation_finished")


func _input(event):
	if event.is_action_pressed("jump"):
		car.jump()
		
	if event.is_action_pressed("honk"):
		car.honk()
	
	if event.is_action_pressed("change_car"):
		change_car()
	
	if event.is_action_pressed("lights") and car.has_method("lights"):
		car.lights()

func _physics_process(_delta: float) -> void:
	previous_direction = direction
	direction.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	direction.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	
	if direction.x != 0:
		if sign(previous_direction.x) != sign(direction.x):
			flip()
	
	velocity = move_and_slide(car.speed * direction)
#	position += car.speed * delta * direction
	position.y = clamp(position.y, Globals.ROAD_MIN_POSITION, Globals.ROAD_MAX_POSITION)
	
	if not car.is_jumping and not car.animation_player.is_playing():
		if direction:
			car.animation_player.play("move")


func flip() -> void:
	is_flipping = true 
	var tween = get_tree().create_tween()
	tween.tween_property(car, "scale:x", -sign(direction.x), 0.2)
	tween.tween_callback(self, "set_deferred", ["is_flipping", false])


func change_car():
	if car.is_jumping or is_flipping: return
	var face_direction = sign(car.scale.x)
	car.visible = false
	car.animation_player.stop()
	car.queue_free()
	
	_car_index += 1
	_car_index = _car_index % Globals.available_cars[owner.scene_type].size()
	var new_car = Globals.car_templates[Globals.available_cars[owner.scene_type][_car_index]].instance()

	add_child(new_car)
	car = new_car
	car.scale.x = face_direction

	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween.tween_property(car, "scale:y", 1.0, 1.2).from(0.0)

	car.animation_player.connect("animation_finished", self, "_on_car_animation_finished")


func _on_car_animation_finished(anim_name: String):
	if (anim_name == "jump"):
		car.is_jumping = false
	if anim_name == "move" and not direction:
		car.animation_player.stop(true)


func _on_WrapAreaL_area_entered(area):
	if area.is_in_group("wrapable"):
		area.global_position.x = $WrapAreaL/TargetPosition.global_position.x
	if area.is_in_group("streetlight"):
		area.get_parent().global_position.x = $WrapAreaL/TargetPosition.global_position.x


func _on_WrapAreaR_area_entered(area):
	if area.is_in_group("wrapable"):
		area.global_position.x = $WrapAreaR/TargetPosition.global_position.x
	if area.is_in_group("streetlight"):
		area.get_parent().global_position.x = $WrapAreaR/TargetPosition.global_position.x
