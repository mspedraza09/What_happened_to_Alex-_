extends Control

# ─────────────────────────────────────────────────────────────────────────────
# PantallaCarta — Puzzle inicial del juego
#
# El jugador lee la carta y deduce el PIN: 2011 (día 20 + mes 11 de noviembre)
# Al acertar, se guarda en el StorageEngine via GameManager y navega al Login.
#
# Flujo de escenas:
#   PantallaCarta → (PIN correcto) → Scenes (Login) → MenuPrincipal
# ─────────────────────────────────────────────────────────────────────────────

const PIN_CORRECTO  := "2011"
const LOGIN_PATH    := "res://game/scenes/menu/MenuPrincipal.tscn"
const MAX_INTENTOS  := 5

# Nodos
@onready var carta_panel  := $CartaPanel
@onready var phone_root   := $PhoneRoot
@onready var btn_continuar := $CartaPanel/CartaContent/BtnContinuar
@onready var feedback     := $PhoneRoot/ScreenArea/FeedbackLabel
@onready var digits: Array[Label] = [
	$PhoneRoot/ScreenArea/PinRow/Digit0/Label,
	$PhoneRoot/ScreenArea/PinRow/Digit1/Label,
	$PhoneRoot/ScreenArea/PinRow/Digit2/Label,
	$PhoneRoot/ScreenArea/PinRow/Digit3/Label,
]

var pin_actual   := ""
var intentos     := 0
var pin_aceptado := false

func _ready() -> void:
	# Mostrar la carta primero; el teléfono empieza oculto
	phone_root.visible = false
	btn_continuar.pressed.connect(_mostrar_telefono)

	# Conectar teclado numérico
	var numpad := $PhoneRoot/ScreenArea/NumPad
	for btn in numpad.get_children():
		if btn is Button and btn.name.begins_with("Btn") and not btn.disabled:
			var label: String = btn.text
			if label == "⌫":
				btn.pressed.connect(_borrar)
			elif label != "":
				btn.pressed.connect(_presionar_numero.bind(label))

func _mostrar_telefono() -> void:
	# Animación: carta se mueve a la izquierda, teléfono aparece
	phone_root.visible = true
	phone_root.modulate = Color(1, 1, 1, 0)
	var tween := create_tween().set_parallel(true)
	tween.tween_property(phone_root, "modulate:a", 1.0, 0.5)
	tween.tween_property(carta_panel, "modulate:a", 0.4, 0.5)
	btn_continuar.visible = false

# ── Lógica del PIN ────────────────────────────────────────────────────────────

func _presionar_numero(numero: String) -> void:
	if pin_aceptado or pin_actual.length() >= 4:
		return
	pin_actual += numero
	_actualizar_display()
	if pin_actual.length() == 4:
		_verificar_pin()

func _borrar() -> void:
	if pin_aceptado or pin_actual.is_empty():
		return
	pin_actual = pin_actual.left(pin_actual.length() - 1)
	_actualizar_display()
	feedback.text = ""

func _actualizar_display() -> void:
	for i in 4:
		if i < pin_actual.length():
			digits[i].text = "●"
			digits[i].add_theme_color_override("font_color", Color(0.85, 0.88, 1.0, 1.0))
		else:
			digits[i].text = "·"
			digits[i].add_theme_color_override("font_color", Color(0.50, 0.55, 0.70, 1.0))

func _verificar_pin() -> void:
	if pin_actual == PIN_CORRECTO:
		_pin_correcto()
	else:
		_pin_incorrecto()

func _pin_correcto() -> void:
	pin_aceptado = true

	# Poner dígitos en verde
	for d in digits:
		d.add_theme_color_override("font_color", Color(0.40, 1.0, 0.55, 1.0))

	feedback.text = "Acceso concedido."
	feedback.add_theme_color_override("font_color", Color(0.40, 1.0, 0.55, 1.0))

	# Guardar en progreso que el PIN fue resuelto
	GameManager.engine.save("progress", "progress:pin_resuelto", true)

	# Transición al login después de un momento
	var tween := create_tween()
	tween.tween_interval(1.2)
	tween.tween_callback(_ir_al_login)

func _pin_incorrecto() -> void:
	intentos += 1

	# Poner dígitos en rojo y vibrar
	for d in digits:
		d.add_theme_color_override("font_color", Color(1.0, 0.40, 0.40, 1.0))

	if intentos >= MAX_INTENTOS:
		feedback.text = "Demasiados intentos. Relee la carta."
	else:
		feedback.text = "PIN incorrecto. Quedan %d intentos." % (MAX_INTENTOS - intentos)

	# Shake animado
	var original_pos := $PhoneRoot/ScreenArea/PinRow.position
	var tween := create_tween()
	tween.tween_property($PhoneRoot/ScreenArea/PinRow, "position",
		original_pos + Vector2(6, 0), 0.05)
	tween.tween_property($PhoneRoot/ScreenArea/PinRow, "position",
		original_pos - Vector2(6, 0), 0.05)
	tween.tween_property($PhoneRoot/ScreenArea/PinRow, "position",
		original_pos + Vector2(4, 0), 0.04)
	tween.tween_property($PhoneRoot/ScreenArea/PinRow, "position",
		original_pos, 0.04)

	# Limpiar después del shake
	tween.tween_interval(0.3)
	tween.tween_callback(func():
		pin_actual = ""
		_actualizar_display()
	)

func _ir_al_login() -> void:
	if get_tree().change_scene_to_file(LOGIN_PATH) != OK:
		push_error("No se pudo cargar: " + LOGIN_PATH)
