#res://scenes/battle_controller.gd
extends Node


@onready var persuasion_bar: ProgressBar = $"../UI/PersuasionBar"
@onready var round_label: Label = $"../UI/RoundLabel"
@onready var candy_label: Label = $"../UI/CandyLabel"

var persuasion_score := 0
var candy_count := 0
var round_counter := 1
var friend_boosts = {  # Dictionary is updated as Friends & their attributes are defined
	"Knowledge": 0.10,
	"Comedy": 0.05,
	"Friendliness": 0.15,
	"Intimidation": 0.0
}
# Each round, options A–D mapped to rank 1–4 (1=worst,4=best)
var dialogue_rankings = {
	1: {"A": 4, "B": 2, "C": 3, "D": 1},  #Round 1
	2: {"A": 1, "B": 4, "C": 3, "D": 2},  #Round 2
	3: {"A": 2, "B": 3, "C": 4, "D": 1}   #Round 3
}

func _ready():
	print("PersuasionBar node:", persuasion_bar)
	print("CandyLabel node:", candy_label)

	persuasion_bar.max_value = 100 #Restarts every Battle Scene
	persuasion_bar.value = 0

	if Dialogic.has_signal("signal_event"):
		Dialogic.signal_event.connect(_on_dialogic_signal)
	else:
		push_error("Dialogic signal_event not found.")


func _on_dialogic_signal(event_name: String):
	if event_name == "choice_made":
		var choice_id = Dialogic.VAR.get_variable("choice_id")
		_on_choice_selected(choice_id)

func rank_to_value(rank: int) -> int:
	match rank:
		4: return 40  #best
		3: return 30
		2: return 20
		1: return 10  #worst
		_: return 0

func _on_choice_selected(choice_id: String) -> void:
	var delta := calculate_persuasion(choice_id, round_counter)
	persuasion_score += delta
	persuasion_bar.value = clamp(persuasion_score, 0, 100)

	var message := "Persuasion bar increased by %d points!" % delta
	_dialogic_set_var("reaction_%d" % round_counter, message)

	if round_counter == 3:
		var end_text := ""
		if persuasion_score >= 75:
			end_text = "You’ve won chocolate’s favor! They join your party."
		else:
			end_text = "You didn’t convince them this time."
		_dialogic_set_var("reaction_end", end_text)
		var candy_gain = int(persuasion_bar.value / 10)
		candy_count += candy_gain
		candy_label.text = "%d" % candy_count
		print("Converted persuasion into ", candy_count, " candies.")
	else:
		round_counter += 1
		round_label.text = "%d/3" % round_counter


	if Dialogic.has_method("end_timeline_event"):
		Dialogic.end_timeline_event()
	elif Dialogic.has_method("emit_signal"):
		Dialogic.emit_signal("event_end")
	else:
		print("Dialogic not continuing, check signal setup")

	
func get_boost_type(choice_id: String) -> String:
	match choice_id:
		"A": return "Knowledge"
		"B": return "Comedy"
		"C": return "Friendliness"
		"D": return "Intimidation"
		_: return ""
func calculate_persuasion(choice_id: String, round_num: int) -> int:
	var round_data = dialogue_rankings.get(round_num, {})
	var rank = round_data.get(choice_id, 1)
	var base = rank_to_value(rank)
	var boost_type = get_boost_type(choice_id)
	
	# sum boosts for all recruited friends whose boost matches this stat
	var total_boost = GameManager.get_total_boost(boost_type)

	return int(base * (1.0 + total_boost))

func _dialogic_set_var(name: String, value: Variant) -> void:
	if Dialogic.VAR.has_method("set_variable"):
		Dialogic.VAR.set_variable(name, value)
