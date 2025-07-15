extends Node2D

@onready var population_manager: Node2D = $PopulationManager

# LEFT SCROLL
@onready var support_scroll: TextureRect = $Background/SupportScroll
@onready var supp_group_label: Label = $Background/SupportScroll/SupportLabel
@onready var supp_candidate_label: Label = $Background/SupportScroll/CandidateLabel
@onready var supp_races_container: ScrollContainer = $Background/SupportScroll/RacesScrollContainer
@onready var supp_works_container: ScrollContainer = $Background/SupportScroll/WorksScrollContainer
@onready var supp_areas_container: ScrollContainer = $Background/SupportScroll/AreasScrollContainer
@onready var show_scroll_button_left: Button = $Background/SupportScroll/ShowScrollButton

# RIGHT SCROLL
@onready var population_scroll: TextureRect = $Background/PopulationScroll
@onready var population_group_label: Label = $Background/PopulationScroll/PopulationLabel
@onready var population_races_container: ScrollContainer = $Background/PopulationScroll/RacesScrollContainer
@onready var population_works_container: ScrollContainer = $Background/PopulationScroll/WorksScrollContainer
@onready var population_areas_container: ScrollContainer = $Background/PopulationScroll/AreasScrollContainer
@onready var show_scroll_button_right: Button = $Background/PopulationScroll/ShowScrollButton

# TV AND POSTS
@onready var tv_label: Label = $"Background/TVScreen/TVLabel"
@onready var posts_containar: HBoxContainer = $"Background/PostsContainer"

@onready var support_bar := load("res://Entities/support_bar/support_bar.tscn")
@onready var post_tooltip := load("res://Entities/post_tooltip/post_tooltip.tscn")
@onready var json_path: String = "res://Utilities/events_library.json"
@onready var events_library: Array = load_events()

# COUNTERS
var supp_group_counter: int = -1
var candidate_counter: int = -1
var population_group_counter: int = -1
var is_left_scroll_hiden = true
var is_left_scroll_animation_off = true
var is_right_scroll_hiden = true
var is_right_scroll_animation_off = true
var events_that_already_happend: Array = []

func update_events() -> void:
	var event_id: int = int(randi() % events_library.size())
	events_that_already_happend.append(event_id)
	tv_label.text = events_library[event_id]["Description"]
	var reactions: Array = [[],[],[]]
	for i in reactions.size():
		reactions[i].append(events_library[event_id]["Reaction" + str(i)])
		reactions[i].append(events_library[event_id]["Consequences" + str(i)])
		update_button(posts_containar.get_child(i), reactions[i], event_id)

func update_button(button: Button, reactions: Array, event_id: int) -> void:
	for child in button.get_children():
		child.queue_free()
	
	button.text = reactions[0]
	var vbcontainer: VBoxContainer = VBoxContainer.new()
	button.add_child(vbcontainer)
	vbcontainer.add_theme_constant_override("separation", 0)
	for race in events_library[event_id]["Races_id"].size():
		var tooltip = post_tooltip.instantiate()
		vbcontainer.add_child(tooltip)
		tooltip.init("RG", events_library[event_id]["Races_id"][race])
	for work in events_library[event_id]["Works_id"].size():
		var tooltip = post_tooltip.instantiate()
		vbcontainer.add_child(tooltip)
		tooltip.init("WG", events_library[event_id]["Works_id"][work])
	for area in events_library[event_id]["Areas_id"].size():
		var tooltip = post_tooltip.instantiate()
		vbcontainer.add_child(tooltip)
		tooltip.init("AG", events_library[event_id]["Areas_id"][area])
	await get_tree().process_frame
	vbcontainer.position.y -= vbcontainer.size.y
	vbcontainer.visible = false

func load_events() -> Array:
	var file := FileAccess.open(json_path, FileAccess.READ)
	if file:
		var content: String = file.get_as_text()
		var data: Array = JSON.parse_string(content)
		file.close()
		if typeof(data) == TYPE_ARRAY:
			return data
		else:
			print("Niepoprawny format JSON")
			return []
	else:
		print("Nie można otworzyć pliku JSON")
		return []


func _ready() -> void:
	instantiate_support_bars()
	instantiate_population_bars()
	_on_supp_switch_button_pressed()
	_on_cand_switch_button_pressed()
	_on_group_switch_button_pressed()
	update_events()
	#new round

