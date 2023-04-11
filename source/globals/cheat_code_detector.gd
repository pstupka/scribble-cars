extends Node

signal cheat_detected(cheat)

var cheats_enabled = true

var codes := {
	"UUDDLRLRBA": "darek_mode"
}

var cheat_input_actions := {
	"move_left": "L",
	"move_right": "R",
	"move_up": "U",
	"move_down": "D",
	"jump": "A",
	"lights": "B",
	"honk": "Y",
	"change_car": "X",
}

const MAX_BUFFER_LENGTH := 16

var typing_timer : Timer
var _code_buffer: String = ""


func _ready() -> void:
	if not OS.has_feature("cheats"): 
		call_deferred("queue_free")
		return
	
	typing_timer = Timer.new()
	get_tree().root.call_deferred("add_child", typing_timer)
	typing_timer.one_shot = true
	typing_timer.connect("timeout", self, "_on_typing_timer_timeout")
	

func _input(event: InputEvent) -> void:
	if not OS.has_feature("cheats"): 
		return
		
	if event as InputEventJoypadButton:
		for action in cheat_input_actions.keys():
			if event.is_action_pressed(action):
				_code_buffer += cheat_input_actions[action]
				if _code_buffer.length() > MAX_BUFFER_LENGTH: 
					_code_buffer = ""
					return
				validate_cheat(_code_buffer)
				typing_timer.start(1.0)
				return


func validate_cheat(cheat: String) -> void:
	if codes.keys().has(cheat):
		_code_buffer = ""
		emit_signal("cheat_detected", codes[cheat])
		match codes[cheat]:
			"darek_mode": 
				print("Darek mode activated")
				var darek_texture = load("res://assets/sprites/npc/darek.png")
				
				for pedestrian in get_tree().get_nodes_in_group("pedestrian"):
					pedestrian.sprite.texture = darek_texture
					pedestrian.sprite.position.y = -darek_texture.get_size().y / 4
				
				for player in get_tree().get_nodes_in_group("player"):
					var darek_sprite = Sprite.new()
					darek_sprite.texture = darek_texture
					get_tree().current_scene.add_child(darek_sprite)

					darek_sprite.global_position = player.global_position
					var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
					var camera = player.get_node("Camera2D")
					
					tween.tween_property(darek_sprite, "rotation_degrees", 760.0, 1.5)
					tween.parallel().tween_property(darek_sprite, "scale", Vector2(10.0, 10.0), 1.8)
					tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
					tween.parallel().tween_property(camera, "offset_h", 0.0, 1.0).from(randf()*4)
					tween.parallel().tween_property(camera, "offset_v", 0.0, 1.0).from(-randf()*4)
					
					tween.tween_callback(darek_sprite, "call_deferred", ["queue_free"])


func _on_typing_timer_timeout() -> void:
	_code_buffer = ""
