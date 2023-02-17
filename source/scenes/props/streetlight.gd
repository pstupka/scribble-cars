extends YSort

enum LIGHT {RED, YELLOW, GREEN}
var _previous_light
var current_light = LIGHT.GREEN setget set_light

var default_modulate = Color.white
var tween = null

onready var red_light: Sprite = $Line2/Lights/RedLight
onready var red_light2: Sprite = $Line1/Lights/RedLight

onready var yellow_light: Sprite = $Line2/Lights/YellowLight
onready var yellow_light2: Sprite = $Line1/Lights/YellowLight

onready var green_light: Sprite = $Line2/Lights/GreenLight
onready var green_light2: Sprite = $Line1/Lights/GreenLight

onready var stop_collision2: CollisionShape2D = $StopArea2/CollisionShape2D
onready var stop_collision: CollisionShape2D = $StopArea/CollisionShape2D
onready var player_stop_collision: CollisionShape2D = $PlayerStop/CollisionShape2D
onready var player_discovery_area: Area2D = $PlayerDiscoveryArea


func _ready() -> void:
	set_light(LIGHT.GREEN)
	
	tween = create_tween().set_loops()

	tween.tween_callback(self, "set_light", [LIGHT.YELLOW]).set_delay(15.0)
	tween.tween_callback(self, "set_light", [LIGHT.RED]).set_delay(2.0)
	tween.tween_callback(self, "set_light", [LIGHT.YELLOW]).set_delay(8.0)
	tween.tween_callback(self, "set_light", [LIGHT.GREEN]).set_delay(1.5)


func set_light(light: int) -> void:
	_previous_light = current_light
	current_light = light
	match light:
		LIGHT.GREEN:
			red_light.modulate = default_modulate
			red_light2.modulate = default_modulate
			green_light.modulate = Color(0, 300, 0)
			green_light2.modulate = Color(0, 300, 0)
			yellow_light.modulate = default_modulate
			yellow_light2.modulate = default_modulate
			stop_collision2.set_deferred("disabled", true)
			stop_collision.set_deferred("disabled", true)
			player_stop_collision.set_deferred("disabled", true)
		LIGHT.YELLOW:
			if _previous_light != LIGHT.RED:
				red_light.modulate = default_modulate
				red_light2.modulate = default_modulate
			green_light.modulate = default_modulate
			green_light2.modulate = default_modulate
			yellow_light.modulate = Color(300, 300, 0)
			yellow_light2.modulate = Color(300, 300, 0)
			if _previous_light == LIGHT.GREEN and player_discovery_area.get_overlapping_bodies().size() > 0:
				tween.pause()
		LIGHT.RED: 
			red_light.modulate = Color(300, 0, 0)
			red_light2.modulate = Color(300, 0, 0)
			green_light.modulate = default_modulate
			green_light2.modulate = default_modulate
			yellow_light.modulate = default_modulate
			yellow_light2.modulate = default_modulate
			stop_collision2.set_deferred("disabled", false)
			stop_collision.set_deferred("disabled", false)
			player_stop_collision.set_deferred("disabled", false)


func _on_PlayerDiscoveryArea_body_exited(body: Node) -> void:
	if body.is_in_group("player"):
		tween.play()


func _on_PlayerDiscoveryArea_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		if current_light == LIGHT.YELLOW and _previous_light == LIGHT.GREEN:
			tween.pause()
