extends Control

onready var bg: Node2D = $Bg

var current_level_selected := -1

var level_selection_scenes := [
	{
		"scene": preload("res://source/scenes/menu/bg_scenes/forest_scene.tscn"),
		"machine": preload("res://source/scenes/actors/car_templates/car_template.tscn"),
		"level": "res://source/scenes/Main.tscn",
	},
	{
		"scene": preload("res://source/scenes/menu/bg_scenes/space_scene.tscn"),
		"machine": preload("res://source/scenes/props/space/menu_rocket_button.tscn"),
		"level": "res://source/scenes/levels/Space.tscn"
	},
	{
		"scene": preload("res://source/scenes/menu/bg_scenes/city_scene.tscn"),
		"machine": preload("res://source/scenes/actors/car_templates/bus3.tscn"),
		"level": "res://source/scenes/levels/city.tscn"
	},
	
]

onready var transition_rect: ColorRect = $TransitionRect
onready var machine_pivot: Node2D = $MachinePivot
var can_change_scene = true

func _ready() -> void:
	OS.set_window_maximized(true) # TODO: Make it on splash screen
	Globals.daynight = Globals.DAY
	randomize()
	
	change_level_selection(0)
	

func _input(event: InputEvent) -> void:
	pass
#	if Input.is_action_pressed("ui_left") or Input.is_action_pressed("move_left"):
#		_on_LevelPrevious_pressed()
#	if Input.is_action_pressed("ui_right") or Input.is_action_pressed("move_right"):
#		_on_LevelNext_pressed()


func change_level_selection(next_level: int) -> void:
	if next_level == current_level_selected: return 
	current_level_selected = next_level
	var tween = create_tween()
	
	can_change_scene = false
	var machine = level_selection_scenes[next_level]["machine"].instance()
	var level_bg = level_selection_scenes[next_level]["scene"].instance()
	bg.add_child(level_bg)
	level_bg.hide()
	machine_pivot.add_child(machine)
	machine.hide()
	
	tween.tween_property(transition_rect, "color", Color(0.0, 0.0, 0.0, 1.0), 0.3)
	tween.tween_callback(level_bg, "show")
	if bg.get_child_count() > 1:
		tween.tween_callback(bg.get_child(0), "call_deferred", ["queue_free"])
	if machine_pivot.get_child_count() > 1:
		tween.tween_callback(machine_pivot.get_child(0), "call_deferred", ["queue_free"])
	tween.parallel().tween_callback(machine, "show")

	tween.tween_property(transition_rect, "color", Color(0.0, 0.0, 0.0, 0.0), 0.3)
	
	if machine.has_method("set_animation_loop"):
		machine.set_animation_loop("move", true)
	if machine.has_node("AnimationPlayer"):
		machine.animation_player.play("move")


	tween.tween_callback(self, "set_deferred", ["can_change_scene", true])


func _on_LevelPrevious_pressed() -> void:
	if not can_change_scene: return

	var next_level = (current_level_selected - 1) % level_selection_scenes.size()
	change_level_selection(next_level)


func _on_LevelNext_pressed() -> void:
	if not can_change_scene: return
	
	var next_level = (current_level_selected + 1) % level_selection_scenes.size()
	change_level_selection(next_level)


func _on_StartButton_pressed() -> void:
	get_tree().change_scene(level_selection_scenes[current_level_selected]["level"])

