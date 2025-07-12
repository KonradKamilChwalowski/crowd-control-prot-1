extends Node2D

@onready var population_manager: Node2D = $PopulationManager
@onready var support_label: Label = $Background/SupportTable/SupportLabel
@onready var candidate_label: Label = $Background/SupportTable/CandidateLabel
@onready var races_container: ScrollContainer = $Background/SupportTable/RacesScrollContainer
@onready var works_container: ScrollContainer = $Background/SupportTable/WorksScrollContainer
@onready var areas_container: ScrollContainer = $Background/SupportTable/AreasScrollContainer
@onready var support_bar := load("res://Entities/support_bar/support_bar.tscn")

var support_counter: int = -1
var candidate_counter: int = -1

func _ready() -> void:
	instantiate_support_bars()
	_on_supp_switch_button_pressed()
	_on_cand_switch_button_pressed()


func instantiate_support_bars() -> void:
	for race_counter in game_manager.difficulty_settings[game_manager.difficulty_index][0]:
		var t_bar = support_bar.instantiate()
		races_container.get_child(0).add_child(t_bar)
		t_bar.name_bar(population_manager.groups["RG"][race_counter]["name_eng"])
		t_bar.change_icon(population_manager.groups["RG"][race_counter]["id"])
	for work_counter in game_manager.difficulty_settings[game_manager.difficulty_index][1]:
		var t_bar = support_bar.instantiate()
		works_container.get_child(0).add_child(t_bar)
		t_bar.name_bar(population_manager.groups["WG"][work_counter]["name_eng"])
		t_bar.change_icon(population_manager.groups["WG"][work_counter]["id"])
	for area_counter in game_manager.difficulty_settings[game_manager.difficulty_index][2]:
		var t_bar = support_bar.instantiate()
		areas_container.get_child(0).add_child(t_bar)
		t_bar.name_bar(population_manager.groups["AG"][area_counter]["name_eng"])
		t_bar.change_icon(population_manager.groups["AG"][area_counter]["id"])

func update_support(candidate_index) -> void:
	var race_bars_array: Array = races_container.get_child(0).get_children()
	for race_bar_index in races_container.get_child(0).get_children().size():
		race_bars_array[race_bar_index].update_support(population_manager.candidates[candidate_index][0][race_bar_index])
	
	var work_bars_array: Array = works_container.get_child(0).get_children()
	for work_bar_index in works_container.get_child(0).get_children().size():
		work_bars_array[work_bar_index].update_support(population_manager.candidates[candidate_index][1][work_bar_index])
	
	var area_bars_array: Array = areas_container.get_child(0).get_children()
	for area_bar_index in areas_container.get_child(0).get_children().size():
		area_bars_array[area_bar_index].update_support(population_manager.candidates[candidate_index][2][area_bar_index])

func _on_supp_switch_button_pressed() -> void:
	support_counter += 1
	if (support_counter % 3) == 0:
		support_label.text = "Sympathy from races"
		races_container.visible = true
		works_container.visible = false
		areas_container.visible = false
	if (support_counter % 3) == 1:
		support_label.text = "Sympathy from workers"
		races_container.visible = false
		works_container.visible = true
		areas_container.visible = false
	if (support_counter % 3) == 2:
		support_label.text = "Sympathy from areas"
		races_container.visible = false
		works_container.visible = false
		areas_container.visible = true


func _on_cand_switch_button_pressed() -> void:
	candidate_counter += 1
	update_support(candidate_counter % population_manager.candidates.size())
	var candidate_index = candidate_counter % population_manager.candidates.size()
	if (candidate_index) == 0:
		candidate_label.text = "Your sympathies"
	else:
		candidate_label.text = "Sympathies of enemy " + str(candidate_index)
