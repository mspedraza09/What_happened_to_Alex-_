extends VBoxContainer
@export var chat_item_scene: PackedScene = preload("res://game/scenes/apps_2/AppMensaje/items_chat.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	renderizar_lista_chats()

func renderizar_lista_chats():
	# Limpiamos la lista por si acaso
	for child in %VBoxContainer.get_children():
		if child.name != "nombre_app": 
			child.queue_free()
	
	# Recorremos la base de datos que creamos en Global
	for nombre in Global.chats_data.keys():
		var datos = Global.chats_data[nombre]
		
		# FILTRO: Solo instanciamos si el nivel es suficiente
		if Global.nivel_actual >= datos["nivel_desbloqueo"]:
			var nuevo_chat = chat_item_scene.instantiate()
			
			# Llenamos los datos del item
			nuevo_chat.usuario_chat = nombre
			# Tomamos el último mensaje de la lista para mostrarlo en la vista previa
			nuevo_chat.mensaje_ultimo = datos["mensajes"][-1]["texto"]
			
			%VBoxContainer.add_child(nuevo_chat)
			
			# Conectamos la señal para saber cuándo se hace click
			nuevo_chat.chat_seleccionado.connect(_on_chat_abierto)

func _on_chat_abierto(usuario: String):
	print("Abriendo chat con: ", usuario)
	# Aquí es donde llamaremos a la pantalla de la conversación (Paso 3)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
