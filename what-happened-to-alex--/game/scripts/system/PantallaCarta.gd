extends Control

const PIN_CORRECTO := "2011"
const MENU_PATH    := "res://game/scenes/menu/MenuPrincipal.tscn"
const MAX_INTENTOS := 5

@onready var carta_panel   := $CartaPanel
@onready var phone_root    := $PhoneRoot
@onready var btn_continuar := $CartaPanel/CartaContent/BtnContinuar
@onready var feedback      := $PhoneRoot/ScreenArea/FeedbackLabel
@onready var numpad        := $PhoneRoot/ScreenArea/NumPad
@onready var pin_row       := $PhoneRoot/ScreenArea/PinRow

var digits: Array = []
var pin_actual   := ""
var intentos     := 0
var pin_aceptado := false

func _ready() -> void:
	digits = [
		$PhoneRoot/ScreenArea/PinRow/Digit0/Label,
		$PhoneRoot/ScreenArea/PinRow/Digit1/Label,
		$PhoneRoot/ScreenArea/PinRow/Digit2/Label,
		$PhoneRoot/ScreenArea/PinRow/Digit3/Label,
	]

	phone_root.visible = false
	btn_continuar.pressed.connect(_mostrar_telefono)

	# Conectar por nombre de nodo — más fiable que comparar texto/emoji
	for btn in numpad.get_children():
		if not btn is Button:
			continue
		var n := btn.name
		if n == "BtnDel":
			btn.pressed.connect(_borrar)
		elif n == "BtnVacio":
			pass  # espacio vacío, no hacer nada
		else:
			# Btn0, Btn1 … Btn9 — extraer el dígito del nombre
			var digit := n.replace("Btn", "")
			btn.pressed.connect(_presionar_numero.bind(digit))

func _mostrar_telefono() -> void:
	phone_root.visible = true
	phone_root.modulate = Color(1, 1, 1, 0)
	btn_continuar.visible = false
	var tween := create_tween().set_parallel(true)
	tween.tween_property(phone_root,  "modulate:a", 1.0, 0.5)
	tween.tween_property(carta_panel, "modulate:a", 0.4, 0.5)

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
		var lbl: Label = digits[i]
		if i < pin_actual.length():
			lbl.text = "●"
			lbl.add_theme_color_override("font_color", Color(0.85, 0.88, 1.0, 1.0))
		else:
			lbl.text = "·"
			lbl.add_theme_color_override("font_color", Color(0.50, 0.55, 0.70, 1.0))

func _verificar_pin() -> void:
	if pin_actual == PIN_CORRECTO:
		_pin_correcto()
	else:
		_pin_incorrecto()

func _pin_correcto() -> void:
	pin_aceptado = true
	for lbl in digits:
		lbl.add_theme_color_override("font_color", Color(0.40, 1.0, 0.55, 1.0))
	feedback.text = "Acceso concedido."
	feedback.add_theme_color_override("font_color", Color(0.40, 1.0, 0.55, 1.0))
	GameManager.engine.save("progress", "progress:pin_resuelto", true)
	var tween := create_tween()
	tween.tween_interval(1.2)
	tween.tween_callback(_ir_al_menu)

func _pin_incorrecto() -> void:
	intentos += 1
	for lbl in digits:
		lbl.add_theme_color_override("font_color", Color(1.0, 0.40, 0.40, 1.0))

	if intentos >= MAX_INTENTOS:
		feedback.text = "Demasiados intentos. Relee la carta."
	else:
		feedback.text = "PIN incorrecto. Quedan %d intentos." % (MAX_INTENTOS - intentos)

	var orig: Vector2 = pin_row.position
	var tween := create_tween()
	tween.tween_property(pin_row, "position", orig + Vector2(6, 0),  0.05)
	tween.tween_property(pin_row, "position", orig - Vector2(6, 0),  0.05)
	tween.tween_property(pin_row, "position", orig + Vector2(4, 0),  0.04)
	tween.tween_property(pin_row, "position", orig,                  0.04)
	tween.tween_interval(0.3)
	tween.tween_callback(func():
		pin_actual = ""
		_actualizar_display()
	)

func _ir_al_menu() -> void:
	if get_tree().change_scene_to_file(MENU_PATH) != OK:
		push_error("No se pudo cargar: " + MENU_PATH)
