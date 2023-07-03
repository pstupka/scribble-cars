extends Node

signal setting_changed(setting, value)

var settings_file = "user://settings.bin"


var settings_dict = {
	"sfx_mute": false,
	"music_mute": false,
	"music_volume": -10,
	"sfx_volume": -3,
	"master_volume": -6,
	"master_mute": false,
	"fullscreen": false,
	"on_screen_controls_visible": false,
	"vibrations_enabled": true,
	"low_quality_textures": false,
}

func _ready():
	load_settings()
	
	for key in settings_dict.keys():
		set(key, settings_dict[key])


func get(key):
	if not settings_dict.has(key):
		return
	return settings_dict[key]


func set(key, value):
	if not settings_dict.has(key): 
		return
	
	settings_dict[key] = value
	match key:
		"master_mute":
			AudioServer.set_bus_mute(0, settings_dict[key])
		"music_mute":
			AudioServer.set_bus_mute(1, settings_dict[key])
		"sfx_mute":
			AudioServer.set_bus_mute(2, settings_dict[key])
		"master_volume":
			AudioServer.set_bus_volume_db(0, settings_dict[key])
		"music_volume":
			AudioServer.set_bus_volume_db(1, settings_dict[key])
		"sfx_volume":
			AudioServer.set_bus_volume_db(2, settings_dict[key])
		"fullscreen":
			OS.window_fullscreen = settings_dict[key]
		"low_quality_textures":
			VisualServer.texture_set_shrink_all_x2_on_set_data(settings_dict[key])
	emit_signal("setting_changed", key, settings_dict[key])


func load_settings() -> void:
	var f = File.new()
	if f.file_exists(settings_file):
		f.open_encrypted_with_pass(settings_file, File.READ, OS.get_unique_id())
		for key in settings_dict.keys():
			set(key, f.get_var())
			print(key + ": " + str(settings_dict[key]) + " loaded")
		f.close()
	else: 
		if OS.get_name() == "Android" or OS.get_name() == "HTML5": 
			set("on_screen_controls_visible", true)
		save_settings()


func save_settings() -> void:
	var f = File.new()
	f.open_encrypted_with_pass(settings_file, File.WRITE, OS.get_unique_id())
	for key in settings_dict.keys():
		f.store_var(settings_dict[key])
		print(key + ": " + str(settings_dict[key]) + " stored")
	f.close()
