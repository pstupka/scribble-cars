extends KinematicBody2D

onready var front_light := $Pivot/FrontLight
onready var back_light := $Pivot/BackLight

export var speed := 150.0
var direction := Vector2.ZERO
var previous_direction := Vector2.ZERO


func _ready() -> void:
	scale.x = -1
	Events.connect("time_of_day_changed", self, "_on_time_of_day_changed")


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


func flip() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(self, "scale:x", -sign(direction.x), 0.2)


func _on_time_of_day_changed(state):
	match state:
		Globals.DAY:
			front_light.enabled = false
			back_light.enabled = false
		Globals.NIGHT:
			front_light.enabled = true
			back_light.enabled = true
	
