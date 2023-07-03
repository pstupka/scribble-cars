extends CanvasLayer
class_name MobileControls


func _ready():
	if not Settings.get("on_screen_controls_visible"):
		queue_free()

