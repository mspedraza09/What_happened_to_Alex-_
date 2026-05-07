func _on_button_pressed():
	var username = $VBoxContainer/LineEdit.text
	var password = $VBoxContainer/LineEdit2.text

	if username != "" and password != "":
		get_tree().change_scene_to_file("res://PreGame.tscn")
	else:
		print("Fill all fields")
