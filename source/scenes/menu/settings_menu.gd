extends Control

var tween: SceneTreeTween

func _ready():
	$ExitButton.grab_focus()
	tween = create_tween()
	tween.tween_property(self, "modulate", Color(1.0, 1.0, 1.0, 1.0), 0.4) \
		 .from(Color(1.0, 1.0, 1.0, 0.0))

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		close_menu()


func close_menu() -> void:
	if tween.is_valid():
		tween.kill()
	
	tween = create_tween()
	tween.tween_property(self, "modulate", Color(1.0, 1.0, 1.0, 0.0), 0.4)
	tween.tween_callback(Events, "emit_signal", ["menu_overlay_freed"])
	tween.tween_callback(self, "queue_free")


func _on_ExitButton_pressed():
	close_menu()
