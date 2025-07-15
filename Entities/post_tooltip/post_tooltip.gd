extends Control


func init(group: String, id: int):
	change_icon(group, id)

func change_icon(group: String, icon_id: int) -> void:
	var icon: TextureRect = $"Icon"
	var image_path: String  = "res://Assets/Icons/" + group + "_" + str(icon_id) + ".png"
	if FileAccess.file_exists(image_path):
		icon.texture = load(image_path)
	else:
		icon.texture = load("res://Assets/Icons/error.png")
