extends VBoxContainer
#Escena de chat
#const ESCENA_CHAT = "res://game/scenes/apps/pantalla_chat.tscn"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Recorremos todos los chats en el contenedor para conectar sus señales
	for chat in %VBoxContainer.get_children():
		if chat.has_signal("chat_seleccionado"):
			chat.connect("chat_seleccionado", _on_chat_abierto)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_chat_abierto(nombre: String) -> void:
	print("Abriendo chat con: ", nombre)
	# Cambiamos de escena
	get_tree().change_scene_to_file(ESCENA_CHAT)
