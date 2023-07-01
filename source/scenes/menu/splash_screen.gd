extends Control

var menu_scene = preload("res://source/scenes/menu/menu.tscn")


func _ready() -> void:
	$TransitionRect.show()


func _input(event):
	if event is InputEventKey or \
		event is InputEventJoypadButton or \
		event is InputEventMouseButton:
		go_to_menu()


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "fade_in":
		go_to_menu()


func go_to_menu() -> void:
	get_tree().change_scene_to(menu_scene)
