extends Control

@onready var start_btn: TextureButton			   = %StartButton
@onready var options_btn: TextureButton			 = %OptionsButton
@onready var credits_btn: TextureButton			 = %CreditsButton
@onready var start_tutorial_btn: Button	  = %TutorialButton
@onready var start_comedy_btn: Button		= %ComedyButton
@onready var start_knowledge_btn: Button	 = %KnowledgeButton
@onready var start_friendliness_btn: Button  = %FriendlinessButton
@onready var start_intimidation_btn: Button  = %IntimidationButton
@onready var start_final_btn: Button		 = %FinalButton

@onready var options: Panel = $Options
@onready var main_buttons: CanvasLayer = $MarginContainer/MainButtons

func _ready() -> void:
	# Quick visibility & input sanity checks
	print("MainMenu ready. hasTree=", get_tree() != null)
	print_tree_pretty()

	# Wire main buttons
	_wire_btn(start_btn, _on_start_button_pressed, "StartButton")
	_wire_btn(options_btn, _on_options_button_pressed, "OptionsButton")
	_wire_btn(credits_btn, _on_credits_button_pressed, "CreditsButton")

	# Wire house launchers
	_wire_btn(start_tutorial_btn, _on_tutorial_button_pressed, "TutorialButton")
	_wire_btn(start_comedy_btn, _on_comedy_button_pressed, "ComedyButton")
	_wire_btn(start_knowledge_btn, _on_knowledge_button_pressed, "KnowledgeButton")
	_wire_btn(start_friendliness_btn, _on_friendliness_button_pressed, "FriendlinessButton")
	_wire_btn(start_intimidation_btn, _on_intimidation_button_pressed, "IntimidationButton")
	_wire_btn(start_final_btn, _on_final_button_pressed, "FinalButton")
	
	main_buttons.visible = true
	options.visible = false


	# Quick visibility & input sanity checks
	print("MainMenu ready. hasTree=", get_tree() != null)
	print_tree_pretty()

func _wire_btn(btn: BaseButton, cb: Callable, name_hint: String) -> void:
	if btn:
		btn.pressed.connect(cb)
	else:
		push_error("MainMenu: missing Unique Name node → " + name_hint)


# ---- House launchers ----

func _on_tutorial_button_pressed() -> void:
	GameManager.start_battle("tutorial_house")
	print("tutorial")
	get_tree().change_scene_to_file("res://scenes/battle.tscn")

func _on_comedy_button_pressed() -> void:
	GameManager.start_battle("comedy_house")
	print("comedy")
	get_tree().change_scene_to_file("res://scenes/battle.tscn")

func _on_knowledge_button_pressed() -> void:
	GameManager.start_battle("knowledge_house")
	get_tree().change_scene_to_file("res://scenes/battle.tscn")

func _on_friendliness_button_pressed() -> void:
	GameManager.start_battle("friendliness_house")
	get_tree().change_scene_to_file("res://scenes/battle.tscn")

func _on_intimidation_button_pressed() -> void:
	GameManager.start_battle("intimidation_house")
	get_tree().change_scene_to_file("res://scenes/battle.tscn")

func _on_final_button_pressed() -> void:
	GameManager.start_battle("final_house")
	get_tree().change_scene_to_file("res://scenes/battle.tscn")
	
func _on_start_button_pressed() -> void:
	print("start pressed")
func _on_options_button_pressed() -> void:
	main_buttons.visible = false
	options.visible = true
	print("options pressed")
func _on_credits_button_pressed() -> void:
	print("credits pressed")

func _on_back_button_pressed() -> void:
	_ready()
