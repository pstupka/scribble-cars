extends Control

var tween: SceneTreeTween
onready var controls_info_button = $"%ControlsInfoButton"
onready var credits_button = $"%CreditsButton"
onready var credits_label = $"%CreditsLabel"
onready var controls_container = $MarginContainer/VBoxContainer/ControlsContainer
onready var credits_container = $MarginContainer/VBoxContainer/CreditsContainer
onready var controls_pad_container = $MarginContainer/VBoxContainer/ControlsPadContainer
onready var controls_pad_info_button = $"%ControlsPadInfoButton"

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

	credits_container.show()
	controls_container.hide()
	controls_pad_container.hide()
	
	register_buttons()


func _input(event):
	if event.is_action_pressed("ui_cancel"):
		close_menu()


func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_GO_BACK_REQUEST:
		close_menu()
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		close_menu()


func register_buttons() -> void:
	credits_button.connect("pressed", self, "_on_button_pressed", [credits_button])
	controls_info_button.connect("pressed", self, "_on_button_pressed", [controls_info_button])
	controls_pad_info_button.connect("pressed", self, "_on_button_pressed", [controls_pad_info_button])
	$ExitButton.connect("pressed", self, "_on_button_pressed", [$ExitButton])


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


func _on_button_pressed(button) -> void:
	pik_sfx.play()
	
	match button.name:
		"CreditsButton":
			credits_container.show()
			controls_container.hide()
			controls_pad_container.hide()
		"ControlsInfoButton":
			credits_container.hide()
			controls_container.show()
			controls_pad_container.hide()
		"ControlsPadInfoButton":
			credits_container.hide()
			controls_container.hide()
			controls_pad_container.show()
		"ExitButton": 
			close_menu()

