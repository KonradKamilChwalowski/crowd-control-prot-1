extends Control

@onready var icon: TextureRect = $Icon
@onready var background_bar: ColorRect = $BackgroundBar
@onready var support_bar: ColorRect = $SupportBar
@onready var name_label: Label = $NameLabel
@onready var bar_label: Label = $PercentSupportLabel

func name_bar(name_text: String) -> void:
	name_label.text = name_text

func change_icon(group: String, icon_id: int) -> void:
	var image_path: String  = "res://Assets/Icons/" + group + "_" + str(icon_id) + ".png"
	if FileAccess.file_exists(image_path):
		icon.texture = load(image_path)
	else:
		icon.texture = load("res://Assets/Icons/error.png")

func update_support(support_percent: float) -> void: # argument in [0; 1]
	if support_percent < -1.0:
		support_percent = -1.0
	if support_percent > 1.0:
		support_percent = 1.0
	
	support_bar.color = Color((1 - support_percent) , support_percent, 0.0)
	support_bar.scale.x = support_percent
	support_bar.position.x = 200
	bar_label.text = str(int(support_percent * 100))

func update_population(group_population: int):
	if group_population < 0:
		group_population = 0
	if group_population > 10000:
		group_population = 10000
	
	var population_percent: float = float(group_population)/10000.0
	support_bar.color = Color(0,0,0,1)
	support_bar.scale.x = population_percent * 2
	support_bar.position.x = 80
	bar_label.text = str(int(population_percent * 100)) + "," + str(int(population_percent * 10000)%100) + "%"
	name_label.text += ": " + str(group_population)
