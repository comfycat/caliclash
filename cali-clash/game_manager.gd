# res://GameManager.gd
extends Node

# Global state
var candy: int = 0
var recruited_friends: Array = []
var houses_cleared: Array = []
var unlocked_final_house: bool = false

var current_battle_data: Dictionary = {}

# Ending based on candies
const GOOD_THRESHOLD: int = 100
const OKAY_THRESHOLD: int = 40

func reset_for_new_run() -> void:
	candy = 0
	recruited_friends.clear()
	houses_cleared.clear()
	unlocked_final_house = false
	current_battle_data.clear()

func register_house_cleared(house_id: String) -> void:
	if house_id == "":
		return
	if house_id in houses_cleared:
		return
	houses_cleared.append(house_id)
	if houses_cleared.size() >= 4:
		unlocked_final_house = true

func recruit_friend(friend_id: String) -> void:
	if friend_id == "":
		return
	if friend_id in recruited_friends:
		return
	recruited_friends.append(friend_id)
	
func get_total_boost(stat: String) -> float:
	var total = 0.0
	for friend_id in recruited_friends:
		if friend_id in FRIEND_LIBRARY:
			total += FRIEND_LIBRARY[friend_id].boosts.get(stat, 0.0)
	return total

func get_ending() -> String:
	if candy >= GOOD_THRESHOLD:
		return "good"
	elif candy >= OKAY_THRESHOLD:
		return "okay"
	else:
		return "bad"
		
var FRIEND_LIBRARY: Dictionary = {
	"witch": { 
		"id": "witch", 
		"boosts": { 
			"Knowledge": 0.10, "Comedy": 0.0, "Friendliness": 0.00, "Intimidation": 0.05 } 
		},
	"mummy": {
		"id": "mummy", 
		"boosts": {"Knowledge":0.05,"Comedy":0.00,"Friendliness":0.10,"Intimidation":0.0} 
		},
	"scarecrow": { 
		 "id": "scarecrow", 
		"boosts": {"Knowledge":0.0,"Comedy":0.10,"Friendliness":0.05,"Intimidation":0.0} 
		},
	"vampire": { 
		"id": "vampire", 
		"boosts": {"Knowledge":0.0,"Comedy":0.05,"Friendliness":0.0,"Intimidation":0.10} 
		}
}

# temp testing set up
func _ready(): # remove later
	recruited_friends = ["witch", "vampire"]
	print("Testing recruited friends:", recruited_friends)
	print("Expected overlap: Intimidation boost should combine from both witch+vampire.")
