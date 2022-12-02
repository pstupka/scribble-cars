extends Area2D

export var spawn_apple_timer = 10.0

onready var timer = $Timer
onready var animation_player = $AnimationPlayer


func _ready() -> void:
	randomize()
	
	timer.wait_time = spawn_apple_timer
	

	Events.connect("time_of_day_changed", self, "_on_time_of_day_changed")
	timer.wait_time = rand_range(10.0, 15.0)
	timer.start()
	timer.connect("timeout", self, "_on_Timer_timeout")


func make_apple() -> void:
	animation_player.play("make_apple")


func _on_Timer_timeout():
	make_apple()


func _on_time_of_day_changed(state):
	match state:
		Globals.DAY:
			timer.paused = false
		Globals.NIGHT:
			timer.paused = true
