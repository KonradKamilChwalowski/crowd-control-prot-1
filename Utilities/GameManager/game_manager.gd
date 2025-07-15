extends Node2D

var difficulty_index: int
var is_difficulty_custom = false
var groups_restrictions: Array = [[],[],[]]
var difficulty_settings: Array = [
	[3, 3, 1, 1, 6],
	[4, 5, 3, 2, 9],
	[4, 6, 4, 3, 12],
	[6, 8, 6, 4, 15],
	[12, 13, 14, 4, 15]]

func _ready() -> void:
	pass

func load_stage(stage_name: String) -> void:	
	if stage_name == "menu_stage":
		get_tree().change_scene_to_file("res://Stages/MenuStage/menu_stage.tscn")
	
	if stage_name == "game_presetting_stage":
		get_tree().change_scene_to_file("res://Stages/GamePresettingsStage/game_presettings_stage.tscn")
		
	if stage_name == "game_stage":
		get_tree().change_scene_to_file("res://Stages/GameStage/game_stage.tscn")
	
	#TODO
	#if stage_name == "menu_howtoplay_stage":
	#	actual_stage = menu_howtoplay_stage.instantiate()
	
	#TODO
	#if stage_name == "menu_options_stage":
	#	actual_stage = menu_options_stage.instantiate()
