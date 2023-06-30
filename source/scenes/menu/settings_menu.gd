extends Control

onready var pik_sfx = $PikSfx
onready var mute_music_button = $"%MuteMusicButton"
onready var mute_sfx_button = $"%MuteSFXButton"
onready var volume_slider = $"%VolumeSlider"
onready var fullscreen_button = $"%FullscreenButton"



var tween: SceneTreeTween
var _close_guard = false


func _ready():
	$ExitButton.grab_focus()
	tween = create_tween()
	tween.tween_property(self, "modulate", Color(1.0, 1.0, 1.0, 1.0), 0.4) \
		 .from(Color(1.0, 1.0, 1.0, 0.0))

	set_initial()
	register_controls()

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		close_menu()


func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_GO_BACK_REQUEST:
		_on_ExitButton_pressed()
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		_on_ExitButton_pressed()


func set_initial() -> void:
	mute_music_button.set_pressed_no_signal(Settings.get("music_mute"))
	mute_sfx_button.set_pressed_no_signal(Settings.get("sfx_mute"))
	volume_slider.value = db2linear(Settings.get("sound_volume"))
	fullscreen_button.set_pressed_no_signal(Settings.get("fullscreen"))

func register_controls() -> void:
	volume_slider.connect("value_changed", self, "_on_volume_changed")


func close_menu() -> void:
	if _close_guard: return
	_close_guard = true
	
	if tween:
		if tween.is_valid():
			tween.kill()
	
	Settings.save_settings()
	
	tween = create_tween()
	tween.tween_property(self, "modulate", Color(1.0, 1.0, 1.0, 0.0), 0.4)
	tween.tween_callback(Events, "emit_signal", ["menu_overlay_freed"])
	tween.tween_callback(self, "queue_free")


func _on_ExitButton_pressed():
	Settings.save_settings()
	close_menu()


func _on_volume_changed(value) -> void:
	Settings.set("sound_volume", linear2db(value))


func _on_MuteButton_toggled(button_pressed):
	Settings.set("music_mute", button_pressed)


func _on_FullscreenButton_toggled(button_pressed):
	Settings.set("fullscreen", button_pressed)


func _on_MuteSFXButton_toggled(button_pressed):
	Settings.set("sfx_mute", button_pressed)
