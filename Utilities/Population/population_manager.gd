extends Node2D

@onready var json_path := "res://Utilities/groups.json"
@onready var groups = load_groups()

var population: Array = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("XD")
	generate_population()
	# TODO calculate_support()

# TODO
func calculate_support() -> void:
	pass

func generate_population() -> void:
	var citizen: Array = []
	var citizen_area_id: int
	var avaible_races_for_area: Array = []
	var citizen_race_id: int
	var avaible_works_for_area: Array = []
	var avaible_works_for_race: Array = []
	var avaible_works: Array = []
	var citizen_work_id: int
	for citizen_index in 10000:
		# Assign random area id
		citizen_area_id = int(groups["AG"][randi() % groups["AG"].size()]["id"])
		# For chosen area load avaible races
		avaible_races_for_area = groups["AG"][citizen_area_id]["races_for_area"]
		# For avaible races assign random race id
		citizen_race_id = int(avaible_races_for_area[randi() % avaible_races_for_area.size()])
		
		# For chosen area and race load avaible occupation
		avaible_works_for_area = groups["AG"][citizen_area_id]["works_for_area"]
		avaible_works_for_race = groups["RG"][citizen_race_id]["works_for_race"]
		avaible_works = avaible_works_for_area.duplicate()
		for work in avaible_works:
			if not avaible_works_for_race.has(work):
				avaible_works.erase(work)
		# For avaible occupations assign random occupation id
		citizen_work_id = int(avaible_works[randi() % avaible_works.size()])
		citizen = [citizen_race_id, citizen_work_id, citizen_area_id].duplicate()
		
		# Adds citizen to population
		population.append(citizen)

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
