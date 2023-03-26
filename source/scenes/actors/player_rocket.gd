extends RigidBody2D

var engine_thrust := 10000
export (int) var engine_thrust_normal = 10000
export (int) var engine_thrust_boost = 50000

onready var pivot: Node2D = $Pivot
onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
onready var engine_1_particles: Particles2D = $"%Engine1Particles"
onready var engine_2_particles: Particles2D = $"%Engine2Particles"

export var camera_zoom_speed_threshold = 500.0
var thrust := Vector2.ZERO
var direction := Vector2.ZERO


func _ready() -> void:
	pass 


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("lights"):
		engine_thrust = engine_thrust_boost
		engine_1_particles.emitting = true
		engine_2_particles.emitting = true
	if event.is_action_released("lights"):
		engine_thrust = engine_thrust_normal
		engine_1_particles.emitting = false
		engine_2_particles.emitting = false
		

func _process(delta: float) -> void:
	direction.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	direction.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")

	if direction:
		pivot.rotation = lerp_angle(pivot.rotation, direction.angle(), 0.1)
		collision_shape_2d.rotation = pivot.rotation + PI/2
		thrust = Vector2(engine_thrust, 0)
	else:
		thrust = Vector2.ZERO
	
func _physics_process(delta: float) -> void:
	set_applied_force(thrust.rotated(direction.angle()) * clamp(direction.length(), 0, 1))
	var zoom_addition = 0
	if linear_velocity.length() > camera_zoom_speed_threshold: 
		zoom_addition = clamp(linear_velocity.length()/3000.0, 0.0, 0.5)
	$Camera2D.zoom = lerp($Camera2D.zoom, Vector2(1 + zoom_addition, 1 + zoom_addition), 0.01)
