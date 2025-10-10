extends Control

@onready var start_btn: Button			   = %StartButton
@onready var options_btn: Button			 = %OptionsButton
@onready var credits_btn: Button			 = %CreditsButton
@onready var start_tutorial_btn: Button	  = %TutorialButton
@onready var start_comedy_btn: Button		= %ComedyButton
@onready var start_knowledge_btn: Button	 = %KnowledgeButton
@onready var start_friendliness_btn: Button  = %FriendlinessButton
@onready var start_intimidation_btn: Button  = %IntimidationButton
@onready var start_final_btn: Button		 = %FinalButton

func _ready() -> void:
	# Wire everything (with guards so it won't crash if a node is missing)
	_wire_btn(start_btn, _on_start_pressed, "StartButton")
	_wire_btn(options_btn, _on_options_pressed, "OptionsButton")
	_wire_btn(credits_btn, _on_credits_pressed, "CreditsButton")

	_wire_btn(start_tutorial_btn, _on_start_tutorial_house, "TutorialButton")
	_wire_btn(start_comedy_btn, _on_start_comedy_house, "ComedyButton")
	_wire_btn(start_knowledge_btn, _on_start_knowledge_house, "KnowledgeButton")
	_wire_btn(start_friendliness_btn, _on_start_friendliness_house, "FriendlinessButton")
	_wire_btn(start_intimidation_btn, _on_start_intimidation_house, "IntimidationButton")
	_wire_btn(start_final_btn, _on_start_final_house, "FinalButton")

	# Quick visibility & input sanity checks
	print("MainMenu ready. hasTree=", get_tree() != null)
	print_tree_pretty()

func _wire_btn(btn: Button, cb: Callable, name_hint: String) -> void:
	if btn:
		btn.pressed.connect(cb)
	else:
		push_error("MainMenu: missing Unique Name node → " + name_hint)

# ---- House launchers ----
func _on_start_tutorial_house() -> void:
	GameManager.start_battle("tutorial_house")
	get_tree().change_scene_to_file("res://scenes/battle.tscn")

func _on_start_comedy_house() -> void:
	GameManager.start_battle("comedy_house")
	get_tree().change_scene_to_file("res://scenes/battle.tscn")

func _on_start_knowledge_house() -> void:
	GameManager.start_battle("knowledge_house")
	get_tree().change_scene_to_file("res://scenes/battle.tscn")

func _on_start_friendliness_house() -> void:
	GameManager.start_battle("friendliness_house")
	get_tree().change_scene_to_file("res://scenes/battle.tscn")

func _on_start_intimidation_house() -> void:
	GameManager.start_battle("intimidation_house")
	get_tree().change_scene_to_file("res://scenes/battle.tscn")

func _on_start_final_house() -> void:
	GameManager.start_battle("final_house")
	get_tree().change_scene_to_file("res://scenes/battle.tscn")

# ---- Top row buttons ----
func _on_start_pressed() -> void:
	print("start pressed")

func _on_options_pressed() -> void:
	print("Options pressed")

func _on_credits_pressed() -> void:
	print("Credits pressed")
