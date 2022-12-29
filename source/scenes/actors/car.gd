extends KinematicBody2D

onready var siren = $Pivot/AnimationPivot/Sprites/SirenL
onready var star_05 = $Pivot/AnimationPivot/Sprites/Siren/Star05


func _ready():
	var siren_tween = create_tween().set_loops().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	siren_tween.tween_property(star_05, "scale", Vector2.ONE, 0.4).from(Vector2(0.5,0.5))
	siren_tween.parallel().tween_property(siren, "color", Color("b45252"), 0.2)
	siren_tween.tween_property(star_05, "scale", Vector2.ONE, 0.4).from(Vector2(0.5,0.5))
	siren_tween.parallel().tween_property(siren, "color", Color("68c2d3"), 0.2)
