extends Node2D

@onready var population_manager: Node2D = $PopulationManager

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	#print(game_manager.difficulty_settings[game_manager.difficulty_index])
	#print(population_manager.population[i])

func prepare_session() -> void:
	pass
