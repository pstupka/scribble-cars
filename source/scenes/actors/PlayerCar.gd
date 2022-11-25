extends KinematicBody2D

onready var front_light := $Pivot/FrontLight
onready var back_light := $Pivot/BackLight

export var speed := 150.0
var direction := Vector2.ZERO
var previous_direction := Vector2.ZERO


func _ready() -> void:
	scale.x = -1
	modulate = Color("#676767")
	Events.connect("time_of_day_changed", self, "_on_time_of_day_changed")


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
	position.y = clamp(position.y, 360, 430)


func flip() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(self, "scale:x", -sign(direction.x), 0.2)

func _on_time_of_day_changed(state):
	match state:
		Globals.DAY:
			modulate = Globals.DAY_MODULATE
		Globals.NIGHT:
			modulate = Globals.NIGHT_MODULATE
