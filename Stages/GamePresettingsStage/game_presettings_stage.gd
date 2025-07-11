extends Node2D

@onready var play_button: Button = $"TextureRect/PlayButton"
@onready var races_label: Label = $"TextureRect/Container/RacesLabel"
@onready var work_label: Label = $"TextureRect/Container/WorkLabel"
@onready var area_label: Label = $"TextureRect/Container/AreaLabel"
@onready var other_candidates_label: Label = $"TextureRect/Container/OtherCandidatesLabel"
@onready var post_number_label: Label = $"TextureRect/Container/PostsNumberLabel"

var is_difficulty_choosen: bool = false

func update_labels(diff_index: int) -> void:
	races_label.text = "Races: " + str(game_manager.difficulty_settings[diff_index][0])
	work_label.text = "Occupations: " + str(game_manager.difficulty_settings[diff_index][1])
	area_label.text = "Areas: " + str(game_manager.difficulty_settings[diff_index][2])
	other_candidates_label.text = "Number of enemy candidates: " + str(game_manager.difficulty_settings[diff_index][3])
	post_number_label.text = "Number of posts: " + str(game_manager.difficulty_settings[diff_index][4])
	play_button.get_child(0).color = Color(0.0, 0.0, 0.0, 0.0)


func _on_play_button_pressed() -> void:
	if is_difficulty_choosen:
		game_manager.load_stage("game_stage")
	else:
		play_button.get_child(0).color = Color(1.0, 0.0, 0.0, 0.3)


func _on_tutorial_button_pressed() -> void:
	game_manager.difficulty_index = 0
	update_labels(0)
	is_difficulty_choosen = true


func _on_easy_button_pressed() -> void:
	game_manager.difficulty_index = 1
	update_labels(1)
	is_difficulty_choosen = true


func _on_medium_button_pressed() -> void:
	game_manager.difficulty_index = 2
	update_labels(2)
	is_difficulty_choosen = true


func _on_hard_button_pressed() -> void:
	game_manager.difficulty_index = 3
	update_labels(3)
	is_difficulty_choosen = true


func _on_custom_button_pressed() -> void:
	pass
	#game_manager.difficulty_index = 4
	#is_difficulty_choosen = true
