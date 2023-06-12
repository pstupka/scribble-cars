extends CanvasLayer
class_name MobileControls

func _ready():
	hide()
	if OS.get_name() != "Android" and OS.get_name() != "HTML5": 
		queue_free()
	else: 
		show()
