extends Node2D

var speed := 100.0
var direction := Vector2.RIGHT
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _physics_process(delta: float) -> void:
	direction.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	
	position.x += speed * delta * direction.x
	if direction.x != 0:
		scale.x = -sign(direction.x)
