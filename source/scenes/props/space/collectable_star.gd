extends Area2D

onready var star: Sprite = $Star/Star04

var particles_template = preload("res://source/utils/score_particles.tscn")

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

var tween : SceneTreeTween = null

func _ready() -> void:
	set_random_color()
	tween = create_tween().set_loops()
	tween.tween_property(self, "modulate", Color(1.0, 1.0, 1.0, 0.0), 0.1).set_delay(rand_range(2.0, 10.0))
	tween.tween_property(self, "modulate", Color.white, 0.1)


func set_random_color():
	var colors = star_colors.keys()
	var new_color = colors[randi() % colors.size()]
	set_color(Color(new_color)).set_color_intensity(star_colors[new_color])


func set_color(new_color: Color):
	if star:
		star.modulate = new_color
		color = new_color
	return self


func set_color_intensity(new_intensity: float):
	if star:
		star.self_modulate = Color(new_intensity, new_intensity, new_intensity)
		color_intensity = new_intensity
	return self


func _on_CollectableStar_body_entered(body: Node) -> void:
	if not body.is_in_group("Player"): return

	tween.pause()
	hide()
	$CollisionShape2D.set_deferred("disabled", true)
	is_inactive = true
	
	Globals.score = wrapi(Globals.score + 1, 1, 100)
	var score_particles = particles_template.instance()
	get_tree().current_scene.add_child(score_particles)
	score_particles.modulate = color
	score_particles.self_modulate = star.self_modulate
	score_particles.global_position = global_position


func _on_VisibilityNotifier2D_screen_exited() -> void:
	hide()
	tween.pause()
	if is_inactive:
		is_inactive = false
		$CollisionShape2D.set_deferred("disabled", false)
		star.scale = Vector2.ONE


func _on_VisibilityNotifier2D_screen_entered():
	show()
	tween.play()
