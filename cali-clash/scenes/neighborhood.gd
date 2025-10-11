extends Node2D

var selected_house

@onready var player_texture = $Neighborhood/PlayerHouse/TextureRect
@onready var witch_texture = $Neighborhood/WitchHouse/TextureRect
@onready var mummy_texture = $Neighborhood/MummyHouse/TextureRect
@onready var scarecrow_texture = $Neighborhood/ScarecrowHouse/TextureRect
@onready var vampire_texture = $Neighborhood/VampireHouse/TextureRect
@onready var monster_texture = $Neighborhood/MonsterHouse/TextureRect

func _on_area_2d_input_event(viewport, event, shape_idx):
		if event is InputEventMouseButton:
			pass



	
func _on_player_house_mouse_entered() -> void:
	selected_house = "player_house"
	player_texture.visible = true
	print(selected_house)	
	pass # Replace with function body.

func _on_player_house_mouse_exited() -> void:
	selected_house = "no_house"
	player_texture.visible = false
	print(selected_house)
	pass # Replace with function body.
	
func _on_player_house_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
			print("player_house clicked!")
	pass # Replace with function body.


func _on_witch_house_mouse_entered() -> void:
	selected_house = "witch_house"
	witch_texture.visible = true
	print(selected_house)
	pass # Replace with function body.

func _on_witch_house_mouse_exited() -> void:
	selected_house = "no_house"
	witch_texture.visible = false
	print(selected_house)
	pass # Replace with function body.

func _on_witch_house_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		print("witch_house clicked!")
	pass # Replace with function body.


func _on_mummy_house_mouse_entered() -> void:
	selected_house = "mummy_house"
	mummy_texture.visible = true
	print(selected_house)
	pass # Replace with function body.

func _on_mummy_house_mouse_exited() -> void:
	selected_house = "no_house"
	mummy_texture.visible = false
	print(selected_house)
	pass # Replace with function body.

func _on_mummy_house_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		print("mummy_house clicked!")
	pass # Replace with function body.


func _on_scarecrow_house_mouse_entered() -> void:
	selected_house = "scarecrow_house"
	scarecrow_texture.visible = true
	print(selected_house)
	pass # Replace with function body.

func _on_scarecrow_house_mouse_exited() -> void:
	selected_house = "no_house"
	scarecrow_texture.visible = false
	print(selected_house)
	pass # Replace with function body.

func _on_scarecrow_house_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		print("scarecrow_house clicked!")
	pass # Replace with function body.


func _on_vampire_house_mouse_entered() -> void:
	selected_house = "vampire_house"
	vampire_texture.visible = true
	print(selected_house)
	pass # Replace with function body.

func _on_vampire_house_mouse_exited() -> void:
	selected_house = "no_house"
	vampire_texture.visible = false
	print(selected_house)
	pass # Replace with function body.

func _on_vampire_house_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		print("vampire_house clicked!")
	pass # Replace with function body.


func _on_monster_house_mouse_entered() -> void:
	selected_house = "monster_house"
	monster_texture.visible = true
	print(selected_house)
	pass # Replace with function body.

func _on_monster_house_mouse_exited() -> void:
	selected_house = "no_house"
	monster_texture.visible = false
	print(selected_house)
	pass # Replace with function body.

func _on_monster_house_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		print("monster_house clicked!")
	pass # Replace with function body.
