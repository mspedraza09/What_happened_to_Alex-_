extends Control
@export var nombre_usuario: String = "Usuario"
@export var ultimo_mensaje: String = "Hola..."
@export var foto_perfil: Texture2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%nombre_usuario.text = nombre_usuario
	if foto_perfil:
		%FotoRect.texture = foto_perfil
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func preparar_chat(datos: ChatDatos):
	%nombre_usuario.text = datos.nombre_usuario
	%FotoPerfil.texture = datos.foto_perfil
	
	# Limpiar mensajes anteriores
	for hijo in %ContenedorMensajes.get_children():
		hijo.queue_free()
	
	# Crear las burbujas de mensaje
	for msg in datos.mensajes:
		var burbuja = Label.new() # O una escena de "Burbuja" más bonita
		burbuja.text = msg["text"]
		if msg["sender"] == "Alex":
			burbuja.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		%ContenedorMensajes.add_child(burbuja)
