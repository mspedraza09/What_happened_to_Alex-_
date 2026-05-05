extends Control

# ─────────────────────────────────────────────────────────────────────────────
# BaseApp — Script base para todas las apps del teléfono.
# Maneja el botón "atrás" y provee acceso al GameManager.
# Cada app puede extender esta clase o simplemente usar este script
# si no necesita lógica adicional.
# ─────────────────────────────────────────────────────────────────────────────

const MENU_PATH := "res://game/scenes/menu/MenuPrincipal.tscn"

func _ready() -> void:
	var back_btn := _find_back_button()
	if back_btn:
		back_btn.pressed.connect(_volver_al_menu)
	_on_app_ready()

# Sobrescribir en apps hijas para lógica específica
func _on_app_ready() -> void:
	pass

func _volver_al_menu() -> void:
	if get_tree().change_scene_to_file(MENU_PATH) != OK:
		push_error("No se pudo volver al menú.")

func _find_back_button() -> Button:
	# Busca recursivamente un nodo llamado "BackButton"
	return _search_node(self, "BackButton") as Button

func _search_node(node: Node, name: String) -> Node:
	if node.name == name:
		return node
	for child in node.get_children():
		var found := _search_node(child, name)
		if found:
			return found
	return null
