extends Node2D


onready var digit_1: Sprite = $"%Digit1"
onready var digit_0: Sprite = $"%Digit0"

func _ready() -> void:
	digit_0.frame = (Globals.score % 10)
	digit_1.frame = int(Globals.score / 10)

	var tween = create_tween()
	
	tween.tween_property(digit_0, "scale", Vector2(1.6, 1.6), 0.6)
	if Globals.score > 9: 
		tween.parallel().tween_property(digit_1, "scale", Vector2(1.6, 1.6), 0.6)
		digit_0.offset.x += 50
		digit_1.offset.x -= 50
	tween.parallel().tween_property($Pivot, "position", (200*Vector2.UP).rotated(deg2rad(rand_range(-30.0, 30.0))), 0.6)
	
	tween.tween_property(digit_0, "modulate", Color("00ffffff"), 0.4).set_delay(0.2)
	tween.parallel().tween_property(digit_1, "modulate", Color("00ffffff"), 0.4).set_delay(0.2)
	tween.tween_callback(self, "queue_free")
