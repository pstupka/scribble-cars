extends KinematicBody2D

onready var siren = $Pivot/AnimationPivot/Sprites/Siren
onready var star_05 = $Pivot/AnimationPivot/Sprites/Siren/Star05
onready var front_light = $Pivot/AnimationPivot/FrontLight
onready var back_light = $Pivot/AnimationPivot/BackLight



func _ready():
	var siren_tween = create_tween().set_loops().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	siren_tween.tween_property(star_05, "scale", 1.5*Vector2.ONE, 0.4).from(Vector2(0.5,0.5))
	siren_tween.parallel().tween_property(siren, "modulate", Color("b45252"), 0.2)
	siren_tween.tween_property(star_05, "scale", 1.5*Vector2.ONE, 0.4).from(Vector2(0.5,0.5))
	siren_tween.parallel().tween_property(siren, "modulate", Color("68c2d3"), 0.2)
	
	Events.connect("time_of_day_changed", self, "_on_time_of_day_changed")


func _on_time_of_day_changed(state):
	match state:
		Globals.DAY:
			front_light.enabled = false
			back_light.enabled = false
		Globals.NIGHT:
			front_light.enabled = true
			back_light.enabled = true
