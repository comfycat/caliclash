extends CheckButton

var prev_mode := Window.MODE_WINDOWED

func _on_toggled(toggled_on: bool) -> void:
	print("toggled")

	var win := get_window()
	if win == null:
		print("No window found!")
		return

	if toggled_on:
		prev_mode = win.mode
		win.mode = Window.MODE_FULLSCREEN
	else:
		win.mode = Window.MODE_WINDOWED
