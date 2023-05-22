extends CanvasLayer
class_name MobileControls

func _ready():
	if OS.get_name() != "Android" and OS.get_name() != "HTML5": 
		queue_free()
