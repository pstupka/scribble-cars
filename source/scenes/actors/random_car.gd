extends KinematicBody2D


var screen_exit_delayed = false

export var speed = 50
var direction := Vector2.LEFT setget set_direction
var velocity
var car = null

func _ready():
	randomize()	
	var new_car = Globals.car_templates[randi() % Globals.car_templates.size()].instance()
	add_child(new_car)
	car = new_car
	car.scale.x = -direction.x
	car.color = Globals.available_colors[randi() % Globals.available_colors.size()]
	car.animation_player.connect("animation_finished", self, "_on_car_animation_finished")
	car.animation_player.play("move")

func _physics_process(_delta) -> void:
	velocity = move_and_slide(car.speed * direction)


func set_direction(new_direction):
	if not car: return
	car.scale.x = -new_direction.x
	direction.x = new_direction.x


func _on_car_animation_finished(anim_name: String):
	car.animation_player.play("move")


func _on_screen_entered() -> void:
	screen_exit_delayed = false
	$VisibilityNotifier2D/ScreenExitedDelay.start()


func _on_screen_exited():
	if screen_exit_delayed:
		call_deferred("queue_free")


func _on_CarDiscoverArea_body_entered(body):
	if body.is_in_group("player"):
		car.jump()


func _on_ScreenExitedDelay_timeout() -> void:
	screen_exit_delayed = true
