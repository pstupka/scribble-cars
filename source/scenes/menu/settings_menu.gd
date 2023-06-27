extends Control

onready var pik_sfx = $PikSfx

var tween: SceneTreeTween
var _close_guard = false


func _ready():
	$ExitButton.grab_focus()
	tween = create_tween()
	tween.tween_property(self, "modulate", Color(1.0, 1.0, 1.0, 1.0), 0.4) \
		 .from(Color(1.0, 1.0, 1.0, 0.0))

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
	close_menu()
