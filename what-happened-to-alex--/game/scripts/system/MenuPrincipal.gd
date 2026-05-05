extends Control

# ─────────────────────────────────────────────────────────────────────────────
# MenuPrincipal — Menú scrolleable del teléfono de Alex
# Lee el progreso actual del GameManager (que a su vez lee del StorageEngine)
# y activa/bloquea cada app según la fase del jugador.
# ─────────────────────────────────────────────────────────────────────────────

const ESCENAS: Dictionary = {
	"mensajes":  "res://game/scenes/apps/AppMensajes.tscn",
	"redsocial": "res://game/scenes/apps/AppRedSocial.tscn",
	"notas":     "res://game/scenes/apps/AppNotas.tscn",
	"buscador":  "res://game/scenes/apps/AppBuscador.tscn",
	"archivos":  "res://game/scenes/apps/AppArchivos.tscn",
	"galeria":   "res://game/scenes/apps/AppGaleria.tscn",
	"diario":    "res://game/scenes/apps/AppDiario.tscn",
}

# Nodos de botón de cada app (se asignan en _ready)
var _botones: Dictionary = {}

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

	# Conectar señal del GameManager para refrescar si la fase cambia
	GameManager.fase_cambiada.connect(_refrescar_apps)

	_refrescar_apps(GameManager.get_fase())

	# Conectar cada botón
	for app_id in _botones.keys():
		var btn: Button = _botones[app_id]
		btn.pressed.connect(_abrir_app.bind(app_id))

func _refrescar_apps(fase: int) -> void:
	for app_id in _botones.keys():
		var btn: Button         = _botones[app_id]
		var desbloqueada: bool  = GameManager.is_app_desbloqueada(app_id)
		btn.disabled = not desbloqueada

		# Actualizar icono de candado visible en el nodo OverlayLock de cada app
		var overlay_path := "OverlayLock"
		if btn.has_node(overlay_path):
			btn.get_node(overlay_path).visible = not desbloqueada

func _abrir_app(app_id: String) -> void:
	if not GameManager.is_app_desbloqueada(app_id):
		return
	var path: String = ESCENAS.get(app_id, "")
	if path.is_empty():
		return
	if get_tree().change_scene_to_file(path) != OK:
		push_error("No se pudo cargar la escena: " + path)
