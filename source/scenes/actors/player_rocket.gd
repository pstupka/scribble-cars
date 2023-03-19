extends RigidBody2D

export (int) var engine_thrust = 100
onready var pivot: Node2D = $Pivot

export var camera_zoom_speed_threshold = 500.0
var thrust := Vector2.ZERO
var direction := Vector2.ZERO



func _ready() -> void:
	pass 


func _process(delta: float) -> void:
	direction.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	direction.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
#	direction = direction.normalized()

	if direction:
		pivot.rotation = lerp_angle(pivot.rotation, direction.angle(), 0.1)
		thrust = Vector2(engine_thrust, 0)
	else:
		thrust = Vector2.ZERO
	
func _physics_process(delta: float) -> void:
	set_applied_force(thrust.rotated(direction.angle()) * clamp(direction.length(), 0, 1))
	var zoom_addition = 0
	if linear_velocity.length() > camera_zoom_speed_threshold: 
		zoom_addition = clamp(linear_velocity.length()/1000.0, 0.0, 0.3)
	$Camera2D.zoom = lerp($Camera2D.zoom, Vector2(1 + zoom_addition, 1 + zoom_addition), 0.01)
	print(linear_velocity.length())
