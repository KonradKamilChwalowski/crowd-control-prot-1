extends Control


func init(group: String, id: int):
	update_icon(group, id)

func update_icon(group: String, icon_id: int) -> void:
	var icon: TextureRect = $"Icon"
	var image_path: String  = "res://Assets/Icons/" + group + "_" + str(icon_id) + ".png"
	if FileAccess.file_exists(image_path):
		icon.texture = load(image_path)
	else:
		icon.texture = load("res://Assets/Icons/error.png")

func update_text(consequence: int) -> void:
	print(consequence)
	var label: Label = $"Label"
	var symbol: String = "+ "
	if consequence == 0:
		label.text = "---"
		label.add_theme_color_override("font_color", Color(0.5, 0.5, 0.5, 1))
	else:
		if consequence < 0:
			consequence *= -1
			symbol = "x "
			label.add_theme_color_override("font_color", Color(1, 0, 0, 1))
		label.text = ""
		for i in consequence:
			label.text += symbol
	print(symbol)
