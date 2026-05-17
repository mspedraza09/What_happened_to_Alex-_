extends Button
@export var name_search: String = "Nombre busquedad"
@export var time_search: String = "Fecha"
var action_type: String = "Active/None"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func configurar_item(titulo: String, hora: String, tipo: String) -> void:
	name_search = titulo
	time_search = hora
	action_type = tipo
	%Name.text = name_search
	%Time.text = time_search	
	
func _pressed() -> void:
	if action_type == "active":
		print("Click on active item! Opening web...")
		var browser = get_tree().current_scene
		print("Hola")
		# Buscamos y ejecutamos la función con su NUEVO nombre en inglés
		if browser.has_method("open_web_screen"):
			browser.open_web_screen()
	else:
		print("Regular item clicked. Nothing happens.")
