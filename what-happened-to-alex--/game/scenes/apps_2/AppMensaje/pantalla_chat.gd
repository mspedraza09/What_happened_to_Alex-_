extends Control
@export var burbuja_escena: PackedScene = preload("res://game/scenes/apps_2/AppMensaje/panel_container.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func cargar_conversacion(nombre_contacto: String):
	$VBoxContainer/Header/NombreUsuario.text = nombre_contacto
	
	# Limpiar mensajes viejos
	for child in %ListaMensajes.get_children():
		child.queue_free()
	
	# Sacar datos de Global
	var datos = Global.chats_data[nombre_contacto]
	
	for msg in datos["mensajes"]:
		var nueva_burbuja = burbuja_escena.instantiate()
		%ListaMensajes.add_child(nueva_burbuja)
		
		# Llamamos a la función que escribimos arriba
		var es_mio = (msg["remitente"] == "jugador")
		nueva_burbuja.configurar(msg["texto"], es_mio)
		
func _on_boton_volver_pressed():
	self.hide()
	get_parent().get_node("Container").show()
	get_parent().get_node("Background").show()
	get_parent().get_node("ColorRect").show()
	
