extends KinematicBody2D


onready var front_light = $Pivot/AnimationPivot/FrontLight
onready var back_light = $Pivot/AnimationPivot/BackLight
onready var pivot = $Pivot
onready var sprites = $Pivot/AnimationPivot/Sprites
onready var animation_player = $AnimationPlayer
onready var jump_sfx = $JumpSfx


export var speed = 50
var direction := Vector2.LEFT setget set_direction
var velocity

func _ready():
	Events.connect("time_of_day_changed", self, "_on_time_of_day_changed")
	pivot.scale.x = -direction.x
	_on_time_of_day_changed(Globals.daynight)

func _on_time_of_day_changed(state):
	match state:
		Globals.DAY:
			front_light.enabled = false
			back_light.enabled = false
		Globals.NIGHT:
			front_light.enabled = true
			back_light.enabled = true


func _physics_process(_delta) -> void:
	velocity = move_and_slide(speed * direction)


func set_direction(new_direction):
	pivot.scale.x = -new_direction.x
	direction.x = new_direction.x


func _on_screen_exited():
	call_deferred("queue_free")


func _on_CarDiscoverArea_body_entered(body):
	if body.is_in_group("player"):
		animation_player.play("jump")
