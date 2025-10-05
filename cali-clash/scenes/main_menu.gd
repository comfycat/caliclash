extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func on_start_button_pressed() -> void:
	print("Start game pressed")
	# get_tree().change_scene_to_file()

func on_options_button_pressed() -> void:
	print("Options pressed")

func on_credits_button_pressed() -> void:
	print("Credits pressed")
