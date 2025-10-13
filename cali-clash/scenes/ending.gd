extends Control

var dialog_instance: Node = null

func _ready() -> void:
	var tl := GameManager.get_ending_timeline()  # "end_good" | "end_ok" | "end_bad"

	if dialog_instance:
		dialog_instance.queue_free()
		dialog_instance = null

	dialog_instance = Dialogic.start(tl)
	add_child(dialog_instance)
