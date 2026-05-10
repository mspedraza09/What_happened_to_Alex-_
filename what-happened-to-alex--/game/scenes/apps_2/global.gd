extends Node
# Variable que controlará en qué nivel va el jugador (1, 2 o 3)
var nivel_actual: int = 2

# Base de datos con todas las conversaciones
# Cada contacto tiene un "nivel_desbloqueo" y una lista de "mensajes"
var chats_data: Dictionary = {
	"Alex": {
		"nivel_desbloqueo": 1,
		"mensajes": [
			{"remitente": "Alex", "texto": "¡Hola! ¿Estás ahí?"},
			{"remitente": "jugador", "texto": "Sí, ¿qué pasó?"},
			{"remitente": "Alex", "texto": "Necesito contarte algo importante sobre lo que pasó ayer."}
		]
	},
	"Amigo Hacker": {
		"nivel_desbloqueo": 2,
		"mensajes": [
			{"remitente": "Amigo Hacker", "texto": "Encontré un rastro digital sospechoso."},
			{"remitente": "jugador", "texto": "¿Estás seguro? Pásame las capturas."}
		]
	},
	"Desconocido": {
		"nivel_desbloqueo": 3,
		"mensajes": [
			{"remitente": "Desconocido", "texto": "Sé lo que estás investigando. Deja de buscar."}
		]
	}
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
