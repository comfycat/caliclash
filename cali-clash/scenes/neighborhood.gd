#res://scenes/neighborhood.gd
extends Node2D

# map house IDs to paths under Sprite2D Neighborhood
const HOUSE_PATHS := {
#	"tutorial_house": "Neighborhood/TutorialHouse",
	"intimidation_house": "Neighborhood/WitchHouse",
	"knowledge_house": "Neighborhood/MummyHouse",
	"friendliness_house": "Neighborhood/ScarecrowHouse",
	"comedy_house": "Neighborhood/VampireHouse",
	"final_house": "Neighborhood/MonsterHouse",
}

var houses := {}
var selected_house := ""

func _ready() -> void:
	for house_id in HOUSE_PATHS.keys():
		var path: String = HOUSE_PATHS[house_id]
		var area: Area2D = get_node_or_null(path)

		houses[house_id] = area
		area.mouse_entered.connect(func(): _on_house_hover(house_id, true))
		area.mouse_exited.connect(func(): _on_house_hover(house_id, false))
		area.input_event.connect(func(_vp, event, _shape_idx):
			if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
				_start_battle_for(house_id)
		)
	_apply_cleared_and_gatekeeping()


func _on_house_hover(house_id: String, entered: bool) -> void:
	selected_house = house_id if entered else ""
	print(house_id, ", entered?: ", entered)


func _start_battle_for(house_id: String) -> void:
	# prevent replaying non-final cleared houses
	if house_id != "final_house" and house_id in GameManager.houses_cleared:
		return

	# prevent entering final_house unless unlocked
	if house_id == "final_house" and not GameManager.unlocked_final_house:
		print("Final house locked!")
		return

	GameManager.start_battle(house_id)
	get_tree().change_scene_to_file("res://scenes/battle.tscn")


func _apply_cleared_and_gatekeeping() -> void:
	for house_id in houses.keys():
		var area: Area2D = houses[house_id]
		var is_final : bool = house_id == "final_house"
		# lock final house unless unlocked
		if is_final:
			area.input_pickable = GameManager.unlocked_final_house
			continue
		# disable cleared houses
		area.input_pickable = house_id not in GameManager.houses_cleared
