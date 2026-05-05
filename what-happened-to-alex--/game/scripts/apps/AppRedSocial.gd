extends "res://game/scripts/apps/BaseApp.gd"

# App Red Social — se desbloquea en Fase 2+
# Narrativa: comentarios de ciberacoso con apodo censurado hacia Alex
# El jugador debe reconstruir el apodo y obtener la pista 3.
#
# El apodo aparece varias veces con letras faltantes: "_ L E X"
# El jugador completa la palabra "ALEX" y se guarda como pista 3.

@onready var panel_apodo    := $PhoneRoot/ScreenArea/AppContent/Feed/PanelApodo
@onready var input_apodo    := $PhoneRoot/ScreenArea/AppContent/Feed/PanelApodo/InputApodo
@onready var btn_confirmar  := $PhoneRoot/ScreenArea/AppContent/Feed/PanelApodo/BtnConfirmar
@onready var label_resultado := $PhoneRoot/ScreenArea/AppContent/Feed/PanelApodo/LabelResultado

const APODO_CORRECTO := "ALEX"
const PISTA_3        := "EX"   # Fragmento que aporta a la contraseña final

func _on_app_ready() -> void:
	if btn_confirmar:
		btn_confirmar.pressed.connect(_verificar_apodo)

func _verificar_apodo() -> void:
	var intento: String = input_apodo.text.strip_edges().to_upper()
	if intento == APODO_CORRECTO:
		label_resultado.text = "Encontraste el apodo. Guárdalo bien."
		label_resultado.add_theme_color_override("font_color", Color(0.4, 1.0, 0.5, 1.0))
		if GameManager.get_pista(3).is_empty():
			GameManager.set_pista(3, PISTA_3)
		if GameManager.get_fase() < 3:
			GameManager.set_fase(3)
	else:
		label_resultado.text = "No es correcto. Observa los comentarios con más cuidado."
		label_resultado.add_theme_color_override("font_color", Color(1.0, 0.5, 0.5, 1.0))
