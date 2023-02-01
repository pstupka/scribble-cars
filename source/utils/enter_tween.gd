extends Node
class_name EnterTweener

signal enter_tween_completed()

export(Array, NodePath) var node_paths = []
export var tween_duration := 1.0
export var object_time_offset: = 0.1

func _ready() -> void:
	pause_mode = Node.PAUSE_MODE_PROCESS
	for node in node_paths:
		var obj = get_node(node)
		obj.visible = false

func apply_tween():
	if !node_paths: return
	
	var tween = create_tween() \
				.set_ease(Tween.EASE_OUT) \
				.set_trans(Tween.TRANS_BACK)
				
	for i in range(node_paths.size()):
		var object = get_node(node_paths[i])
		tween.parallel().tween_property(object, "position:y", object.position.y, tween_duration) \
			.from(object.position.y + 1000) \
			.set_delay(0.2 + i*object_time_offset)
		tween.parallel().tween_callback(object, "set_visible", [true]) \
			.set_delay(0.2 + i*object_time_offset)
	tween.tween_callback(self, "emit_signal", ["enter_tween_completed"])

