extends Control

@onready var icon: TextureRect = $Icon
@onready var background_bar: ColorRect = $BackgroundBar
@onready var support_bar: ColorRect = $SupportBar
@onready var name_label: Label = $RaceNameLabel
@onready var bar_label: Label = $PercentSupportLabel

func _ready() -> void:
	update_support(0.25)

func name_race(name_text: String) -> void:
	name_label.text = name_text.capitalize()

func update_support(support_percent: float) -> void: # argument in [0; 1]
	if support_percent < 0.0:
		support_percent = 0.0
	if support_percent > 1.0:
		support_percent = 1.0
	
	support_bar.color = Color((1 - support_percent) , support_percent, 0.0)
	support_bar.scale.x = support_percent
	bar_label.text = str(int(support_percent * 100)) + "%"
