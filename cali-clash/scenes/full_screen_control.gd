extends CheckButton

var prev_mode := Window.MODE_WINDOWED

func _on_toggled(toggled_on: bool) -> void:
	print("toggled")
	if (toggled_on == true):
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else: 
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