func _process(delta: float) -> void:
	# LEFT SCROLL ANIMATION
	if not is_left_scroll_animation_off:
		if is_left_scroll_hiden:
			support_scroll.position.x += delta*200
			if support_scroll.position.x > 0:
				support_scroll.position.x = 0
				is_left_scroll_animation_off = true
		else:
			support_scroll.position.x -= delta*200
			if support_scroll.position.x < -336:
				support_scroll.position.x = -336
				is_left_scroll_animation_off = true
	# RIGHT SCROLL ANIMATION
	if not is_right_scroll_animation_off:
		if is_right_scroll_hiden:
			population_scroll.position.x -= delta*200
			if population_scroll.position.x < 983:
				population_scroll.position.x = 983
				is_right_scroll_animation_off = true
		else:
			population_scroll.position.x += delta*200
			if population_scroll.position.x > 1318:
				population_scroll.position.x = 1318
				is_right_scroll_animation_off = true


func instantiate_support_bars() -> void:
	for race_counter in game_manager.difficulty_settings[game_manager.difficulty_index][0]:
		var t_bar = support_bar.instantiate()
		supp_races_container.get_child(0).add_child(t_bar)
		t_bar.name_bar(population_manager.groups["RG"][population_manager.groups_restrictions[0][race_counter]]["name_eng"])
		t_bar.change_icon("RG", population_manager.groups["RG"][population_manager.groups_restrictions[0][race_counter]]["id"])
	for work_counter in game_manager.difficulty_settings[game_manager.difficulty_index][1]:
		var t_bar = support_bar.instantiate()
		supp_works_container.get_child(0).add_child(t_bar)
		t_bar.name_bar(population_manager.groups["WG"][population_manager.groups_restrictions[1][work_counter]]["name_eng"])
		t_bar.change_icon("WG", population_manager.groups["WG"][population_manager.groups_restrictions[1][work_counter]]["id"])
	for area_counter in game_manager.difficulty_settings[game_manager.difficulty_index][2]:
		var t_bar = support_bar.instantiate()
		supp_areas_container.get_child(0).add_child(t_bar)
		t_bar.name_bar(population_manager.groups["AG"][population_manager.groups_restrictions[2][area_counter]]["name_eng"])
		t_bar.change_icon("AG", population_manager.groups["AG"][population_manager.groups_restrictions[2][area_counter]]["id"])

func instantiate_population_bars() -> void:
	for race_counter in game_manager.difficulty_settings[game_manager.difficulty_index][0]:
		var t_bar = support_bar.instantiate()
		population_races_container.get_child(0).add_child(t_bar)
		t_bar.name_bar(population_manager.groups["RG"][population_manager.groups_restrictions[0][race_counter]]["name_eng"])
		t_bar.change_icon("RG", population_manager.groups["RG"][population_manager.groups_restrictions[0][race_counter]]["id"])
	for work_counter in game_manager.difficulty_settings[game_manager.difficulty_index][1]:
		var t_bar = support_bar.instantiate()
		population_works_container.get_child(0).add_child(t_bar)
		t_bar.name_bar(population_manager.groups["WG"][population_manager.groups_restrictions[1][work_counter]]["name_eng"])
		t_bar.change_icon("WG", population_manager.groups["WG"][population_manager.groups_restrictions[1][work_counter]]["id"])
	for area_counter in game_manager.difficulty_settings[game_manager.difficulty_index][2]:
		var t_bar = support_bar.instantiate()
		population_areas_container.get_child(0).add_child(t_bar)
		t_bar.name_bar(population_manager.groups["AG"][population_manager.groups_restrictions[2][area_counter]]["name_eng"])
		t_bar.change_icon("AG", population_manager.groups["AG"][population_manager.groups_restrictions[2][area_counter]]["id"])
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


func _on_Left_show_scroll_button_pressed() -> void:
	if is_left_scroll_animation_off:
		is_left_scroll_animation_off = false
		if is_left_scroll_hiden:
			is_left_scroll_hiden = false
		else:
			is_left_scroll_hiden = true


func _on_right_show_scroll_button_pressed() -> void:
	if is_right_scroll_animation_off:
		is_right_scroll_animation_off = false
		if is_right_scroll_hiden:
			is_right_scroll_hiden = false
		else:
			is_right_scroll_hiden = true


func _on_post_button_mouse_entered() -> void:
	for child in posts_containar.get_children():
		child.get_child(0).visible = true


func _on_post_button_mouse_exited() -> void:
	for child in posts_containar.get_children():
		child.get_child(0).visible = false


func _on_post_button_1_pressed() -> void:
	update_events()
	await get_tree().process_frame
	for child in posts_containar.get_children():
		child.get_child(0).visible = true

func _on_post_button_2_pressed() -> void:
	update_events()
	await get_tree().process_frame
	for child in posts_containar.get_children():
		child.get_child(0).visible = true

func _on_post_button_3_pressed() -> void:
	update_events()
	await get_tree().process_frame
	for child in posts_containar.get_children():
		child.get_child(0).visible = true
