extends KinematicBody2D

var screen_exit_delayed = false

export var speed = 50
export var can_move := true
var direction := Vector2.LEFT setget set_direction
var velocity
var car = null

func _ready():
	randomize()
	
	var _car_index = randi() % Globals.available_cars[get_tree().current_scene.scene_type].size()
	var new_car = Globals.car_templates[Globals.available_cars[get_tree().current_scene.scene_type][_car_index]].instance()
	add_child(new_car)
	car = new_car
	car.scale.x = -direction.x
	car.color = Globals.available_colors[randi() % Globals.available_colors.size()]
	car.animation_player.connect("animation_finished", self, "_on_car_animation_finished")
	car.animation_player.play("move")

func _physics_process(_delta) -> void:
	if not can_move:
		if car.animation_player.get_current_animation() == "move": car.animation_player.stop()
		return
	if not car.animation_player.is_playing(): car.animation_player.play("move")
	velocity = move_and_slide(car.speed * direction)


func set_direction(new_direction):
	if not car: return
	car.scale.x = -new_direction.x
	direction.x = new_direction.x


func _on_car_animation_finished(_anim_name: String):
	car.animation_player.play("move")

func _on_screen_entered() -> void:
	screen_exit_delayed = false
	$VisibilityNotifier2D/ScreenExitedDelay.start()


func _on_screen_exited():
	if screen_exit_delayed:
		call_deferred("queue_free")


func _on_CarDiscoverArea_body_entered(body):
	if body.is_in_group("player"):
		if not car.animation_player.get_current_animation() == "jump":
			car.jump()


func _on_ScreenExitedDelay_timeout() -> void:
	screen_exit_delayed = true


func _on_CarDiscoverArea_area_entered(area: Area2D) -> void:
	if area.is_in_group("obstacle"):
		can_move = false
		$StopArea/CollisionShape2D.set_deferred("disabled", false)
		$StopArea2/CollisionShape2D.set_deferred("disabled", false)

func _on_CarDiscoverArea_area_exited(area: Area2D) -> void:
	if area.is_in_group("obstacle"):
		can_move = true
		$StopArea/CollisionShape2D.set_deferred("disabled", true)
		$StopArea2/CollisionShape2D.set_deferred("disabled", true)
