extends ParallaxBackground

onready var overlay_texture = $PauseOverlay/ColorRect
onready var pause_rich_label = $PauseOverlay/PauseLabel
onready var buttons_container: VBoxContainer = $PauseOverlay/Buttons

onready var main_menu_button: Button = $"%MainMenuButton"
onready var quit_button: Button = $"%QuitButton"
onready var back_button: Button = $"%BackButton"


var pause_menu_active = false

func _ready() -> void:
	if OS.get_name() == "HTML5":
		$"%QuitButton".queue_free()
	
	buttons_container.modulate = Color(1.0, 1.0, 1.0, 0.0)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		pause()


func tween_pause_menu(target_blur: float, target_percent_visible: float) -> void:
	var tween = create_tween()
	main_menu_button.disabled = not pause_menu_active
	back_button.disabled = not pause_menu_active
	if quit_button: quit_button.disabled = not pause_menu_active
	tween.tween_property(overlay_texture.material, "shader_param/lod", target_blur, 1.0)
	tween.parallel().tween_property(pause_rich_label, "percent_visible", target_percent_visible, 0.4)
	tween.parallel().tween_property(buttons_container, "modulate", Color(1.0, 1.0, 1.0, target_percent_visible), 0.4)
	


func pause() -> void:
	if get_tree().paused != pause_menu_active: return
	
	if pause_menu_active:
		get_tree().paused = false
		pause_menu_active = false
		tween_pause_menu(0.0, 0.0)
	else:
		get_tree().paused = true
		pause_menu_active = true
		tween_pause_menu(3.0, 1.0)


func _on_QuitButton_pressed() -> void:
	get_tree().quit()


func _on_MainMenuButton_pressed() -> void:
	var tween = create_tween()
	
	main_menu_button.disabled = true
	back_button.disabled = true
	if quit_button: quit_button.disabled = true
	tween.tween_property(pause_rich_label, "percent_visible", 0.0, 0.4)
	tween.parallel().tween_property(overlay_texture.material, "shader_param/lod", 0.0, 0.5)
	tween.parallel().tween_property(buttons_container, "modulate", Color(1.0, 1.0, 1.0, 0.0), 0.5)

	tween.tween_callback(overlay_texture.material, "set_shader_param", ["apply", false])
	tween.parallel().tween_property(overlay_texture, "color", Color.black, 1.0)
	tween.tween_callback(get_tree(), "set_pause", [false])
	tween.tween_callback(get_tree(), "change_scene", ["res://source/scenes/menu/menu.tscn"])


func _on_BackButton_pressed() -> void:
	pause()
