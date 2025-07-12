extends Control

@onready var icon: TextureRect = $Icon
@onready var background_bar: ColorRect = $BackgroundBar
@onready var support_bar: ColorRect = $SupportBar
@onready var name_label: Label = $NameLabel
@onready var bar_label: Label = $PercentSupportLabel

func name_bar(name_text: String) -> void:
	name_label.text = name_text

func change_icon(icon_id: int) -> void:
	if icon_id == 0:
		icon.texture = load("res://Entities/support_bar/Human.png")
	if icon_id == 1:
		icon.texture = load("res://Entities/support_bar/Elf.png")
	if icon_id == 2:
		icon.texture = load("res://Entities/support_bar/Dwarf.png")
	if icon_id == 3:
		icon.texture = load("res://Entities/support_bar/Orc.png")

func update_support(support_percent: float) -> void: # argument in [0; 1]
	if support_percent < -1.0:
		support_percent = -1.0
	if support_percent > 1.0:
		support_percent = 1.0
	
	support_bar.color = Color((1 - support_percent) , support_percent, 0.0)
	support_bar.scale.x = support_percent
	support_bar.position.x = 200
	bar_label.text = str(int(support_percent * 100))
