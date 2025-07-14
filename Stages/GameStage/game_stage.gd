extends Node2D

@onready var population_manager: Node2D = $PopulationManager

@onready var supp_group_label: Label = $Background/SupportScroll/SupportLabel
@onready var supp_candidate_label: Label = $Background/SupportScroll/CandidateLabel
@onready var supp_races_container: ScrollContainer = $Background/SupportScroll/RacesScrollContainer
@onready var supp_works_container: ScrollContainer = $Background/SupportScroll/WorksScrollContainer
@onready var supp_areas_container: ScrollContainer = $Background/SupportScroll/AreasScrollContainer

@onready var population_group_label: Label = $Background/PopulationScroll/PopulationLabel
@onready var population_races_container: ScrollContainer = $Background/PopulationScroll/RacesScrollContainer
@onready var population_works_container: ScrollContainer = $Background/PopulationScroll/WorksScrollContainer
@onready var population_areas_container: ScrollContainer = $Background/PopulationScroll/AreasScrollContainer

@onready var support_bar := load("res://Entities/support_bar/support_bar.tscn")

var supp_group_counter: int = -1
var candidate_counter: int = -1
var population_group_counter: int = -1

func _ready() -> void:
	instantiate_support_bars()
	instantiate_population_bars()
	_on_supp_switch_button_pressed()
	_on_cand_switch_button_pressed()
	_on_group_switch_button_pressed()
	#new round


func instantiate_support_bars() -> void:
	for race_counter in game_manager.difficulty_settings[game_manager.difficulty_index][0]:
		var t_bar = support_bar.instantiate()
		supp_races_container.get_child(0).add_child(t_bar)
		t_bar.name_bar(population_manager.groups["RG"][race_counter]["name_eng"])
		t_bar.change_icon(population_manager.groups["RG"][race_counter]["id"])
	for work_counter in game_manager.difficulty_settings[game_manager.difficulty_index][1]:
		var t_bar = support_bar.instantiate()
		supp_works_container.get_child(0).add_child(t_bar)
		t_bar.name_bar(population_manager.groups["WG"][work_counter]["name_eng"])
		t_bar.change_icon(population_manager.groups["WG"][work_counter]["id"])
	for area_counter in game_manager.difficulty_settings[game_manager.difficulty_index][2]:
		var t_bar = support_bar.instantiate()
		supp_areas_container.get_child(0).add_child(t_bar)
		t_bar.name_bar(population_manager.groups["AG"][area_counter]["name_eng"])
		t_bar.change_icon(population_manager.groups["AG"][area_counter]["id"])

func instantiate_population_bars() -> void:
	for race_counter in game_manager.difficulty_settings[game_manager.difficulty_index][0]:
		var t_bar = support_bar.instantiate()
		population_races_container.get_child(0).add_child(t_bar)
		t_bar.name_bar(population_manager.groups["RG"][race_counter]["name_eng"])
		t_bar.change_icon(population_manager.groups["RG"][race_counter]["id"])
	for work_counter in game_manager.difficulty_settings[game_manager.difficulty_index][1]:
		var t_bar = support_bar.instantiate()
		population_works_container.get_child(0).add_child(t_bar)
		t_bar.name_bar(population_manager.groups["WG"][work_counter]["name_eng"])
		t_bar.change_icon(population_manager.groups["WG"][work_counter]["id"])
	for area_counter in game_manager.difficulty_settings[game_manager.difficulty_index][2]:
		var t_bar = support_bar.instantiate()
		population_areas_container.get_child(0).add_child(t_bar)
		t_bar.name_bar(population_manager.groups["AG"][area_counter]["name_eng"])
		t_bar.change_icon(population_manager.groups["AG"][area_counter]["id"])
	update_population()

func update_support(candidate_index) -> void:
	var race_bars_array: Array = supp_races_container.get_child(0).get_children()
	for race_bar_index in supp_races_container.get_child(0).get_children().size():
		race_bars_array[race_bar_index].update_support(population_manager.candidates[candidate_index][0][race_bar_index])
	
	var work_bars_array: Array = supp_works_container.get_child(0).get_children()
	for work_bar_index in supp_works_container.get_child(0).get_children().size():
		work_bars_array[work_bar_index].update_support(population_manager.candidates[candidate_index][1][work_bar_index])
	
	var area_bars_array: Array = supp_areas_container.get_child(0).get_children()
	for area_bar_index in supp_areas_container.get_child(0).get_children().size():
		area_bars_array[area_bar_index].update_support(population_manager.candidates[candidate_index][2][area_bar_index])

func update_population() -> void:
	var race_bars_array: Array = population_races_container.get_child(0).get_children()
	for race_bar_index in population_races_container.get_child(0).get_children().size():
		race_bars_array[race_bar_index].update_population(population_manager.groups_population[0][race_bar_index])
	var work_bars_array: Array = population_works_container.get_child(0).get_children()
	for work_bar_index in supp_works_container.get_child(0).get_children().size():
		work_bars_array[work_bar_index].update_population(population_manager.groups_population[1][work_bar_index])
	var area_bars_array: Array = population_areas_container.get_child(0).get_children()
	for area_bar_index in supp_areas_container.get_child(0).get_children().size():
		area_bars_array[area_bar_index].update_population(population_manager.groups_population[2][area_bar_index])

func _on_supp_switch_button_pressed() -> void:
	supp_group_counter += 1
	if (supp_group_counter % 3) == 0:
		supp_group_label.text = "Sympathy from races"
		supp_races_container.visible = true
		supp_works_container.visible = false
		supp_areas_container.visible = false
	if (supp_group_counter % 3) == 1:
		supp_group_label.text = "Sympathy from workers"
		supp_races_container.visible = false
		supp_works_container.visible = true
		supp_areas_container.visible = false
	if (supp_group_counter % 3) == 2:
		supp_group_label.text = "Sympathy from areas"
		supp_races_container.visible = false
		supp_works_container.visible = false
		supp_areas_container.visible = true


func _on_group_switch_button_pressed() -> void:
	population_group_counter += 1
	if (population_group_counter % 3) == 0:
		population_group_label.text = "Races population"
		population_races_container.visible = true
		population_works_container.visible = false
		population_areas_container.visible = false
	if (population_group_counter % 3) == 1:
		population_group_label.text = "Workers population"
		population_races_container.visible = false
		population_works_container.visible = true
		population_areas_container.visible = false
	if (population_group_counter % 3) == 2:
		population_group_label.text = "Areas population"
		population_races_container.visible = false
		population_works_container.visible = false
		population_areas_container.visible = true


func _on_cand_switch_button_pressed() -> void:
	candidate_counter += 1
	update_support(candidate_counter % population_manager.candidates.size())
	var candidate_index = candidate_counter % population_manager.candidates.size()
	if (candidate_index) == 0:
		supp_candidate_label.text = "Your sympathies"
	else:
		supp_candidate_label.text = "Sympathies of enemy " + str(candidate_index)
