@tool
extends DialogicLayoutLayer

@export var maximum_choices: int = 4
@export_file('*.tscn') var choices_custom_button: String = ""
@export var boxes_fill_width: bool = false
@export var boxes_min_size: Vector2 = Vector2(200, 80)
@export var boxes_offset: Vector2 = Vector2(0, -100)

@export_group("Font")
@export var font_use_global: bool = true
@export_file('*.ttf', '*.tres') var font_custom: String = ""
@export var font_size_custom: int = 18
@export var text_color_custom: Color = Color.WHITE
@export var text_color_hovered: Color = Color(1, 0.8, 0.6)

@export_group("Sounds")
@export_range(-80, 24, 0.01) var sounds_volume: float = -10
@export_file("*.wav", "*.ogg", "*.mp3") var sounds_pressed: String = ""
@export_file("*.wav", "*.ogg", "*.mp3") var sounds_hover: String = ""

func get_choices() -> GridContainer:
	return $MarginContainer/Choices

func get_button_sound() -> DialogicNode_ButtonSound:
	return %DialogicNode_ButtonSound

func _apply_export_overrides() -> void:
	var layer_theme := Theme.new()

	# Font
	if font_use_global and get_global_setting(&"font", false):
		layer_theme.set_font(&"font", &"Button", load(get_global_setting(&"font", "")) as Font)
	elif ResourceLoader.exists(font_custom):
		layer_theme.set_font(&"font", &"Button", load(font_custom) as Font)
	layer_theme.set_font_size(&"font_size", &"Button", font_size_custom)
	layer_theme.set_color(&"font_color", &"Button", text_color_custom)
	layer_theme.set_color(&"font_hover_color", &"Button", text_color_hovered)

	# Position
	position = boxes_offset

	# Replace existing choice buttons
	var choices := get_choices()
	for c in choices.get_children():
		if c is DialogicNode_ChoiceButton:
			c.queue_free()

	var button_scene: PackedScene = null
	if not choices_custom_button.is_empty() and ResourceLoader.exists(choices_custom_button):
		button_scene = load(choices_custom_button) as PackedScene

	for i in range(maximum_choices):
		var btn: DialogicNode_ChoiceButton
		if button_scene:
			btn = button_scene.instantiate()
		else:
			btn = DialogicNode_ChoiceButton.new()

		btn.custom_minimum_size = boxes_min_size
		btn.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
		choices.add_child(btn)

	set(&"theme", layer_theme)

	# Sound setup
	var snd = get_button_sound()
	snd.volume_db = sounds_volume
	if ResourceLoader.exists(sounds_pressed):
		snd.sound_pressed = load(sounds_pressed)
	if ResourceLoader.exists(sounds_hover):
		snd.sound_hover = load(sounds_hover)
