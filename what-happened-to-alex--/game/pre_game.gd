extends Control

func _on_play_pressed():
	get_tree().change_scene_to_file("res://main.tscn")

func _on_settings_pressed():
	get_tree().change_scene_to_file("res://Settings.tscn")


func _on_button_pressed() -> void:
	pass # Replace with function body.


func _on_button_2_pressed() -> void:
	get_tree().change_scene_to_file("res://Settings.tscn")
