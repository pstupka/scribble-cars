extends Node2D

export var day_position := 0.0
export var day_ease_type := Tween.EASE_OUT
export var day_trans_type := Tween.TRANS_QUAD



export var night_position := 0.0
export var night_ease_type := Tween.EASE_OUT
export var night_trans_type := Tween.TRANS_QUAD

func _ready() -> void:
	var _err = Events.connect("time_of_day_changed", self, "_on_time_of_day_changed")


func _on_time_of_day_changed(state):
	var tween = create_tween()
	match state:
		Globals.DAY:
			tween.set_ease(day_ease_type) \
				.set_trans(day_trans_type) \
				.tween_property(get_parent(), "position:y", day_position, 1.0)
		Globals.NIGHT:
			tween.set_ease(night_ease_type) \
				.set_trans(night_trans_type) \
				.tween_property(get_parent(), "position:y", night_position, 1.0)
