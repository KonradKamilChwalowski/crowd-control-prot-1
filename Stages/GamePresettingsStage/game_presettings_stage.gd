extends Node2D

@onready var play_button: Button = $"TextureRect/PlayButton"

var difficulty: bool = false


func _on_play_button_pressed() -> void:
	if difficulty:
		game_manager.load_stage("game_stage")
	else:
		var stylebox = StyleBoxFlat.new()
		stylebox.bg_color = Color(1.0, 0.0, 0.0, 0.5)
		play_button.add_theme_stylebox_override("normal", stylebox)
		play_button.add_theme_stylebox_override("hover", stylebox)


func _on_tutorial_button_pressed() -> void:
	difficulty = true


func _on_easy_button_pressed() -> void:
	difficulty = true


func _on_medium_button_pressed() -> void:
	difficulty = true


func _on_hard_button_pressed() -> void:
	difficulty = true


func _on_custom_button_pressed() -> void:
	difficulty = true
