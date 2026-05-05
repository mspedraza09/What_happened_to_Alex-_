extends "res://game/scripts/apps/BaseApp.gd"

# App de Archivos — disponible desde el inicio (Fase 0+)
# Narrativa: contiene "entrega_criptografia.pdf" con letras resaltadas (pista 1)
# y un ejemplo de cifrado César (tutorial de mecánica)
#
# Al inspeccionar el archivo y encontrar la pista, se llama a _registrar_pista1()
# que guarda "progress:pista1" en el StorageEngine via GameManager y avanza a fase 1.

@onready var btn_abrir_archivo := $PhoneRoot/ScreenArea/AppContent/BtnAbrirArchivo
@onready var panel_archivo     := $PhoneRoot/ScreenArea/AppContent/PanelArchivo
@onready var panel_cifrado     := $PhoneRoot/ScreenArea/AppContent/PanelCifrado
@onready var btn_descifrar     := $PhoneRoot/ScreenArea/AppContent/PanelCifrado/BtnDescifrar
@onready var input_cifrado     := $PhoneRoot/ScreenArea/AppContent/PanelCifrado/InputCifrado
@onready var label_resultado   := $PhoneRoot/ScreenArea/AppContent/PanelCifrado/LabelResultado

# La letra resaltada que forma la pista 1 (definir junto al equipo de diseño)
const PISTA_1 := "A"
# Mensaje cifrado con César +3 para el tutorial (el jugador debe obtener "ALEX")
const MENSAJE_CIFRADO   := "DOHM"
const MENSAJE_DESCIFRADO := "ALEX"

func _on_app_ready() -> void:
	btn_abrir_archivo.pressed.connect(_mostrar_archivo)
	btn_descifrar.pressed.connect(_verificar_descifrado)
	panel_archivo.visible  = false
	panel_cifrado.visible  = false

func _mostrar_archivo() -> void:
	panel_archivo.visible = true
	# Guardar pista 1 al abrir el archivo (si no estaba guardada)
	if GameManager.get_pista(1).is_empty():
		GameManager.set_pista(1, PISTA_1)
	# Mostrar panel del tutorial de cifrado
	panel_cifrado.visible = true

func _verificar_descifrado() -> void:
	var intento: String = input_cifrado.text.strip_edges().to_upper()
	if intento == MENSAJE_DESCIFRADO:
		label_resultado.text = "¡Correcto! El mensaje decía: %s" % MENSAJE_DESCIFRADO
		label_resultado.add_theme_color_override("font_color", Color(0.4, 1.0, 0.5, 1.0))
		# Avanzar a fase 1 completada si aún no se hizo
		if GameManager.get_fase() < 1:
			GameManager.set_fase(1)
	else:
		label_resultado.text = "Incorrecto. Recuerda: desplaza cada letra 3 posiciones atrás."
		label_resultado.add_theme_color_override("font_color", Color(1.0, 0.5, 0.5, 1.0))
