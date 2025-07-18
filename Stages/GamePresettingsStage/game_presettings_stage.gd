extends Node2D

@onready var play_button: Button = $"TextureRect/PlayButton"
@onready var settings_displayer: VBoxContainer = $"TextureRect/SettingsDisplayer"
@onready var box_settings: ColorRect = $"TextureRect/BoxSettings"

@onready var json_path: String = "res://Utilities/groups.json"
@onready var groups: Dictionary = load_groups()

var is_difficulty_choosen: bool = false
var custom_difficulty: Array = [[],[],[]]
var groups_restrictions: Array = [[0,1,2,3],[0,1,2],[0,1]]

func _ready() -> void:
	box_settings.get_child(0).get_popup().connect("id_pressed", _on_group_menu_selected)

func update_labels(diff_index: int) -> void:
	settings_displayer.get_child(0).text = "Races: " + str(game_manager.difficulty_settings[diff_index][0])
	settings_displayer.get_child(1).text = "Occupations: " + str(game_manager.difficulty_settings[diff_index][1])
	settings_displayer.get_child(2).text = "Areas: " + str(game_manager.difficulty_settings[diff_index][2])
	settings_displayer.get_child(3).text = "Number of enemy candidates: " + str(game_manager.difficulty_settings[diff_index][3])
	settings_displayer.get_child(4).text = "Number of posts: " + str(game_manager.difficulty_settings[diff_index][4])
	play_button.get_child(0).color = Color(0.0, 0.0, 0.0, 0.0)


func _on_play_button_pressed() -> void:
	# Checks if there are groups to chose from
	if is_difficulty_choosen:
		if not game_manager.is_difficulty_custom:
			game_manager.load_stage("game_stage")
		else:
			if (groups_restrictions[0].size() > 0
			and groups_restrictions[1].size() > 0
			and groups_restrictions[2].size() > 0):
				game_manager.groups_restrictions = groups_restrictions
				game_manager.difficulty_settings[4][0] = groups_restrictions[0].size()
				game_manager.difficulty_settings[4][1] = groups_restrictions[1].size()
				game_manager.difficulty_settings[4][2] = groups_restrictions[2].size()
				game_manager.load_stage("game_stage")
			else:
				play_button.get_child(0).color = Color(1.0, 0.0, 0.0, 0.3)
	else:
		play_button.get_child(0).color = Color(1.0, 0.0, 0.0, 0.3)


func _on_tutorial_button_pressed() -> void:
	game_manager.difficulty_index = 0
	update_labels(0)
	settings_displayer.visible = true
	box_settings.visible = false
	game_manager.is_difficulty_custom = false
	is_difficulty_choosen = true


func _on_easy_button_pressed() -> void:
	game_manager.difficulty_index = 1
	update_labels(1)
	settings_displayer.visible = true
	box_settings.visible = false
	game_manager.is_difficulty_custom = false
	is_difficulty_choosen = true


func _on_medium_button_pressed() -> void:
	game_manager.difficulty_index = 2
	update_labels(2)
	settings_displayer.visible = true
	box_settings.visible = false
	game_manager.is_difficulty_custom = false
	is_difficulty_choosen = true


func _on_hard_button_pressed() -> void:
	game_manager.difficulty_index = 3
	update_labels(3)
	settings_displayer.visible = true
	box_settings.visible = false
	game_manager.is_difficulty_custom = false
	is_difficulty_choosen = true


func _on_custom_button_pressed() -> void:
	game_manager.difficulty_index = 4
	settings_displayer.visible = false
	box_settings.visible = true
	_on_group_menu_selected(0)
	game_manager.is_difficulty_custom = true
	is_difficulty_choosen = true


func _on_group_menu_selected(id: int) -> void:
	var group_name: String
	match id:
		0:
			box_settings.get_child(0).text = "Races"
			group_name = "RG"
		1:
			box_settings.get_child(0).text = "Occupations"
			group_name = "WG"
		2:
			box_settings.get_child(0).text = "Areas"
			group_name = "AG"
	
	# Clears checkboxes before spawning new
	for check_box in box_settings.get_child(1).get_children():
		check_box.queue_free()
	# Spawns checkboxes
	for rgw_index in groups[group_name].size():
		var check_box: CheckBox = CheckBox.new()
		box_settings.get_child(1).add_child(check_box)
		check_box.text = groups[group_name][rgw_index]["name_eng"]
		check_box.set_h_size_flags(Control.SIZE_EXPAND_FILL)
		check_box.add_theme_font_size_override("font_size", 24)
		if groups_restrictions[id].has(rgw_index):
			check_box.button_pressed = true
		check_box.toggled.connect(_on_check_box_toggled.bind(group_name, id, rgw_index))

func _on_check_box_toggled(is_button_pressed: bool, group_name: String, group_id: int, rgw_index: int) -> void:
	if is_button_pressed:
		groups_restrictions[group_id].append(rgw_index)
		print("Zaznaczono ID: ", group_name, " ", rgw_index)
	else:
		groups_restrictions[group_id].erase(rgw_index)
		print("Odznaczono ID: ", group_name, " ", rgw_index)

func load_groups() -> Dictionary:
	var file := FileAccess.open(json_path, FileAccess.READ)
	if file:
		var content: String = file.get_as_text()
		var data: Dictionary = JSON.parse_string(content)
		file.close()
		if typeof(data) == TYPE_DICTIONARY:
			return data
		else:
			print("Niepoprawny format JSON")
			return {}
	else:
		print("Nie można otworzyć pliku JSON")
		return {}
