extends Container
@export var nombre_app: String = "Aplicación"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%Label.text = nombre_app
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
