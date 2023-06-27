extends Control

var tween: SceneTreeTween
onready var controls_info_button = $"%ControlsInfoButton"
onready var credits_button = $"%CreditsButton"
onready var credits_label = $"%CreditsLabel"
onready var controls_container = $MarginContainer/VBoxContainer/ControlsContainer
onready var credits_container = $MarginContainer/VBoxContainer/CreditsContainer


onready var pik_sfx = $PikSfx

var _close_guard = false


func _ready():
	yield(get_tree(), "idle_frame")
	credits_button.grab_focus()
	tween = create_tween()
	tween.tween_property(self, "modulate", Color(1.0, 1.0, 1.0, 1.0), 0.4) \
		 .from(Color(1.0, 1.0, 1.0, 0.0))
	
	var scrollbar = credits_label.get_v_scroll() as VScrollBar
	scrollbar.allow_greater = true
	scrollbar.allow_lesser = true
	var tween2 = create_tween()
	
	tween2.set_loops().tween_property(scrollbar, "value", scrollbar.max_value, 15.0).from(-scrollbar.page)


func _input(event):
	if event.is_action_pressed("ui_cancel"):
		close_menu()


func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_GO_BACK_REQUEST:
		_on_ExitButton_pressed()
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		_on_ExitButton_pressed()


func close_menu() -> void:
	if _close_guard: return
	_close_guard = true
	
	if tween:
		if tween.is_valid():
			tween.kill()
	
	tween = create_tween()
	tween.tween_property(self, "modulate", Color(1.0, 1.0, 1.0, 0.0), 0.4)
	tween.tween_callback(Events, "emit_signal", ["menu_overlay_freed"])
	tween.tween_callback(self, "queue_free")


func _on_ExitButton_pressed():
	pik_sfx.play()
	close_menu()


func _on_CreditsButton_pressed():
	pik_sfx.play()
	credits_container.show()
	controls_container.hide()


func _on_ControlsInfoButton_pressed():
	pik_sfx.play()
	credits_container.hide()
	controls_container.show()

