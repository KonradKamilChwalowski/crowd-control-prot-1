extends Node2D

@onready var json_path: String = "res://Utilities/groups.json"
@onready var groups: Dictionary = load_groups()

var population: Array = []
var groups_population: Array = [[],[],[]]
var groups_restrictions: Array = [[],[],[]]
var candidates: Array = []
var votes: Array = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_diff_restrictions()
	generate_population()
	generate_candidates()
	print(groups_population)
	votes = calculate_support()


func load_diff_restrictions() -> void:
	# Load Races restrictions
	var t_array = groups["RG"]
	t_array.shuffle()
	for race_i in game_manager.difficulty_settings[game_manager.difficulty_index][0]:
		groups_restrictions[0].append(int(t_array[race_i]["id"]))
	
	# Load Works restrictions
	t_array = groups["WG"]
	t_array.shuffle()
	for race_i in game_manager.difficulty_settings[game_manager.difficulty_index][1]:
		groups_restrictions[1].append(int(t_array[race_i]["id"]))
	
	# Load Areas restrictions
	t_array = groups["AG"]
	t_array.shuffle()
	for race_i in game_manager.difficulty_settings[game_manager.difficulty_index][2]:
		groups_restrictions[2].append(int(t_array[race_i]["id"]))


func generate_population() -> void:
	var citizen: Array = []
	var citizen_area_id: int
	var avaible_races_for_area: Array = []
	var citizen_race_id: int
	var avaible_works_for_area: Array = []
	var avaible_works_for_race: Array = []
	var avaible_works: Array = []
	var citizen_work_id: int
	
	# Make array of zeros
	for race_i in game_manager.difficulty_settings[game_manager.difficulty_index][0]:
		groups_population[0].append(0)
	for work_i in game_manager.difficulty_settings[game_manager.difficulty_index][1]:
		groups_population[1].append(0)
	for area_i in game_manager.difficulty_settings[game_manager.difficulty_index][2]:
		groups_population[2].append(0)
	
	for citizen_index in 10000:
		# Assign random area id from restricted
		citizen_area_id = int(groups_restrictions[2][randi() % groups_restrictions[2].size()])
		
		# For chosen area load avaible races
		avaible_races_for_area = groups["AG"][citizen_area_id]["races_for_area"]
		# Check if avaible_races are not restricted
		for race in avaible_races_for_area.duplicate():
			if not groups_restrictions[0].has(int(race)):
				avaible_races_for_area.erase(race)
		# From avaible races assign random race id
		citizen_race_id = int(avaible_races_for_area[randi() % avaible_races_for_area.size()])
		
		# For chosen area and race load avaible occupation
		avaible_works_for_area = groups["AG"][citizen_area_id]["works_for_area"]
		avaible_works_for_race = groups["RG"][citizen_race_id]["works_for_race"]
		avaible_works = avaible_works_for_area.duplicate()
		for work in avaible_works:
			if not avaible_works_for_race.has(work):
				avaible_works.erase(work)
		# Check if avaible_works are not restricted
		for work in avaible_works.duplicate():
			if not groups_restrictions[1].has(int(work)):
				avaible_works.erase(work)
		# From avaible occupations assign random occupation id
		citizen_work_id = int(avaible_works[randi() % avaible_works.size()])
		citizen = [citizen_race_id, citizen_work_id, citizen_area_id].duplicate()
		
		# Adds citizen to population
		population.append(citizen)
		
		# Count +1 in groups_population
		for group_index in groups_population.size():
			groups_population[group_index][groups_restrictions[group_index].find(citizen[group_index])] += 1


func generate_candidates() -> void:
	for candidate_index in (game_manager.difficulty_settings[game_manager.difficulty_index][3] + 1):
		var race_array: Array = []
		for race_index in game_manager.difficulty_settings[game_manager.difficulty_index][0]:
			race_array.append((randi() % 200 - 100) * 0.01)
		var work_array: Array = []
		for race_index in game_manager.difficulty_settings[game_manager.difficulty_index][1]:
			work_array.append(0.35)
		var area_array: Array = []
		for race_index in game_manager.difficulty_settings[game_manager.difficulty_index][2]:
			area_array.append(0.45)
		candidates.append([race_array, work_array, area_array])


# TODO
func calculate_support() -> Array:
	var population_votes: Array = []
	# For every citizen calculate his support for every candidate
	for citizen in population:
		var support_for_candidates: Array = []
		for candidate in candidates:
			var support: float = 0.0
			for group_index in citizen.size():
				var rwa_index:int = groups_restrictions[group_index].find(citizen[group_index])
				support += candidate[group_index][rwa_index]
			support_for_candidates.append(support)
		# Every citizen chose his candidateby biggest support
		var vote:int = find_all_and_return_random(support_for_candidates, support_for_candidates.max())
		population_votes.append(vote)
	return population_votes
	# Update candidates support

func find_all_and_return_random(array: Array, value) -> int:
	var indexes := []
	for i in range(array.size()):
		if array[i] == value:
			indexes.append(i)
	indexes.shuffle()
	return indexes[0]


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
