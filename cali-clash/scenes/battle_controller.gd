
# res://scenes/battle_controller.gd
extends Node

@onready var bar: ProgressBar	  = %PersuasionBar
@onready var round_label: Label	= %RoundLabel
@onready var candy_label: Label	= %CandyLabel
@onready var sparkles: Node		= %Sparkles  

var dialog_instance: Node = null

var house_id: String = ""
var rounds: int = 3
var threshold: int = 75
var candy_per_100: int = 10
var no_boosts: bool = false
var friend_reward: String = ""
var timeline: String = "House_Default"

var persuasion: int = 0
var round_num: int = 1

var force_all_sparkles: bool = false	
var _simulated_friend_added: bool = false   

const SPARKLE_MAP := {
	"green-sparkles":  "Knowledge",
	"yellow-sparkles": "Comedy",
	"pink-sparkles":   "Friendliness",
	"blue-sparkles":   "Intimidation",
}
var sparkle_nodes: Dictionary = {}

# ============================== READY ==============================
func _ready() -> void:
	if bar == null or round_label == null or candy_label == null:
		push_error("BattleController: missing UI nodes (check Unique Names).")
		return

	if sparkles:
		_cache_sparkle_nodes()
		_set_all_sparkles(false)

	_load_config()
	_apply_house_overrides() 
	_init_ui()

	Dialogic.signal_event.connect(_on_dialogic_signal)

	if dialog_instance:
		dialog_instance.queue_free()
	dialog_instance = Dialogic.start(timeline)
	add_child(dialog_instance)

# ============================== CONFIG/INIT ==============================
func _load_config() -> void:
	var cfg := GameManager.current_battle_data
	house_id	  = String(cfg.get("house_id", ""))
	rounds		= int(cfg.get("rounds", 3))
	threshold	 = int(cfg.get("threshold", 75))
	candy_per_100 = int(cfg.get("candy_per_100", 10))
	no_boosts	 = bool(cfg.get("no_boosts", false))
	friend_reward = String(cfg.get("friend_reward", ""))
	timeline	  = String(cfg.get("timeline", "House_Default"))

func _apply_house_overrides() -> void:
	if house_id == "tutorial_house":
		force_all_sparkles = true

func _init_ui() -> void:
	persuasion = 0
	round_num = 1
	bar.max_value = 100
	bar.value = 0
	round_label.text = "%d/%d" % [round_num, rounds]
	candy_label.text = str(GameManager.candy)

# ============================== DIALOGIC EVENTS ==============================
func _on_dialogic_signal(name: String) -> void:
	match name:
		"battle_ui":
			if force_all_sparkles:
				_set_all_sparkles(true)
			else:
				_refresh_sparkles_for_boosts()

		"choice_made":
			_set_all_sparkles(false)
			var choice_id: String = String(Dialogic.VAR.get("choice_id"))
			_apply_choice(choice_id)
			
		"ending":
			_end_dialog_and_change_scene("res://scenes/ending.tscn")

		"return_menu":
			_end_dialog_and_change_scene("res://scenes/main_menu.tscn")

		"return_map":
			_end_dialog_and_change_scene("res://scenes/neighborhood.tscn")

			
func _end_dialog_and_change_scene(path: String) -> void:
	Dialogic.end_timeline(true)
	if dialog_instance:
		dialog_instance.queue_free()
		dialog_instance = null
	await get_tree().process_frame
	get_tree().change_scene_to_file(path)


# ============================== ROUND/SCORING ==============================
func _apply_choice(choice_id: String) -> void:
	var delta := _calculate_gain(choice_id, round_num)
	persuasion = clamp(persuasion + delta, 0, 100)

	var tw := create_tween()
	tw.tween_property(bar, "value", persuasion, 0.25)

	Dialogic.VAR.set("reaction_%d" % round_num, "Persuasion +%d!" % delta)

	if round_num >= rounds:
		var end_text := ""
		if persuasion >= threshold and friend_reward != "":
			end_text = "You convinced a friend to join your party."
		else:
			end_text = "You didn’t convince them this time."
		Dialogic.VAR.set("reaction_end", end_text)
		_finalize_battle_and_exit()
	else:
		round_num += 1
		round_label.text = "%d/%d" % [round_num, rounds]
		Dialogic.VAR.set("round_num", round_num)
		
