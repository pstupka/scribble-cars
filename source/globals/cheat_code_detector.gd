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
	if not cheats_enabled: return
	
	typing_timer = Timer.new()
	get_tree().root.call_deferred("add_child", typing_timer)
	typing_timer.one_shot = true
	typing_timer.connect("timeout", self, "_on_typing_timer_timeout")
	

func _input(event: InputEvent) -> void:
	if not cheats_enabled: return
	
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
				print("Darek moode activated")
				for pedestrian in get_tree().get_nodes_in_group("pedestrian"):
					pedestrian.sprite.texture = load("res://assets/sprites/npc/darek.png")
					pedestrian.sprite.position.y = -pedestrian.sprite.texture.get_size().y / 4


func _on_typing_timer_timeout() -> void:
	_code_buffer = ""
