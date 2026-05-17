extends Button
@export var name_search: String = "Nombre busquedad"
@export var time_search: String = "Fecha"
var action_type: String = "Active/None"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
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
		print("¡Clic en ítem Activo! Abriendo la web...")
		# Buscamos a BrowserScreen en la raíz para ejecutar el cambio de pantalla
		var browser = get_tree().current_scene
		if browser.has_method("abrir_pantalla_web"):
			browser.abrir_pantalla_web()
	else:
		print("Clic en ítem de relleno. No pasa nada.")
