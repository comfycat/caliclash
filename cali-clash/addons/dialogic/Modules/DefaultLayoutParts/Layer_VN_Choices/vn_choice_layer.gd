@tool
extends DialogicLayoutLayer

## A layer that allows showing up to 10 choices.
## Choices are positioned in a 2x2 grid near the bottom.

@export_group("Text")
@export_subgroup("Font")
@export var font_use_global: bool = true
@export_file("*.ttf", "*.tres") var font_custom: String = ""
@export_subgroup("Size")
@export var font_size_use_global: bool = true
@export var font_size_custom: int = 16
@export_subgroup("Color")
@export var text_color_use_global: bool = true
@export var text_color_custom: Color = Color.WHITE
@export var text_color_pressed: Color = Color.WHITE
@export var text_color_hovered: Color = Color.GRAY
@export var text_color_disabled: Color = Color.DARK_GRAY
@export var text_color_focused: Color = Color.WHITE

@export_group("Boxes")
@export_subgroup("Panels")
@export_file("*.tres") var boxes_stylebox_normal: String = "res://addons/dialogic/Modules/DefaultLayoutParts/Layer_VN_Choices/choice_panel_normal.tres"
@export_file("*.tres") var boxes_stylebox_hovered: String = "res://addons/dialogic/Modules/DefaultLayoutParts/Layer_VN_Choices/choice_panel_hover.tres"
@export_file("*.tres") var boxes_stylebox_pressed: String = ""
@export_file("*.tres") var boxes_stylebox_disabled: String = ""
@export_file("*.tres") var boxes_stylebox_focused: String = "res://addons/dialogic/Modules/DefaultLayoutParts/Layer_VN_Choices/choice_panel_focus.tres"

@export_subgroup("Size & Position")
@export var boxes_v_separation: int = 10
@export var boxes_fill_width: bool = true
@export var boxes_min_size: Vector2 = Vector2()
@export var boxes_offset: Vector2 = Vector2(0, -100)

@export_group("Sounds")
@export_range(-80, 24, 0.01) var sounds_volume: float = -10
@export_file("*.wav", "*.ogg", "*.mp3") var sounds_pressed: String = "res://addons/dialogic/Example Assets/sound-effects/typing1.wav"
@export_file("*.wav", "*.ogg", "*.mp3") var sounds_hover: String = "res://addons/dialogic/Example Assets/sound-effects/typing2.wav"
@export_file("*.wav", "*.ogg", "*.mp3") var sounds_focus: String = "res://addons/dialogic/Example Assets/sound-effects/typing4.wav"

@export_group("Choices")
@export var maximum_choices: int = 4
@export_file("*.tscn") var choices_custom_button: String = ""

# --- SAFER ACCESSORS ---
func get_choices() -> GridContainer:
	# Guard to avoid null references
	if has_node("MarginContainer/Choices"):
		return $MarginContainer/Choices
	return null

func get_button_sound() -> DialogicNode_ButtonSound:
	if has_node("%DialogicNode_ButtonSound"):
		return %DialogicNode_ButtonSound
	return null


func _apply_export_overrides() -> void:
	await_ready()  # ensures scene tree is fully ready in-editor too

	var choices := get_choices()
	if choices == null:
		push_warning("Choices node not found! Make sure your path is MarginContainer/Choices.")
		return

	# THEME SETUP
	var layer_theme := Theme.new()

	# --- FONT SETTINGS ---
	if font_use_global and get_global_setting(&"font", false):
		layer_theme.set_font(&"font", &"Button", load(get_global_setting(&"font", "")) as Font)
	elif ResourceLoader.exists(font_custom):
		layer_theme.set_font(&"font", &"Button", load(font_custom) as Font)

	if font_size_use_global:
		layer_theme.set_font_size(&"font_size", &"Button", get_global_setting(&"font_size", font_size_custom))
	else:
		layer_theme.set_font_size(&"font_size", &"Button", font_size_custom)

	if text_color_use_global:
		layer_theme.set_color(&"font_color", &"Button", get_global_setting(&"font_color", text_color_custom))
	else:
		layer_theme.set_color(&"font_color", &"Button", text_color_custom)

	layer_theme.set_color(&"font_pressed_color", &"Button", text_color_pressed)
	layer_theme.set_color(&"font_hover_color", &"Button", text_color_hovered)
	layer_theme.set_color(&"font_disabled_color", &"Button", text_color_disabled)
	layer_theme.set_color(&"font_focus_color", &"Button", text_color_focused)

	# --- BOX STYLE ---
	if ResourceLoader.exists(boxes_stylebox_normal):
		var sbox := load(boxes_stylebox_normal)
		for state in [&"normal", &"hover", &"pressed", &"disabled", &"focus"]:
			layer_theme.set_stylebox(state, &"Button", sbox)

	if ResourceLoader.exists(boxes_stylebox_hovered):
		layer_theme.set_stylebox(&"hover", &"Button", load(boxes_stylebox_hovered))

	if ResourceLoader.exists(boxes_stylebox_focused):
		layer_theme.set_stylebox(&"focus", &"Button", load(boxes_stylebox_focused))

	# --- GRID SETTINGS ---
	choices.add_theme_constant_override(&"v_separation", boxes_v_separation)
	self.position = boxes_offset

	# --- REBUILD BUTTONS ---
	for child in choices.get_children():
		if child is DialogicNode_ChoiceButton:
			child.queue_free()

	var button_scene: PackedScene = null
	if choices_custom_button != "" and ResourceLoader.exists(choices_custom_button):
		button_scene = load(choices_custom_button) as PackedScene

	for i in range(maximum_choices):
		var btn: DialogicNode_ChoiceButton = button_scene.instantiate() if button_scene else DialogicNode_ChoiceButton.new()
		btn.custom_minimum_size = boxes_min_size
		btn.size_flags_horizontal = Control.SIZE_FILL if boxes_fill_width else Control.SIZE_SHRINK_CENTER
		choices.add_child(btn)

	set(&"theme", layer_theme)

	# --- SOUND SETTINGS ---
	var snd := get_button_sound()
	if snd:
		snd.volume_db = sounds_volume
		if ResourceLoader.exists(sounds_pressed):
			snd.sound_pressed = load(sounds_pressed)
		if ResourceLoader.exists(sounds_hover):
			snd.sound_hover = load(sounds_hover)
		if ResourceLoader.exists(sounds_focus):
			snd.sound_focus = load(sounds_focus)
