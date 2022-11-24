extends KinematicBody2D

onready var front_light := $FrontLight
onready var back_light := $BackLight

export var speed := 150.0
var direction := Vector2.ZERO
var previous_direction := Vector2.ZERO


func _ready() -> void:
	scale.x = -1


func _input(event: InputEvent):
	if event.is_action_pressed("lights"):
		front_light.enabled = !front_light.enabled
		back_light.enabled = !back_light.enabled


func _physics_process(delta: float) -> void:
	previous_direction = direction
	direction.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	direction.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	
	
	position.x += speed * delta * direction.x
	if direction.x != 0:
		if sign(previous_direction.x) != sign(direction.x):
			flip()
	
	position.y += speed * delta * direction.y
	position.y = clamp(position.y, 350, 420)


func flip() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(self, "scale:x", -sign(direction.x), 0.2)

