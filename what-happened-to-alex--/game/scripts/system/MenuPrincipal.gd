extends Control

const LOGIN_PATH := "res://game/scenes/menu/Scenes.tscn"

const ESCENAS: Dictionary = {
	"mensajes":  "res://game/scenes/apps/AppMensajes.tscn",
	"redsocial": "res://game/scenes/apps/AppRedSocial.tscn",
	"notas":     "res://game/scenes/apps/AppNotas.tscn",
	"buscador":  "res://game/scenes/apps/AppBuscador.tscn",
	"archivos":  "res://game/scenes/apps/AppArchivos.tscn",
	"galeria":   "res://game/scenes/apps/AppGaleria.tscn",
	"diario":    "res://game/scenes/apps/AppDiario.tscn",
}

var _botones: Dictionary = {}

@onready var btn_salir      := $PhoneRoot/ScreenArea/NavBar/BtnSalir
@onready var label_usuario  := $PhoneRoot/ScreenArea/NavBar/LabelUsuario

func _ready() -> void:
	_botones = {
		"mensajes":  $PhoneRoot/ScreenArea/AppsScroll/AppsList/BtnMensajes,
		"redsocial": $PhoneRoot/ScreenArea/AppsScroll/AppsList/BtnRedSocial,
		"notas":     $PhoneRoot/ScreenArea/AppsScroll/AppsList/BtnNotas,
		"buscador":  $PhoneRoot/ScreenArea/AppsScroll/AppsList/BtnBuscador,
		"archivos":  $PhoneRoot/ScreenArea/AppsScroll/AppsList/BtnArchivos,
		"galeria":   $PhoneRoot/ScreenArea/AppsScroll/AppsList/BtnGaleria,
		"diario":    $PhoneRoot/ScreenArea/AppsScroll/AppsList/BtnDiario,
	}

	# Mostrar nombre del usuario activo
	var usuario: String = GameManager.get_usuario_activo()
	if usuario != "":
		label_usuario.text = "@" + usuario

	# Botón de cerrar sesión
	btn_salir.pressed.connect(_cerrar_sesion)

	# Conectar señal de fase
	GameManager.fase_cambiada.connect(_refrescar_apps)
	_refrescar_apps(GameManager.get_fase())

	# Conectar apps
	for app_id in _botones.keys():
		var btn: Button = _botones[app_id]
		btn.pressed.connect(_abrir_app.bind(app_id))

func _refrescar_apps(fase: int) -> void:
	for app_id in _botones.keys():
		var btn: Button        = _botones[app_id]
		var desbloqueada: bool = GameManager.is_app_desbloqueada(app_id)
		btn.disabled = not desbloqueada
		if btn.has_node("OverlayLock"):
			btn.get_node("OverlayLock").visible = not desbloqueada

func _abrir_app(app_id: String) -> void:
	if not GameManager.is_app_desbloqueada(app_id):
		return
	var path: String = ESCENAS.get(app_id, "")
	if path.is_empty():
		return
	if get_tree().change_scene_to_file(path) != OK:
		push_error("No se pudo cargar: " + path)

func _cerrar_sesion() -> void:
	GameManager.cerrar_sesion()
	get_tree().change_scene_to_file.call_deferred(LOGIN_PATH)
