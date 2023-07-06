extends Control

onready var pik_sfx: AudioStreamPlayer = $SFX/PikSfx
onready var bg: Node2D = $Bg
onready var level_previous: TextureButton = $"%LevelPrevious"
onready var level_next: TextureButton = $"%LevelNext"
onready var background_music = $SFX/BackgroundMusic
var can_start_game = true

var current_level_selected := 0

var level_selection_scenes := [
	{
		"scene": preload("res://source/scenes/menu/bg_scenes/forest_scene.tscn"),
		"machine": preload("res://source/scenes/actors/car_templates/car_kia.tscn"),
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
	{
		"scene": preload("res://source/scenes/menu/bg_scenes/firetruck_scene.tscn"),
		"machine": preload("res://source/scenes/actors/car_templates/car_firetruck1.tscn"),
		"level": "res://source/scenes/levels/firetruck.tscn"
	},
]

onready var level_selection_transition_rect: ColorRect = $LevelSelectionTransitionRect
onready var game_start_transition_rect = $GameStartTransitionRect

onready var machine_pivot: Node2D = $MachinePivot
var can_change_scene = false setget set_can_change_scene


func _ready() -> void:
	game_start_transition_rect.show()

	Globals.daynight = Globals.DAY
	
	var tween = create_tween()
	
	tween.tween_property(game_start_transition_rect, "color", Color(0.13, 0.13, 0.14, 0.0), 0.6)
	tween.tween_callback(game_start_transition_rect, "hide")
	tween.tween_callback(self, "set_can_change_scene", [true])
	
	var machine = $MachinePivot/Kia
	if machine.has_method("set_animation_loop"):
		machine.set_animation_loop("move", true)
	if machine.has_node("AnimationPlayer"):
		machine.animation_player.play("move")
	
	level_next.grab_focus()
	Events.connect("menu_overlay_freed", self, "_on_menu_overlay_freed")
	

func _input(_event: InputEvent) -> void:
	if Input.is_action_pressed("ui_page_up"):
		_on_LevelNext_pressed()
		return

	if Input.is_action_pressed("ui_page_down"):
		_on_LevelPrevious_pressed()
		return
	
	if Input.is_action_pressed("ui_start_game"):
		_on_StartButton_pressed()
		return


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
	
	tween.tween_callback(level_selection_transition_rect, "show", [])
	tween.tween_property(level_selection_transition_rect, "color", Color(0.13, 0.13, 0.14, 1.0), 0.3)
	tween.tween_callback(level_bg, "show")
	if bg.get_child_count() > 1:
		tween.tween_callback(bg.get_child(0), "call_deferred", ["queue_free"])
	if machine_pivot.get_child_count() > 1:
		tween.tween_callback(machine_pivot.get_child(0), "call_deferred", ["queue_free"])
	tween.parallel().tween_callback(machine, "show")

	tween.tween_property(level_selection_transition_rect, "color", Color(0.13, 0.13, 0.14, 0.0), 0.3)
	
	if machine.has_method("set_animation_loop"):
		machine.set_animation_loop("move", true)
	if machine.has_node("AnimationPlayer"):
		machine.animation_player.play("move")

	tween.tween_callback(level_selection_transition_rect, "hide", [])
	tween.tween_callback(self, "set_deferred", ["can_change_scene", true])


func start_game() -> void:
	var _err = get_tree().change_scene(level_selection_scenes[current_level_selected]["level"])


func set_buttons_focus(focus: bool) -> void:
	var focus_mode = Control.FOCUS_ALL if focus else Control.FOCUS_NONE
	$MarginContainer2/InfoButton.focus_mode = focus_mode
	$ButtonsContainer/ExitButton.focus_mode = focus_mode
	$ButtonsContainer/SettingsButton.focus_mode = focus_mode
	$ButtonsContainer/StartButton.focus_mode = focus_mode
	$"%LevelPrevious".focus_mode = focus_mode
	$"%LevelNext".focus_mode = focus_mode
	if focus:
		$"%LevelNext".grab_focus()

func _on_LevelPrevious_pressed() -> void:
	if not can_change_scene: return
	
	pik_sfx.play()
	var next_level = (current_level_selected - 1) % level_selection_scenes.size()
	change_level_selection(next_level)
	level_previous.grab_focus()


func _on_LevelNext_pressed() -> void:
	if not can_change_scene: return
	
	pik_sfx.play()
	var next_level = (current_level_selected + 1) % level_selection_scenes.size()
	change_level_selection(next_level)
	level_next.grab_focus()


func _on_StartButton_pressed() -> void:
	if not can_change_scene: return # Guard for double click during splash fade out
	if not can_start_game: return
	
	can_start_game = false
	$ButtonsContainer/StartButton.disabled = true
	pik_sfx.play()
	
	var tween = create_tween()
	game_start_transition_rect.show()
	tween.tween_property(game_start_transition_rect, "color", Color(0.13, 0.13, 0.14, 1.0), 0.6)
	tween.parallel().tween_property(background_music, "volume_db", -40.0, 0.5)
	tween.tween_callback(self, "start_game").set_delay(0.1)


func _on_InfoButton_pressed():
	pik_sfx.play()
	var info = load("res://source/scenes/menu/info_menu.tscn").instance()
	add_child(info)
	Events.connect("menu_overlay_freed", self, "set_buttons_focus", [true], CONNECT_ONESHOT)
	set_buttons_focus(false)
	can_start_game = false


func _on_SettingsButton_pressed():
	pik_sfx.play()
	var settings = load("res://source/scenes/menu/settings_menu.tscn").instance()
	add_child(settings)
	Events.connect("menu_overlay_freed", self, "set_buttons_focus", [true], CONNECT_ONESHOT)
	set_buttons_focus(false)
	can_start_game = false


func _on_ExitButton_pressed():
	can_start_game = false
	can_change_scene = false
	pik_sfx.play()
	var tween = create_tween().tween_callback(get_tree(), "quit").set_delay(0.3)


func _on_menu_overlay_freed():
	can_start_game = true


func set_can_change_scene(val: bool):
	can_change_scene = val
