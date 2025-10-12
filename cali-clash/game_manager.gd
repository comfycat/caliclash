
# res://GameManager.gd (autoload)
extends Node

# --- Global state ---
var candy := 0
var recruited_friends: Array[String] = []
var houses_cleared: Array[String] = []
var unlocked_final_house := false

#  current battle
var current_battle_data: Dictionary = {}   # filled by start_battle()

const GOOD_THRESHOLD := 100
const OKAY_THRESHOLD := 40

# Friend library: boosts by tag
var FRIEND_LIBRARY := {
	# tutorial
	"tuxedo_cat": {
		"id": "tuxedo_cat",
		"boosts": {"Knowledge":0.00,"Comedy":0.00,"Friendliness":0.00,"Intimidation":0.00}
	},
	# intimidation/witches
	"black_cat": {
		"id":"black_cat",
		"boosts":{"Knowledge":0.05,"Comedy":0.00,"Friendliness":0.00,"Intimidation":0.10}
	},
	# knowledge/mummy
	"sphinx_cat": {
		"id":"sphinx_cat",
		"boosts":{"Knowledge":0.10,"Comedy":0.00,"Friendliness":0.05,"Intimidation":0.00}
	},
	# friendliness/scarecrow
	"black_crow": {
		"id":"black_crow",
		"boosts":{"Knowledge":0.00,"Comedy":0.05,"Friendliness":0.10,"Intimidation":0.00}
	},
	# comedy/vampire
	"tabby_cat": {
		"id":"tabby_cat",
		"boosts":{"Knowledge":0.00,"Comedy":0.10,"Friendliness":0.00,"Intimidation":0.05}
	}
}

# --- HOUSE REGISTRY ---

var HOUSES := {
	"tutorial_house": {
		"timeline": "tutorial_house",
		"rounds": 1,
		"threshold": 100,
		"candy_per_100": 10,
		"friend_reward": "tuxedo_cat",
		"no_boosts": false
	},
	# mummy/knowledge, sphinx_cat
	"knowledge_house": {
		"timeline": "knowledge_house",
		"rounds": 3,
		"threshold": 75,
		"candy_per_100": 15,
		"friend_reward": "sphinx_cat",
		"no_boosts": false
	},
	# witches/intimidation, black_cat
	"intimidation_house": {
		"timeline": "intimidation_house",
		"rounds": 3,
		"threshold": 80,
		"candy_per_100": 17,
		"friend_reward": "black_cat",
		"no_boosts": false
	},
	# scarecrow/friendliness , black_crow
	"friendliness_house": {
		"timeline": "friendliness_house",
		"rounds": 3,
		"threshold": 65,
		"candy_per_100": 12,
		"friend_reward": "black_crow",
		"no_boosts": false
	},
	# vampire/comedy , tabby_cat
	"comedy_house": {
		"timeline": "comedy_house",
		"rounds": 3,
		"threshold": 80,
		"candy_per_100": 17,
		"friend_reward": "tabby_cat",
		"no_boosts": false
	},
	"final_house": {
		"timeline": "final_house",
		"rounds": 4,
		"threshold": 0,
		"candy_per_100": 25,
		"friend_reward": "",
		"no_boosts": true
	}
}

### -- Dialogue Ranking ----
var dialogue_rankings_by_house := {
	"tutorial_house": {
		1: {"A": 4, "B": 3, "C": 2, "D": 1}
	},
	"comedy_house": {
		1: {"A": 2, "B": 4, "C": 1, "D": 3},
		2: {"A": 4, "B": 1, "C": 2, "D": 3},
		3: {"A": 3, "B": 2, "C": 1, "D": 4}
	},
	"final_house": {
		1: {"A": 2, "B": 1, "C": 4, "D": 3},
		4: {"A": 3, "B": 4, "C": 1, "D": 2}
	},
	"default": {
		1: {"A": 4, "B": 2, "C": 3, "D": 1},
		2: {"A": 1, "B": 4, "C": 3, "D": 2},
		3: {"A": 2, "B": 3, "C": 4, "D": 1},
	}
}

func get_dialogue_ranking(house_id: String, round_i: int) -> Dictionary:
	var house_rankings = dialogue_rankings_by_house.get(house_id, dialogue_rankings_by_house["default"])
	return house_rankings.get(round_i, {})

func start_battle(house_id: String) -> void:
	var cfg: Dictionary = HOUSES.get(house_id, {})
	if cfg == null:
		push_error("Unknown house_id: %s" % house_id)
		return
#pass into battle scene
	current_battle_data = {
		"house_id": house_id,
		"timeline": String(cfg.timeline),
		"rounds": int(cfg.rounds),
		"threshold": int(cfg.threshold),
		"candy_per_100": int(cfg.candy_per_100),
		"friend_reward": String(cfg.friend_reward),
		"no_boosts": bool(cfg.no_boosts),
	}

func finalize_battle(persuasion_total: int) -> Dictionary:
	#Converts persuasion to candy, Recruits friend if threshold met,
	#Marks house cleared, Unlocks final house, -> returns a summary.
	var cfg := current_battle_data
	var house_id := String(cfg.get("house_id",""))
	var candy_gain := int(round(persuasion_total * int(cfg.candy_per_100) / 100.0))
	candy += candy_gain

	var success := persuasion_total >= int(cfg.threshold)
	var recruited := ""
	if success:
		var reward := String(cfg.get("friend_reward",""))
		if reward != "":
			recruit_friend(reward)
			recruited = reward

	if house_id != "" and house_id != "final_house":
		register_house_cleared(house_id)

	return {
		"success": success,
		"candy_gain": candy_gain,
		"recruited_friend": recruited,
		"total_candy": candy
	}

func register_house_cleared(house_id: String) -> void:
	if house_id != "" and house_id not in houses_cleared:
		houses_cleared.append(house_id)
		if houses_cleared.size() >= 4:
			unlocked_final_house = true

func recruit_friend(friend_id: String) -> void:
	if friend_id == "" or friend_id not in FRIEND_LIBRARY:
		push_warning("Unknown friend id: %s" % friend_id)
		return

	if friend_id in recruited_friends:
		print("%s already recruited." % friend_id)
		return

	print("Recruited: %s" % friend_id)
	recruited_friends.append(friend_id)

func get_total_boost(stat: String) -> float:
	var total := 0.0
	for f_id in recruited_friends:
		var f = FRIEND_LIBRARY.get(f_id)
		if f:
			total += float(f.boosts.get(stat, 0.0))
	return total

func get_ending() -> String:
	if candy >= GOOD_THRESHOLD: return "good"
	if candy >= OKAY_THRESHOLD: return "okay"
	return "bad"

func reset_for_new_run() -> void:
	candy = 0
	recruited_friends.clear()
	houses_cleared.clear()
	unlocked_final_house = false
	current_battle_data.clear()
