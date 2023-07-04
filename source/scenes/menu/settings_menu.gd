extends Control

onready var pik_sfx = $PikSfx
onready var mute_music_button = $"%MuteMusicButton"
onready var mute_sfx_button = $"%MuteSFXButton"
onready var mute_master_button = $"%MuteMasterButton"
onready var master_volume = $"%MasterSlider"
onready var fullscreen_label = $"%FullscreenLabel"
onready var fullscreen_button = $"%FullscreenButton"
onready var music_slider = $"%MusicSlider"
onready var sfx_slider = $"%SfxSlider"
onready var on_screen_controls_button = $"%OnScreenControlsButton"
onready var vibration_button = $"%VibrationButton"
onready var low_quality_textures_button = $"%LowQualityTexturesButton"


var tween: SceneTreeTween
var _close_guard = false


func _ready():
	$ExitButton.grab_focus()
	tween = create_tween()
	tween.tween_property(self, "modulate", Color(1.0, 1.0, 1.0, 1.0), 0.4) \
		 .from(Color(1.0, 1.0, 1.0, 0.0))

	if OS.get_name() == "Android" or OS.get_name() == "HTML5":
		fullscreen_label.hide()
		fullscreen_button.hide()

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
	mute_master_button.set_pressed_no_signal(Settings.get("master_mute"))
	music_slider.value = db2linear(Settings.get("music_volume"))
	sfx_slider.value = db2linear(Settings.get("sfx_volume"))
	master_volume.value = db2linear(Settings.get("master_volume"))
	fullscreen_button.set_pressed_no_signal(Settings.get("fullscreen"))
	on_screen_controls_button.set_pressed_no_signal(Settings.get("on_screen_controls_visible"))
	vibration_button.set_pressed_no_signal(Settings.get("vibrations_enabled"))
	low_quality_textures_button.set_pressed_no_signal(Settings.get("low_quality_textures"))


func register_controls() -> void:
	mute_music_button.connect("toggled", self, "_on_button_toggled", [mute_music_button])
	mute_master_button.connect("toggled", self, "_on_button_toggled", [mute_master_button])
	mute_sfx_button.connect("toggled", self, "_on_button_toggled", [mute_sfx_button])
	on_screen_controls_button.connect("toggled", self, "_on_button_toggled", [on_screen_controls_button])
	vibration_button.connect("toggled", self, "_on_button_toggled", [vibration_button])
	low_quality_textures_button.connect("toggled", self, "_on_button_toggled", [low_quality_textures_button])
	fullscreen_button.connect("toggled", self, "_on_button_toggled", [fullscreen_button])
	
	master_volume.connect("value_changed", self, "_on_volume_changed", [master_volume])
	music_slider.connect("value_changed", self, "_on_volume_changed", [music_slider])
	sfx_slider.connect("value_changed", self, "_on_volume_changed", [sfx_slider])


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


func _on_volume_changed(value, slider) -> void:
	match slider.name:
		"MusicSlider":
			Settings.set("music_volume", linear2db(value))
		"SfxSlider":
			Settings.set("sfx_volume", linear2db(value))
		"MasterSlider":
			Settings.set("master_volume", linear2db(value))


func _on_button_toggled(pressed, button):
	match button.name:
		"MuteMusicButton":
			Settings.set("music_mute", pressed)
		"MuteSFXButton":
			Settings.set("sfx_mute", pressed)
		"MuteMasterButton":
			Settings.set("master_mute", pressed)
		"FullscreenButton":
			Settings.set("fullscreen", pressed)
		"OnScreenControlsButton":
			Settings.set("on_screen_controls_visible", pressed)
		"VibrationButton":
			Settings.set("vibrations_enabled", pressed)
			if pressed:
				Globals.vibrate()
		"LowQualityTexturesButton":
			Settings.set("low_quality_textures", pressed)