func _finalize_battle_and_exit() -> void:
	if round_num >= rounds:
		Dialogic.VAR.set("outcome", "success" if persuasion >= threshold else "fail")
		Dialogic.emit_signal("signal_event", "battle_outcome")

	var result := GameManager.finalize_battle(persuasion)
	candy_label.text = str(GameManager.candy)
	print("Candy +%d (Total: %d)" % [result.candy_gain, GameManager.candy])

func _calculate_gain(choice_id: String, round_i: int) -> int:
	var house_id := String(GameManager.current_battle_data.get("house_id", "default"))
	var rankings = GameManager.get_dialogue_ranking(house_id, round_i)
	var rank := int(rankings.get(choice_id, 1))

	var base := _rank_to_value(rank)
	var tag := _choice_to_tag(choice_id)
	var boost := 0.0

	var no_boosts := bool(GameManager.current_battle_data.get("no_boosts", false))
	if not no_boosts:
		boost = GameManager.get_total_boost(tag)

	var rounds := int(GameManager.current_battle_data.get("rounds", 3))
	var round_contribution := 100.0 / rounds

	var rank_map = {4: 1.0, 3: 0.75, 2: 0.5, 1: 0.25}
	var rank_factor = rank_map.get(rank, 0.0)

	var delta = round_contribution * rank_factor * (1.0 + boost)
	if house_id == "tutorial_house":
		return 100
	return int(round(clamp(delta, 0, 100 - GameManager.persuasion)))

func _rank_to_value(rank: int) -> int:
	match rank:
		4: return 30
		3: return 20
		2: return 10
		1: return 0
		_: return 0

func _choice_to_tag(choice_id: String) -> String:
	match choice_id:
		"A": return "Knowledge"
		"B": return "Comedy"
		"C": return "Friendliness"
		"D": return "Intimidation"
		_:   return ""
# ============================== SPARKLES (BOOST INDICATORS) ==============================
func _cache_sparkle_nodes() -> void:
	sparkle_nodes.clear()
	if sparkles == null:
		return
	for child_name in SPARKLE_MAP.keys():
		if sparkles.has_node(child_name):
			var node: Node = sparkles.get_node(child_name)
			var stat: String = SPARKLE_MAP[child_name]
			sparkle_nodes[stat] = node
		else:
			push_warning("Sparkles child missing: %s" % child_name)

func _refresh_sparkles_for_boosts() -> void:
	if sparkles == null:
		return
	if no_boosts:
		_set_all_sparkles(false)
		return

	var any_on := false
	for stat in ["Knowledge","Comedy","Friendliness","Intimidation"]:
		var node: Node = sparkle_nodes.get(stat, null)
		if node == null: continue
		var has_boost := GameManager.get_total_boost(stat) > 0.0001
		_toggle_sparkle_node(node, has_boost)
		if has_boost: any_on = true

	if sparkles is CanvasItem:
		(sparkles as CanvasItem).visible = any_on

func _set_all_sparkles(on: bool) -> void:
	if sparkles == null:
		return
	if sparkles is CanvasItem:
		(sparkles as CanvasItem).visible = on
	for node in sparkle_nodes.values():
		_toggle_sparkle_node(node, on)

func _toggle_sparkle_node(node: Node, on: bool) -> void:
	if node is CanvasItem:
		(node as CanvasItem).visible = on

	if node is AnimatedSprite2D:
		var spr := node as AnimatedSprite2D
		if on:
			spr.play()
		else:
			spr.stop()
		return
