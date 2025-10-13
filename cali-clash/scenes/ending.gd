#res://scenes/ending.gd
extends Control

var dialog_instance: Node = null

func _ready() -> void:
	Dialogic.signal_event.connect(_on_dialogic_signal)
	var tl := GameManager.get_ending_timeline()  # "end_good" | "end_ok" | "end_bad"

	if dialog_instance:
		dialog_instance.queue_free()
		dialog_instance = null

	dialog_instance = Dialogic.start(tl)
	add_child(dialog_instance)
	

func _on_dialogic_signal(name: String) -> void:
	print("received return menu signal")
	if "return_menu":
		Dialogic.end_timeline(true)
		if dialog_instance:
			dialog_instance.queue_free()
			dialog_instance = null
		await get_tree().process_frame
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
