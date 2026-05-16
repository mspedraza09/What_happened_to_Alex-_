extends ColorRect
@onready var nombre_busquedad = $VBoxContainer/HBoxContainer/Name
@onready var tiempo_busquedad = $VBoxContainer/HBoxContainer/Time
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	nombre_busquedad.text = datos["nombres"]
	tiempo_busquedad.text = datos["tiempo"]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
