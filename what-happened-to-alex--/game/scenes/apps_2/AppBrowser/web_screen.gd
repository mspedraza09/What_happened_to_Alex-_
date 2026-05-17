extends Control
@onready var profile_list: VBoxContainer = $ScrollContainer/ProfileList
@onready var back_button: Button = $TopBar/BackButton
@export var psychologist_item_scene: PackedScene

var directory_data: Array = [
	{
		"nombre": "Dr. Carlos Mendoza",
		"telefono": "+57 300 123 4567",
		"descripcion": "Especialista en terapia cognitivo-conductual, manejo de ansiedad y estrés académico en jóvenes universitarios.",
		"foto_ruta": "res://game/assets/Folder Vector Icon, Folder Icons, Folder Clipart, Folder Icon PNG and Vector with Transparent Background for Free Download.jpeg", # Deja vacío "" si usarás texturas por defecto
		"clave": false
	},
	{
		"nombre": "Dra. Elena Rossi",
		"telefono": "+57 315 987 6543",
		"descripcion": "Atención integral en psicología clínica. Especialista en dinámicas familiares, resolución de conflictos y apoyo en crisis emocionales.",
		"foto_ruta": "res://game/assets/Folder Vector Icon, Folder Icons, Folder Clipart, Folder Icon PNG and Vector with Transparent Background for Free Download.jpeg",
		"clave": false
	},
	{
		"nombre": "Dr. Humberto Gómez",
		"telefono": "+57 311 555 0192",
		"descripcion": "Psicólogo clínico y forense. Especialista en trauma digital, ciberacoso y manejo de crisis de identidad en entornos virtuales.",
		"foto_ruta": "res://game/assets/Folder Vector Icon, Folder Icons, Folder Clipart, Folder Icon PNG and Vector with Transparent Background for Free Download.jpeg",
		"clave": true # Este es el contacto clave para investigar el caso de Alex
	}
]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if back_button:
		back_button.pressed.connect(hide)
	
	generate_directory()

func generate_directory() -> void:
	# Limpiamos perfiles viejos
	for child in profile_list.get_children():
		child.queue_free()
		
	if not psychologist_item_scene:
		return
		
	# Instanciamos los perfiles
	for data in directory_data:
		var new_profile = psychologist_item_scene.instantiate()
		profile_list.add_child(new_profile)
		
		if new_profile.has_method("setup_profile"):
			new_profile.setup_profile(data)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
