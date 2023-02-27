extends Area2D


onready var meow: AudioStreamPlayer2D = $Meow
onready var animation_player: AnimationPlayer = $AnimationPlayer
onready var sprite: Sprite = $AnimationPivot/Sprite

const PITCH_RAND = 0.4

var move_target = null
var speed = 30.0

func _ready() -> void:
	randomize()
	var cat_no = randi() % 3 + 1
	sprite.texture = load("res://assets/sprites/npc/cat%d.png" % cat_no)
	meow.pitch_scale = rand_range(1.0, 1.0 + PITCH_RAND)
	speed += rand_range(0, 20)

func _process(delta: float) -> void:
	if move_target:
		global_position += speed * delta * global_position.direction_to(move_target.global_position)


func enter_bus() -> void:
	var tween = create_tween()
	tween.tween_property(sprite, "rotation_degrees", 360.0*2, 0.6)
	tween.parallel().tween_property(sprite, "scale", Vector2.ZERO, 0.6)
	tween.tween_callback(self, "queue_free")


func _on_Cat_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		animation_player.play("meow")
		meow.play()


func _on_BusDiscover_area_entered(area: Area2D) -> void:
	if area.is_in_group("passengerDiscover"):
		move_target = area
	if area.is_in_group("passengerEnter"):
		enter_bus()

func _on_BusDiscover_area_exited(area: Area2D) -> void:
	move_target = null
