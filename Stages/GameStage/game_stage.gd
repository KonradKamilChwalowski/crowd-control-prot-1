extends Node2D

@onready var population_manager: Node2D = $PopulationManager
@onready var races_container: VBoxContainer = $Background/SupportTable/ScrollContainer/RacesContainer
@onready var support_bar := load("res://Entities/support_bar/support_bar.tscn")

func _ready() -> void:
	# Set support bars
	for race_counter in game_manager.difficulty_settings[game_manager.difficulty_index][0]:
		var t_bar = support_bar.instantiate()
		races_container.add_child(t_bar)
		t_bar.name_bar(population_manager.groups["RG"][race_counter]["name_eng"])
		t_bar.change_icon(population_manager.groups["RG"][race_counter]["id"])

func prepare_session() -> void:
	pass
