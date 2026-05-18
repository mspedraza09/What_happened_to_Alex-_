extends Control
const FILE_ITEM_SCENE = preload("res://game/scenes/apps_2/AppArchivos/FileItem.tscn")
# Lista de archivos (Base de datos local de la app)
var lista_archivos = [
	{
		"nombre": "nota_recreo.txt",
		"titulo_doc": "EL PAPEL DEL CASILLERO", # ¡Nuevo campo!
		"contenido": "Hoy en el recreo alguien me dejó un papel raro en el casillero...",
		"fecha": "10/05/2026"
	},
	{
		"nombre": "lista_pendientes.txt",
		"titulo_doc": "COSAS POR HACER ESTA SEMANA", # ¡Nuevo campo!
		"contenido": "- Estudiar para el examen de algoritmos\n- Hablar con mamá sobre el grupo de chat",
		"fecha": "12/05/2026"
	}
]

@onready var v_box_archivos = $MainContainer/ListLayout/VBoxArchivos
@onready var list_layout = $MainContainer/ListLayout
@onready var file_content = $MainContainer/FileContent

# ¡Atención aquí! Actualizamos las rutas porque metimos un VBoxContainer
@onready var title_display = $MainContainer/FileContent/DocScroll/VBoxContainer/TitleDisplay
@onready var text_display = $MainContainer/FileContent/DocScroll/VBoxContainer/TextDisplay
@onready var btn_back = $TopBar/BtnBack

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	file_content.hide()
	btn_back.hide()
	limpiar_lista()
	cargar_archivos()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
func limpiar_lista():
	for child in v_box_archivos.get_children():
		child.queue_free()

func cargar_archivos():
	for datos in lista_archivos:
		var nuevo_item = FILE_ITEM_SCENE.instantiate()
		v_box_archivos.add_child(nuevo_item)
		
		# Se usa la función que acabamos de crear en el script del FileItem
		nuevo_item.set_datos(datos)
		
		#Se conecta la señal de clic
		nuevo_item.pressed.connect(_on_archivo_presionado.bind(datos))

func _on_archivo_presionado(datos):
	list_layout.hide()
	file_content.show()
	btn_back.show()
	title_display.text = datos["titulo_doc"]
	text_display.text = datos["contenido"]
	

func _on_btn_back_pressed():
	file_content.hide()
	list_layout.show()
	btn_back.hide()
