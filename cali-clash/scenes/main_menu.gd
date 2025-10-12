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
@onready var pumpkin_panel: Panel			= %PumpkinPanel
@onready var pumpkin_panel2:Panel			= %PumpkinPanel2
@onready var options: Panel = $Options
@onready var credits: Panel = $Credits

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
	
	pumpkin_panel.visible =true
	pumpkin_panel2.visible =false
	
	start_btn.disabled = false
	options_btn.disabled = false
	credits_btn.disabled = false
	
	start_btn.visible = true
	options_btn.visible = true
	credits_btn.visible = true
	
	options.visible = false
	credits.visible = false



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
	Dialogic.start("introduction")
func _on_options_button_pressed() -> void:
	pumpkin_panel2.visible = true
	pumpkin_panel.visible=false
	start_btn.visible = false
	options_btn.visible = false
	credits_btn.visible = false
	
	start_btn.disabled = true
	options_btn.disabled = true
	credits_btn.disabled = true
	options.visible = true
	print("options pressed")
func _on_credits_button_pressed() -> void:
	pumpkin_panel2.visible = true
	pumpkin_panel.visible = false
	start_btn.visible = false
	options_btn.visible = false
	credits_btn.visible = false
	
	start_btn.disabled = true
	options_btn.disabled = true
	credits_btn.disabled = true
	credits.visible = true
func _on_back_button_pressed() -> void:
	_ready()
