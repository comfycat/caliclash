#res://scenes/live_cam.gd
extends Control

const FRIEND_DISPLAY := {
	"tuxedo_cat": "TuxedoCat",
	"tabby_cat":  "TabbyCat",
	"black_crow": "BlackCrow",
	"black_cat":  "BlackCat",
	"sphinx_cat": "SphinxCat"
}

@onready var info_panel: Panel = $InfoPanel
@onready var info_label: Label = $InfoPanel/Label

var friend_nodes: Dictionary = {}

func _ready() -> void:
	_cache_friend_nodes()
	#_refresh_friends_visibility()
	_update_bonus_text()
	set_process(true)
	
	var new_font := load("res://assets/fonts/Cardo-Bold.ttf")
	var theme_font := FontVariation.new()
	theme_font.base_font = new_font

	info_label.add_theme_font_override("font", theme_font)
	info_label.add_theme_font_size_override("font_size", 60)



func _process(_delta: float) -> void:
	#_refresh_friends_visibility()
	_update_bonus_text()


func _cache_friend_nodes() -> void:
	friend_nodes.clear()
	for id_str: String in FRIEND_DISPLAY.keys():
		var node_name = FRIEND_DISPLAY[id_str]
		if has_node(node_name):
			var tr := get_node(node_name) as TextureRect
			if tr:
				friend_nodes[id_str] = tr
		else:
			push_warning("LiveCam: Missing TextureRect for '%s' (expected child named %s)" % [id_str, node_name])


#func _refresh_friends_visibility() -> void:
	#for id_str: String in friend_nodes.keys():
		#friend_nodes[id_str].visible = id_str in GameManager.recruited_friends


func _update_bonus_text() -> void:
	if info_label == null:
		return

	var stats := ["Knowledge","Comedy","Friendliness","Intimidation"]
	var lines := []

	for stat in stats:
		var boost := GameManager.get_total_boost(stat)
		var pct := int(round(boost * 100.0))
		lines.append("%s: %d%%" % [stat, pct])

	info_label.text = String("\n").join(lines)

	if info_panel:
		info_panel.visible = true
