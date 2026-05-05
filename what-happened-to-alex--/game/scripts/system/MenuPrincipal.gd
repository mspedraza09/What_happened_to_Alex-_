extends Control

const SCENES: Dictionary = {
	"AppMensajes":  "res://game/scenes/apps/AppMensjae.tscn",
	"AppRedSocial": "res://game/scenes/apps/AppRedSocial.tscn",
	"AppGaleria":   "res://game/scenes/apps/AppGaleria.tscn",
}

func _ready() -> void:
	$PhoneRoot/ScreenArea/AppsScroll/AppsList/AppMensajes.pressed.connect(
		func(): _open_app("AppMensajes")
	)
	$PhoneRoot/ScreenArea/AppsScroll/AppsList/AppRedSocial.pressed.connect(
		func(): _open_app("AppRedSocial")
	)
	$PhoneRoot/ScreenArea/AppsScroll/AppsList/AppGaleria.pressed.connect(
		func(): _open_app("AppGaleria")
	)

func _open_app(app_name: String) -> void:
	var path: String = SCENES.get(app_name, "")
	if path.is_empty():
		return
	if get_tree().change_scene_to_file(path) != OK:
		push_error("No se pudo cargar: " + path)
