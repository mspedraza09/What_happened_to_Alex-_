extends Control
@onready var vbox: VBoxContainer = $ScrollContainer/VBoxContainer
@onready var btn_back: Button = $TopTitle/HBoxContainer/ButtonBack

# Exportamos una variable para asignarle la escena del botón desde el inspector
@export var item_escena: PackedScene

func _ready() -> void:
	# Conectamos el botón de volver atrás
	if btn_back:
		btn_back.pressed.connect(hide)

func load_history(search_list: Array) -> void:
	# Verificación de seguridad por si olvidaste asignar la escena en el inspector
	if not item_escena:
		push_error("¡Error! No has asignado la escena 'HistorialItems' en el Inspector de HistoryPanel01.")
		return

	# 1. Limpiamos absolutamente todos los clones anteriores
	for hijo in vbox.get_children():
		hijo.queue_free()
	
	# 2. Instanciamos los nuevos ítems basados en el diccionario
	for datos in search_list:
		# Creamos una copia nueva de la escena guardada
		var nuevo_item = item_escena.instantiate()
		# Lo agregamos al contenedor vertical
		vbox.add_child(nuevo_item)
		
		# Configuramos sus textos y el tipo de acción (active / none)
		if nuevo_item.has_method("configurar_item"):
			nuevo_item.configurar_item(datos["titulo"], datos["hora"], datos["tipo"])

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
