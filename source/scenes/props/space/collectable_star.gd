extends Area2D

onready var star: Sprite = $Star/Star04

export (Color) var color setget set_color
export (float) var color_intensity
var is_inactive = false

var star_colors = {
	"4b80ca" : 1.5,
	"cf8acb" : 1.4,
	"c2d368" : 1.5,
	"edc8c4" : 1.4,
	"a2dcc7" : 1.5,
	"b45252" : 1.7,
	}

var tween :SceneTreeTween= null

func _ready() -> void:
	set_random_color()


func set_random_color():
	var colors = star_colors.keys()
	var new_color = colors[randi() % colors.size()]
	set_color(Color(new_color)).set_color_intensity(star_colors[new_color])


func set_color(new_color: Color):
	if star:
		star.modulate = new_color
	return self


func set_color_intensity(new_intensity: float):
	if star:
		star.self_modulate = Color(new_intensity, new_intensity, new_intensity)
	return self


func _on_CollectableStar_body_entered(body: Node) -> void:
	if not body.is_in_group("Player"): return
	if tween:
		tween.kill()
	tween = create_tween()
	$CollisionShape2D.set_deferred("disabled", true)
	tween.tween_property(self, "modulate", Color(1.0, 1.0, 1.0, 0.0), 0.5)
	tween.parallel().tween_property(star, "scale", Vector2(2.0, 2.0), 0.5)
	is_inactive = true


func _on_VisibilityNotifier2D_screen_exited() -> void:
	if is_inactive:
		if tween:
			tween.kill()
		is_inactive = false
		$CollisionShape2D.set_deferred("disabled", false)
		modulate = Color(1.0, 1.0, 1.0, 1.0)
		star.scale = Vector2.ONE
