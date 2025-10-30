extends Control

@onready var start_btn: StaticBody2D			   = %StartButton
@onready var options_btn: StaticBody2D			 = %OptionsButton
@onready var credits_btn: StaticBody2D			 = %CreditsButton
@onready var start_shape: CollisionShape2D			   = %StartShape
@onready var options_shape: CollisionShape2D			 = %OptionsShape
@onready var credits_shape: CollisionShape2D			 = %CreditsShape
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
@onready var music: AudioStreamPlayer = $musicmenu
var dialog_instance: Node = null


func _ready() -> void:
	print("MainMenu ready. hasTree=", get_tree() != null)
	print_tree_pretty()

	start_btn.input_event.connect(_on_start_button_input_event)
	options_btn.input_event.connect(_on_options_button_input_event)
	credits_btn.input_event.connect(_on_credits_button_input_event)

	_wire_btn(start_tutorial_btn, _on_tutorial_button_pressed, "TutorialButton")
	_wire_btn(start_comedy_btn, _on_comedy_button_pressed, "ComedyButton")
	_wire_btn(start_knowledge_btn, _on_knowledge_button_pressed, "KnowledgeButton")
	_wire_btn(start_friendliness_btn, _on_friendliness_button_pressed, "FriendlinessButton")
	_wire_btn(start_intimidation_btn, _on_intimidation_button_pressed, "IntimidationButton")
	_wire_btn(start_final_btn, _on_final_button_pressed, "FinalButton")
	
	start_btn.input_pickable = true
	options_btn.input_pickable = true
	credits_btn.input_pickable = true

	start_shape.disabled = false
	options_shape.disabled = false
	credits_shape.disabled = false
	
	pumpkin_panel.visible =true
	pumpkin_panel2.visible =false
	options.visible = false
	credits.visible = false


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
	
func _on_back_button_pressed() -> void:
	_ready()

func _on_start_button_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		music.stop()
		if dialog_instance:
			dialog_instance.queue_free()
			dialog_instance = null
		dialog_instance = Dialogic.start("introduction")
		add_child(dialog_instance)

func _on_options_button_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		print("Options Clicked")	
		pumpkin_panel2.visible = true
		pumpkin_panel.visible=false
		start_shape.disabled=false
		options_shape.disabled = false
		credits_shape.disabled = false
	
		start_shape.disabled = true
		options_shape.disabled = true
		credits_shape.disabled = true
		options.visible = true


func _on_credits_button_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		print("Options Clicked")	
		pumpkin_panel2.visible = true
		pumpkin_panel.visible = false
		start_shape.disabled = false
		options_shape.disabled = false
		credits_shape.disabled = false
	
		start_shape.disabled = true
		options_shape.disabled = true
		credits_shape.disabled = true
		credits.visible = true
