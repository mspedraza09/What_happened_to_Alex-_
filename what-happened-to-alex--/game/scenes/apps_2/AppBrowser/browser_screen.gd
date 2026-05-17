extends Control
@onready var history_panel = $HistoryPanel01
# Ruta exacta basada en tu nuevo árbol: MarginContaineMenu/ColorMenu/Menu/Search
@onready var btn_search_menu = $MarginContaineMenu/Menu/Setting

# Base de datos simulada del historial
var lista_historial: Array = [
	{"titulo": "Cómo borrar el historial de búsqueda", "hora": "15:32", "tipo": "none"},
	{"titulo": "¿Qué le pasó a Alex? noticias recientes", "hora": "14:15", "tipo": "active"},
	{"titulo": "Precio de teclados mecánicos Colombia", "hora": "11:04", "tipo": "none"},
	{"titulo": "Mejores cafeterías para estudiar cerca", "hora": "08:20", "tipo": "none"}
]

func _ready() -> void:
	history_panel.hide() # El historial empieza oculto al iniciar la app
	
	# Conectamos el clic de la lupa del menú inferior
	if btn_search_menu:
		btn_search_menu.pressed.connect(_on_search_menu_pressed)

func _on_search_menu_pressed() -> void:
	# Pasamos los datos al panel y lo hacemos visible
	history_panel.cargar_historial(lista_historial)
	history_panel.show()

# Función que se ejecuta al clickear el historial correcto de Alex
func abrir_pantalla_web() -> void:
	history_panel.hide()
	print("¡Trigger funcionando con éxito! Cambiando a la pantalla de la web...")
	# Aquí meteremos la escena de la web en la siguiente fase de tu diseño


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
