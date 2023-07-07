extends Node


func _ready():
	if not OS.has_feature("debug"):
		call_deferred("queue_free")
		return

	add_actions()


func _input(event):
	if InputMap.has_action("debug_screenshot"):
		if event.is_action_pressed("debug_screenshot"):
			take_screenshot()


func add_actions() -> void:
	InputMap.add_action("debug_screenshot")
	var event = InputEventKey.new()
	event.scancode = KEY_F9
	InputMap.action_add_event("debug_screenshot", event)


func take_screenshot() -> void:
	# Capture the screenshot
	var size = OS.window_size
	var image = get_viewport().get_texture().get_data()
	
	# Setup path and screenshot filename
	var date = OS.get_datetime()
	var path = "user://screenshots"
	var file_name = "screenshot-%d-%02d-%02dT%02d.%02d.%02d" % [date.year, date.month, date.day, date.hour, date.minute, date.second]
	var dir = Directory.new()
	if not dir.dir_exists(path):
		dir.make_dir(path)

	# Find a filename that isn't taken
	var n = 1
	var file_path = path.plus_file(file_name) + ".png"
	while(true):
		if dir.file_exists(file_path):
			file_path = path.plus_file(file_name) + "-" + str(n) + ".png"
			n = n + 1
		else:
			break

	# Save the screenshot
	image.flip_y()
	image.resize(size.x, size.y, Image.INTERPOLATE_NEAREST)
	image.save_png(file_path)
