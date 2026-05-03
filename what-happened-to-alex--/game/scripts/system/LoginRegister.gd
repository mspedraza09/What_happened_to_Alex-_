extends Control

const MAIN_SCENE_PATH: String = "res://game/scenes/apps/AppMensjae.tscn"

var engine: StorageEngine

@onready var username_input = $PhoneFrame/VBoxContainer/Form/UsernameLineEdit
@onready var password_input = $PhoneFrame/VBoxContainer/Form/PasswordLineEdit
@onready var message_label = $PhoneFrame/VBoxContainer/MessageLabel
@onready var welcome_label = $PhoneFrame/VBoxContainer/WelcomeLabel
@onready var login_button = $PhoneFrame/VBoxContainer/ButtonContainer/LoginButton
@onready var register_button = $PhoneFrame/VBoxContainer/ButtonContainer/RegisterButton

func _ready() -> void:
	engine = StorageEngine.new("user://save_data")
	login_button.pressed.connect(_on_LoginButton_pressed)
	register_button.pressed.connect(_on_RegisterButton_pressed)

func _on_LoginButton_pressed() -> void:
	var username: String = username_input.text.strip_edges()
	var password: String = password_input.text

	if username.is_empty() or password.is_empty():
		show_message("Completa todos los campos.")
		return

	if engine.authenticate_user(username, password):
		show_welcome_transition(username)
	else:
		show_message("Usuario o contraseña incorrectos.")
	password_input.text = ""

func _on_RegisterButton_pressed() -> void:
	var username: String = username_input.text.strip_edges()
	var password: String = password_input.text

	if username.is_empty() or password.is_empty():
		show_message("Completa todos los campos.")
		return

	if engine.register_user(username, password):
		show_message("Registro exitoso. Ya puedes iniciar sesión.")
	else:
		show_message("El usuario ya existe o hay datos inválidos.")
	password_input.text = ""

func change_to_main_scene() -> void:
	if get_tree().change_scene_to_file(MAIN_SCENE_PATH) != OK:
		show_message("No se pudo cargar la escena principal.")

func show_message(text: String) -> void:
	message_label.text = text

func show_welcome_transition(username: String) -> void:
	welcome_label.text = "Bienvenido, %s!" % username
	welcome_label.visible = true
	welcome_label.modulate = Color(1, 1, 1, 0)
	login_button.disabled = true
	register_button.disabled = true

	var tween = create_tween()
	tween.tween_property(welcome_label, "modulate:a", 1.0, 0.4)
	tween.tween_interval(1.0)
	tween.tween_property(welcome_label, "modulate:a", 0.0, 0.4)
	await tween.finished
	change_to_main_scene()
