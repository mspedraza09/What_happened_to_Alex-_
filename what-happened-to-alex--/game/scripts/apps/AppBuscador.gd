extends "res://game/scripts/apps/BaseApp.gd"

# App Buscador — disponible desde el inicio (Fase 0+)
# Fase 0-1: muestra búsquedas relacionadas con criptografía
# Fase 2+:  aparece sección de psicólogos; uno tiene mensaje codificado (pista 2)
#
# El jugador debe aplicar cifrado César para descifrar el mensaje del perfil anómalo
# y obtener la pista 2, guardada en "progress:pista2" via GameManager.

@onready var seccion_cripto    := $PhoneRoot/ScreenArea/AppContent/SeccionCripto
@onready var seccion_psico     := $PhoneRoot/ScreenArea/AppContent/SeccionPsico
@onready var btn_descifrar     := $PhoneRoot/ScreenArea/AppContent/SeccionPsico/BtnDescifrar
@onready var input_descifrado  := $PhoneRoot/ScreenArea/AppContent/SeccionPsico/InputDescifrado
@onready var label_resultado   := $PhoneRoot/ScreenArea/AppContent/SeccionPsico/LabelResultado

# Pista 2: mensaje codificado en el perfil anómalo del psicólogo (César +3)
const MENSAJE_CIFRADO_PSICO    := "OHB"    # Cifrado de "LEX" (parte del nombre)
const PISTA_2                  := "L"      # Letra que el jugador extrae del mensaje

func _on_app_ready() -> void:
	var fase := GameManager.get_fase()
	seccion_psico.visible = fase >= 2

	if btn_descifrar:
		btn_descifrar.pressed.connect(_verificar_pista2)

func _verificar_pista2() -> void:
	var intento: String = input_descifrado.text.strip_edges().to_upper()
	# El jugador debe haber desplazado OHB → LEX correctamente
	if intento == "LEX":
		label_resultado.text = "¡Encontraste el mensaje oculto!"
		label_resultado.add_theme_color_override("font_color", Color(0.4, 1.0, 0.5, 1.0))
		if GameManager.get_pista(2).is_empty():
			GameManager.set_pista(2, PISTA_2)
		if GameManager.get_fase() < 2:
			GameManager.set_fase(2)
	else:
		label_resultado.text = "No es correcto. Usa lo que aprendiste en el archivo."
		label_resultado.add_theme_color_override("font_color", Color(1.0, 0.5, 0.5, 1.0))
