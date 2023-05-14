extends RigidBody2D

var engine_thrust := 10000
export (int) var engine_thrust_normal = 10000
export (int) var engine_thrust_boost = 50000

onready var pivot: Node2D = $Pivot
onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
onready var engine_1_particles: Particles2D = $"%Engine1Particles"
onready var engine_2_particles: Particles2D = $"%Engine2Particles"
onready var animation_player: AnimationPlayer = $AnimationPlayer
onready var engine_2_basic: Particles2D = $Pivot/AnimationPivot/Engine2Basic
onready var engine_1_basic: Particles2D = $Pivot/AnimationPivot/Engine1Basic
onready var ui_sfx: AudioStreamPlayer = $uiSfx
onready var turbo_sfx: AudioStreamPlayer = $TurboSfx



export var camera_zoom_speed_threshold = 500.0
var thrust := Vector2.ZERO
var direction := Vector2.ZERO


func _ready() -> void:
	Globals.camera= $Camera2D 


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("lights"):
		if ui_sfx.playing: return
		ui_sfx.play()
		engine_thrust = engine_thrust_boost
		engine_1_particles.emitting = true
		engine_2_particles.emitting = true
		turbo_sfx.pitch_scale = 1.39
#		turbo_sfx.volume_db = 0.0
	if event.is_action_released("lights"):
		engine_thrust = engine_thrust_normal
		engine_1_particles.emitting = false
		engine_2_particles.emitting = false
#		turbo_sfx.volume_db = -60.0
		turbo_sfx.pitch_scale = 1.0

func _process(_delta: float) -> void:

	direction.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	direction.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	
	if direction:
		if not engine_2_basic.emitting: 
			engine_2_basic.emitting = true
		if not engine_1_basic.emitting: 
			engine_1_basic.emitting = true
		if not animation_player.is_playing():
			animation_player.play("move")
		pivot.rotation = lerp_angle(pivot.rotation, direction.angle(), 0.1)
		thrust = Vector2(engine_thrust, 0)
	else:
		if engine_2_basic.emitting: 
			engine_2_basic.emitting = false
		if engine_1_basic.emitting: 
			engine_1_basic.emitting = false
			
		thrust = Vector2.ZERO
	
	var zoom_addition = 0
	if linear_velocity.length() > camera_zoom_speed_threshold: 
		zoom_addition = clamp(linear_velocity.length()/3000.0, 0.0, 0.3)
	$Camera2D.zoom = lerp($Camera2D.zoom, Vector2(1.0 + zoom_addition, 1.0 + zoom_addition), 0.01)
	

	
func _physics_process(_delta: float) -> void:
	set_applied_force(thrust.rotated(direction.angle()) * clamp(direction.length(), 0, 1))
