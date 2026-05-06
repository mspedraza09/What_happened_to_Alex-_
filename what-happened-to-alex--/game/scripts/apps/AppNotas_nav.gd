extends Control

const MENU_PATH := "res://game/scenes/menu/MenuPrincipal.tscn"

func _ready() -> void:
	$AppContainer/TopBar/BackButton.pressed.connect(_volver)

func _volver() -> void:
	get_tree().change_scene_to_file(MENU_PATH)
