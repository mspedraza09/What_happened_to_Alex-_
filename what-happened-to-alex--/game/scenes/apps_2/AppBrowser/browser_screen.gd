extends Control
@onready var history_panel = $HistoryPanel01
@onready var search_menu_btn = $MarginContaineMenu/Menu/Setting
@onready var web_screen = $WebScreen

# Base de datos simulada del historial
var search_history: Array = [
	{"titulo": "Cómo borrar el historial de búsqueda", "hora": "15:32", "tipo": "none"},
	{"titulo": "¿Qué le pasó a Alex? noticias recientes", "hora": "14:15", "tipo": "active"},
	{"titulo": "Precio de teclados mecánicos Colombia", "hora": "11:04", "tipo": "none"},
	{"titulo": "Mejores cafeterías para estudiar cerca", "hora": "08:20", "tipo": "none"}
]

func _ready() -> void:
	history_panel.hide() 
	web_screen.hide() # Nos aseguramos de que la web no se vea al iniciar
	
	if search_menu_btn:
		search_menu_btn.pressed.connect(_on_search_menu_pressed)

func _on_search_menu_pressed() -> void:
	# 3. Llamamos a la función (que ahora está en inglés) y pasamos los datos
	history_panel.load_history(search_history)
	history_panel.show()

# Función que se ejecuta al clickear el historial correcto de Alex
func open_web_screen() -> void:
	history_panel.hide()
	
	print("Trigger successful! Opening the web screen...")
	web_screen.show() # Mostramos la página de los psicólogos

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
