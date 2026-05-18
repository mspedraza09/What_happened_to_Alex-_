extends Control
@onready var password_input = $CenterContainer/PasswordInput
@onready var title_label = $CenterContainer/TitleLabel
var secret_password = "123"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_unlock_button_pressed() -> void:
	# We get the text the player typed
	var user_text = password_input.text
	
	# We check if the text is exactly the same as the secret password
	if user_text == secret_password:
		title_label.text = "Access Granted!"
		# Here we will change the screen to the diary list. 
		# Remove the "#" on the next line when your AppDiary scene is ready:
		get_tree().change_scene_to_file("res://game/scenes/apps_2/AppDiary/AppDiary.tscn")
	else:
		# If the password is wrong
		title_label.text = "Wrong password. Try again."
		password_input.text = "" # This deletes the wrong text so the user can type again
