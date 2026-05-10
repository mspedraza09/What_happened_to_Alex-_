extends Control
@export var chat_item_scene: PackedScene = preload("res://game/scenes/apps_2/AppMensaje/items_chat.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Aseguramos que al empezar se vea la lista y no el chat
	$Container.show()
	$PantallaChat.hide()
	renderizar_lista_chats()

func renderizar_lista_chats():
	# Tu código de limpieza (ajusta la ruta al VBox si cambió)
	for child in %VBoxContainer.get_children():
		if child is not Label:
			child.queue_free()
	
	for nombre in Global.chats_data.keys():
		var datos = Global.chats_data[nombre]
		
		if Global.nivel_actual >= datos["nivel_desbloqueo"]:
			var nuevo_chat = chat_item_scene.instantiate()
			nuevo_chat.usuario_chat = nombre
			nuevo_chat.mensaje_ultimo = datos["mensajes"][-1]["texto"]
			
			%VBoxContainer.add_child(nuevo_chat)
			nuevo_chat.chat_seleccionado.connect(_on_chat_abierto)
			
func _on_chat_abierto(usuario: String):
	print("Abriendo chat con: ", usuario)
	
	# 1. Escondemos la lista
	$Container.hide()
	
	# 2. Mostramos la pantalla de chat y le pasamos los datos
	$PantallaChat.show()
	$PantallaChat.cargar_conversacion(usuario)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
