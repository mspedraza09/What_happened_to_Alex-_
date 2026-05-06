extends Control

const CARTA_PATH := "res://game/scenes/menu/PantallaCarta.tscn"
const MENU_PATH  := "res://game/scenes/menu/MenuPrincipal.tscn"

var engine: StorageEngine

@onready var username_input  := $PhoneRoot/ScreenArea/LoginContent/UsernameLineEdit
@onready var password_input  := $PhoneRoot/ScreenArea/LoginContent/PasswordLineEdit
@onready var message_label   := $PhoneRoot/ScreenArea/LoginContent/MessageLabel
@onready var welcome_label   := $PhoneRoot/ScreenArea/LoginContent/WelcomeLabel
@onready var login_button    := $PhoneRoot/ScreenArea/LoginContent/ButtonContainer/LoginButton
@onready var register_button := $PhoneRoot/ScreenArea/LoginContent/ButtonContainer/RegisterButton

func _ready() -> void:
	engine = StorageEngine.new("user://save_data")

	# Si ya hay sesión activa, saltar directamente a donde corresponde
	if GameManager.hay_sesion_activa():
		var usuario: String = GameManager.get_usuario_activo()
		_ir_siguiente(usuario)
		return

	login_button.pressed.connect(_on_login_pressed)
	register_button.pressed.connect(_on_register_pressed)

func _on_login_pressed() -> void:
	var username: String = username_input.text.strip_edges()
	var password: String = password_input.text
	if username.is_empty() or password.is_empty():
		_show_message("Completa todos los campos.")
		return
	if engine.authenticate_user(username, password):
		GameManager.iniciar_sesion(username)
		_show_welcome_transition(username)
	else:
		_show_message("Usuario o contraseña incorrectos.")
	password_input.text = ""

func _on_register_pressed() -> void:
	var username: String = username_input.text.strip_edges()
	var password: String = password_input.text
	if username.is_empty() or password.is_empty():
		_show_message("Completa todos los campos.")
		return
	if engine.register_user(username, password):
		engine.save("progress", "progress:%s:fase" % username, 0)
		_show_message("Registro exitoso. Ya puedes iniciar sesión.")
	else:
		_show_message("El usuario ya existe o hay datos inválidos.")
	password_input.text = ""

func _show_message(text: String) -> void:
	message_label.text = text

func _show_welcome_transition(username: String) -> void:
	welcome_label.text = "Bienvenido, %s!" % username
	welcome_label.visible = true
	welcome_label.modulate = Color(1, 1, 1, 0)
	login_button.disabled    = true
	register_button.disabled = true
	var tween := create_tween()
	tween.tween_property(welcome_label, "modulate:a", 1.0, 0.4)
	tween.tween_interval(0.6)
	tween.tween_property(welcome_label, "modulate:a", 0.0, 0.3)
	await tween.finished
	_ir_siguiente(username)

func _ir_siguiente(username: String) -> void:
	if GameManager.is_pin_resuelto():
		get_tree().change_scene_to_file.call_deferred(MENU_PATH)
	else:
		get_tree().change_scene_to_file.call_deferred(CARTA_PATH)
