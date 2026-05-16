extends Button

# Definimos las referencias a los nodos internos
@onready var nombre_label = $HBoxContainer/InfoContainer/NombreLabel
@onready var fecha_label = $HBoxContainer/InfoContainer/FechaLabel
@onready var icono = $HBoxContainer/Icono

# Esta función la llamaremos desde el script principal para llenar los datos
func set_datos(datos: Dictionary):
	nombre_label.text = datos["nombre"]
	fecha_label.text = datos["fecha"]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
