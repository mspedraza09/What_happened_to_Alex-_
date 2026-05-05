extends "res://game/scripts/apps/BaseApp.gd"

# App Red Social — se desbloquea en Fase 2+
# Estructura real de la escena: AppContainer/TopBar/BackButton
#                               AppContainer/Feed/PostList/...
# El jugador reconstruye el apodo censurado y obtiene la pista 3.

@onready var btn_confirmar  := $AppContainer/Feed/PostList/Post3/PostContent3/BtnConfirmar
@onready var input_apodo    := $AppContainer/Feed/PostList/Post3/PostContent3/InputApodo
@onready var label_resultado := $AppContainer/Feed/PostList/Post3/PostContent3/LabelResultado

const APODO_CORRECTO := "ALEX"
const PISTA_3        := "EX"

func _on_app_ready() -> void:
	# BackButton ya es manejado por BaseApp via _find_back_button()
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
