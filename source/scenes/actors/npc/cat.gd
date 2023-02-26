extends Area2D


onready var meow: AudioStreamPlayer2D = $Meow
onready var animation_player: AnimationPlayer = $AnimationPlayer
onready var sprite: Sprite = $AnimationPivot/Sprite


func _ready() -> void:
	randomize()
	var cat_no = randi() % 3 + 1
	sprite.texture = load("res://assets/sprites/npc/cat%d.png" % cat_no)



func _on_Cat_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		animation_player.play("meow")
