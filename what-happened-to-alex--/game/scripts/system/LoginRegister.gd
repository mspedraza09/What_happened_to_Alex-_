extends Control

const MENU_SCENE_PATH: String = "res://game/scenes/menu/MenuPrincipal.tscn"

var engine: StorageEngine

@onready var username_input  = $PhoneRoot/ScreenArea/LoginContent/UsernameLineEdit
@onready var password_input  = $PhoneRoot/ScreenArea/LoginContent/PasswordLineEdit
@onready var message_label   = $PhoneRoot/ScreenArea/LoginContent/MessageLabel
@onready var welcome_label   = $PhoneRoot/ScreenArea/LoginContent/WelcomeLabel
@onready var login_button    = $PhoneRoot/ScreenArea/LoginContent/ButtonContainer/LoginButton
@onready var register_button = $PhoneRoot/ScreenArea/LoginContent/ButtonContainer/RegisterButton

func _ready() -> void:
	engine = StorageEngine.new("user://save_data")
	login_button.pressed.connect(_on_login_pressed)
	register_button.pressed.connect(_on_register_pressed)

func _on_login_pressed() -> void:
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

func _on_register_pressed() -> void:
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

func show_message(text: String) -> void:
	message_label.text = text

func show_welcome_transition(username: String) -> void:
	welcome_label.text = "Bienvenido, %s!" % username
	welcome_label.visible = true
	welcome_label.modulate = Color(1, 1, 1, 0)
	login_button.disabled    = true
	register_button.disabled = true

	var tween = create_tween()
	tween.tween_property(welcome_label, "modulate:a", 1.0, 0.4)
	tween.tween_interval(0.8)
	tween.tween_property(welcome_label, "modulate:a", 0.0, 0.4)
	await tween.finished
	_go_to_menu()

func _go_to_menu() -> void:
	if get_tree().change_scene_to_file(MENU_SCENE_PATH) != OK:
		show_message("No se pudo cargar el menú.")
