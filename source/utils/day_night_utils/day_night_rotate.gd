extends Node2D
class_name DayNightRotate

export var day_rotation := 0.0
export var day_ease_type := Tween.EASE_OUT
export var day_trans_type := Tween.TRANS_QUAD



export var night_rotation := 0.0
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
				.tween_property(get_parent(), "rotation_degrees", day_rotation, 1.0)
		Globals.NIGHT:
			tween.set_ease(night_ease_type) \
				.set_trans(night_trans_type) \
				.tween_property(get_parent(), "rotation_degrees", night_rotation, 1.0)
