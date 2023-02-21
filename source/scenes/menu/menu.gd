extends Control

onready var menu_buttons := [
	$"%Area1Button",
	$"%Area2Button",
	$"%Area3Button",
	$"%Area4Button"
]

onready var menu_button_content := [
	preload("res://source/scenes/actors/car_templates/car_template.tscn"),
	preload("res://source/scenes/actors/car_templates/car3.tscn")
]

onready var animation_player: AnimationPlayer = $AnimationPlayer
onready var title_label: RichTextLabel = $"%TitleLabel"
onready var start_button: Button = $"%StartButton"
onready var settings_button: Button = $"%SettingsButton"
onready var quit_button: Button = $"%QuitButton"
onready var main_menu_buttons: CanvasLayer = $"%MainMenuButtons"
onready var area_choose: CanvasLayer = $"%AreaChoose"


export(Color) var button_tint := Color("edc8c4")

func _ready() -> void:
	randomize()
	for i in range(menu_buttons.size()):
		_connect_menu_button(menu_buttons[i])
		
		if menu_buttons[i].disabled: continue
		var button_content = menu_button_content[i].instance()
		menu_buttons[i].add_child(button_content)
		
		button_content.position = Vector2(210,130)
		button_content.scale = Vector2(-0.7, 0.7)
		button_content.get_node("AnimationPivot/Particles2D").emitting = false
		button_content.get_node("ShadowPivot").hide()
		button_content.set_animation_loop("move", true)
	
#	menu_buttons[0].grab_focus()
	

func _connect_menu_button(button: Button) -> void:
	button.connect("focus_entered", self, "_on_menu_button_focus_entered",[button])
	button.connect("mouse_entered", self, "_on_menu_button_mouse_entered",[button])
	button.connect("focus_exited", self, "_on_menu_button_focus_exited",[button])
	button.connect("mouse_exited", self, "_on_menu_button_mouse_exited",[button])
	button.connect("pressed", self, "_on_menu_button_pressed",[button])


func start_menu_button_animation(button = null) -> void:
	$PikSfx.play()
	if button == null: return
	button.modulate = button_tint
	if button.get_child_count() == 0 or button.disabled: return
	
	var item_to_animate = button.get_child(0)
	if item_to_animate.get_node("AnimationPlayer").is_playing(): return
	
	item_to_animate.get_node("AnimationPivot/Particles2D").emitting = true
	item_to_animate.get_node("AnimationPlayer").play("move")


func stop_menu_button_animation(button) -> void:
	button.modulate = Color("ffffff")
	if button.get_child_count() == 0: return
	
	var item_to_animate = button.get_child(0)
	item_to_animate.get_node("AnimationPivot/Particles2D").emitting = false
	item_to_animate.get_node("AnimationPlayer").stop(false)


func _on_menu_button_focus_entered(button = null) -> void:
	start_menu_button_animation(button)


func _on_menu_button_focus_exited(button) -> void:
	stop_menu_button_animation(button)


func _on_menu_button_mouse_entered(button = null) -> void:
	start_menu_button_animation(button)


func _on_menu_button_mouse_exited(button) -> void:
	if button.has_focus(): return

	stop_menu_button_animation(button)


func _on_menu_button_pressed(button) -> void:
	if not animation_player.get_animation_list().has(button.name): return
	if animation_player.is_playing(): return
	animation_player.play(button.name)
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	tween.tween_property(button.get_child(0), "global_position:y", 800.0, 1.0)
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.parallel().tween_property(button.get_child(0), "global_position:x", 512.0, 1.0)
	tween.parallel().tween_property(button.get_child(0), "scale:x", 0.8, 0.2)
	
	button.get_child(0).honk(false)
	
	for button in menu_buttons:
		if button.is_connected("focus_entered", self, "_on_menu_button_focus_entered"):
			button.disconnect("focus_entered", self, "_on_menu_button_focus_entered")
		if button.is_connected("mouse_entered", self, "_on_menu_button_mouse_entered"):
			button.disconnect("mouse_entered", self, "_on_menu_button_mouse_entered")


func _on_AnimationPlayer_animation_finished(anim_name: String):
	match anim_name:
		"Area1Button": return get_tree().change_scene("res://source/scenes/Main.tscn")
		"Area2Button": return get_tree().change_scene("res://source/scenes/levels/city.tscn")


func _on_StartButton_pressed() -> void:
	$PikSfx.play()
	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(main_menu_buttons, "offset:x", 1000.0, 0.5)
	tween.tween_property(area_choose, "offset:x", 0.0, 0.5)


func _on_SettingsButton_pressed() -> void:
	if $"%SettingsButton".disabled: return

	$PikSfx.play()


func _on_QuitButton_pressed() -> void:
	get_tree().quit()


func _on_CreditsButton_pressed() -> void:
	if $"%SettingsButton".disabled: return
	$PikSfx.play()