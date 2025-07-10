extends Node2D

var actual_stage: Node2D
var menu_stage := load("res://Stages/MenuStage/menu_stage.tscn")
#var game_stage := load("res://Stages/game_stage.tscn")
#var menu_howtoplay_stage := load("res://Stages/menu_howtoplay_stage.tscn")
#var menu_options_stage := load("res://Stages/menu_options_stage.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_stage("menu_stage")



func load_stage(stage_name: String) -> void:
	if actual_stage:
		actual_stage.queue_free()
	
	if stage_name == "menu_stage":
		actual_stage = menu_stage.instantiate()
	
	#TODO
	#if stage_name == "game_stage":
	#	actual_stage = game_stage.instantiate()
	
	#TODO
	#if stage_name == "menu_howtoplay_stage":
	#	actual_stage = menu_howtoplay_stage.instantiate()
	
	#TODO
	#if stage_name == "menu_options_stage":
	#	actual_stage = menu_options_stage.instantiate()
	
	add_child(actual_stage)
