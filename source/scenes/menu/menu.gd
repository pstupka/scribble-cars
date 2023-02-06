extends Control

onready var menu_buttons := [
	$MarginContainer/VBoxContainer/VBoxContainer/HBoxContainer/Area1Button,
	$MarginContainer/VBoxContainer/VBoxContainer/HBoxContainer/Area2Button,
	$MarginContainer/VBoxContainer/VBoxContainer/HBoxContainer2/Area3Button,
	$MarginContainer/VBoxContainer/VBoxContainer/HBoxContainer2/Area4Button
]

onready var menu_button_content := [
	preload("res://source/scenes/actors/car_templates/car_template.tscn"),
	preload("res://source/scenes/actors/car_templates/car_template.tscn"),
	preload("res://source/scenes/actors/car_templates/car_template.tscn"),
	preload("res://source/scenes/actors/car_templates/car_template.tscn"),
]


func _ready() -> void:
	for i in range(menu_buttons.size()):
		menu_buttons[i].connect("focus_entered", self, "_on_menu_button_focus_entered",[menu_buttons[i]])
		menu_buttons[i].connect("mouse_entered", self, "_on_menu_button_mouse_entered",[menu_buttons[i]])
		menu_buttons[i].connect("focus_exited", self, "_on_menu_button_focus_exited",[menu_buttons[i]])
		menu_buttons[i].connect("mouse_exited", self, "_on_menu_button_mouse_exited",[menu_buttons[i]])
		menu_buttons[i].connect("pressed", self, "_on_menu_button_pressed",[menu_buttons[i]])
		
		
		
		var button_content = menu_button_content[i].instance()
		menu_buttons[i].add_child(button_content)
		
		button_content.position = Vector2(220,140)
		button_content.scale = Vector2(-0.8, 0.8)
		button_content.get_node("AnimationPivot/Particles2D").emitting = false
		button_content.get_node("ShadowPivot").hide()
		button_content.animation_player.get_animation("move").set_loop(true)
	
	menu_buttons[0].grab_focus()


func start_menu_button_animation(button) -> void:
	if button.get_child_count() == 0: return
	
	var item_to_animate = button.get_child(0)
	if item_to_animate.get_node("AnimationPlayer").is_playing(): return
	
	item_to_animate.get_node("AnimationPivot/Particles2D").emitting = true
	item_to_animate.get_node("AnimationPlayer").play("move")


func stop_menu_button_animation(button) -> void:
	if button.get_child_count() == 0: return
	
	var item_to_animate = button.get_child(0)
	item_to_animate.get_node("AnimationPivot/Particles2D").emitting = false
	item_to_animate.get_node("AnimationPlayer").stop(true)


func _on_menu_button_focus_entered(button) -> void:
	start_menu_button_animation(button)


func _on_menu_button_focus_exited(button) -> void:
	stop_menu_button_animation(button)
	
	
func _on_menu_button_mouse_entered(button) -> void:
	start_menu_button_animation(button)


func _on_menu_button_mouse_exited(button) -> void:
	if button.has_focus(): return

	stop_menu_button_animation(button)


func _on_menu_button_pressed(button) -> void:	
	if not $AnimationPlayer.get_animation_list().has(button.name): return
	$AnimationPlayer.play(button.name)
	button.get_child(0).honk(false)


func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	match anim_name:
		"Area1Button": get_tree().change_scene("res://source/scenes/Main.tscn")
