extends "res://game/scripts/apps/BaseApp.gd"

# App Diario — se desbloquea solo al completar las 3 pistas
# Si el diario ya está desbloqueado (GameManager.is_diario_desbloqueado()),
# muestra el contenido directamente.
# Si no, muestra el campo de contraseña final.

@onready var panel_lock    := $PhoneRoot/ScreenArea/AppContent/PanelLock
@onready var panel_diario  := $PhoneRoot/ScreenArea/AppContent/PanelDiario
@onready var input_clave   := $PhoneRoot/ScreenArea/AppContent/PanelLock/InputClave
@onready var btn_abrir     := $PhoneRoot/ScreenArea/AppContent/PanelLock/BtnAbrir
@onready var label_error   := $PhoneRoot/ScreenArea/AppContent/PanelLock/LabelError
@onready var label_pistas  := $PhoneRoot/ScreenArea/AppContent/PanelLock/LabelPistas

func _on_app_ready() -> void:
	if GameManager.is_diario_desbloqueado():
		_mostrar_diario()
	else:
		panel_lock.visible   = true
		panel_diario.visible = false
		_mostrar_estado_pistas()
		btn_abrir.pressed.connect(_intentar_abrir)

func _mostrar_estado_pistas() -> void:
	var p1 := GameManager.get_pista(1)
	var p2 := GameManager.get_pista(2)
	var p3 := GameManager.get_pista(3)
	var texto := "Pistas encontradas:\n"
	texto += "  1. %s\n" % ("✓ " + p1 if not p1.is_empty() else "✗ pendiente")
	texto += "  2. %s\n" % ("✓ " + p2 if not p2.is_empty() else "✗ pendiente")
	texto += "  3. %s"   % ("✓ " + p3 if not p3.is_empty() else "✗ pendiente")
	label_pistas.text = texto

func _intentar_abrir() -> void:
	var intento: String = input_clave.text.strip_edges()
	if GameManager.intentar_contrasena_final(intento):
		_mostrar_diario()
	else:
		label_error.text = "Contraseña incorrecta. Revisa tus pistas."
		label_error.add_theme_color_override("font_color", Color(1.0, 0.5, 0.5, 1.0))

func _mostrar_diario() -> void:
	panel_lock.visible   = false
	panel_diario.visible = true
