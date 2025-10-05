extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Dialogic.signal_event.connect(_on_dialogic_signal)
	Dialogic.start('tutorial')

func _on_dialogic_signal(argument:String):
	if argument == "chocolate_happy":
		print("chocolate happy :)")
	elif argument == "chocolate_sad":
		print("chocolate sad :(")
