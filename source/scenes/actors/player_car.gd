extends KinematicBody2D

onready var animation_player = $AnimationPlayer
onready var front_light := $Pivot/AnimationPivot/FrontLight
onready var back_light := $Pivot/AnimationPivot/BackLight
onready var pivot = $Pivot

export var speed := 150.0
var direction := Vector2.ZERO
var previous_direction := Vector2.ZERO
export var is_jumping = false

func _ready() -> void:
	is_jumping = false
	pivot.scale.x = -1
	Events.connect("time_of_day_changed", self, "_on_time_of_day_changed")



func _input(event):
	if event.is_action_pressed("jump") and not is_jumping:
		is_jumping = true
		animation_player.play("jump")


func _physics_process(delta: float) -> void:
	previous_direction = direction
	direction.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	direction.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	
	
	position.x += speed * delta * direction.x
	if direction.x != 0:
		if sign(previous_direction.x) != sign(direction.x):
			flip()
	
	position.y += speed * delta * direction.y
	position.y = clamp(position.y, Globals.ROAD_MIN_POSITION, Globals.ROAD_MAX_POSITION)
	
	if not is_jumping and not animation_player.is_playing():
		if direction:
			animation_player.play("move")


func flip() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(pivot, "scale:x", -sign(direction.x), 0.2)


func _on_time_of_day_changed(state):
	match state:
		Globals.DAY:
			front_light.enabled = false
			back_light.enabled = false
		Globals.NIGHT:
			front_light.enabled = true
			back_light.enabled = true
	


func _on_WrapAreaL_area_entered(area):
	if area.is_in_group("wrapable"):
		area.global_position.x = $WrapAreaL/TargetPosition.global_position.x


func _on_WrapAreaR_area_entered(area):
	if area.is_in_group("wrapable"):
		area.global_position.x = $WrapAreaR/TargetPosition.global_position.x
