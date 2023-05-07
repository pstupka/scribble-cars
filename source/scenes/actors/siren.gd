extends Sprite

onready var light = $LightSprite

export var color_start := Color("b45252")
export var color_end := Color("68c2d3")

func _ready():
	var siren_tween = create_tween().set_loops().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	siren_tween.tween_property(light, "scale", 1.5*Vector2.ONE, 0.4).from(Vector2(0.5,0.5))
	siren_tween.parallel().tween_property(self, "modulate", color_start, 0.2)
	siren_tween.tween_property(light, "scale", 1.5*Vector2.ONE, 0.4).from(Vector2(0.5,0.5))
	siren_tween.parallel().tween_property(self, "modulate", color_end, 0.2)
