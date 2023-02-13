extends ParallaxBackground

onready var overlay_texture = $PauseOverlay/ColorRect
onready var pause_rich_label = $PauseOverlay/PauseLabel

var pause_menu_active = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		if get_tree().paused != pause_menu_active: return
		
		if pause_menu_active:
			get_tree().paused = false
			pause_menu_active = false
			tween_pause_menu(0.0, 0.0)
		else:
			get_tree().paused = true
			pause_menu_active = true
			tween_pause_menu(3.0, 1.0)


func tween_pause_menu(target_blur: float, target_percent_visible: float) -> void:
	var tween = create_tween()
	tween.tween_property(overlay_texture.material, "shader_param/lod", target_blur, 1.0)
	tween.parallel().tween_property(pause_rich_label, "percent_visible", target_percent_visible, 0.4)
