extends Control
@onready var profile_list: VBoxContainer = $ScrollContainer/ProfileList
@onready var back_button: Button = $TopBar/BackButton
@export var psychologist_item_scene: PackedScene

var directory_data: Array = [
	{
		"nombre": "Dr. Andrés Vargas",
		"telefono": "+57 310 234 5678",
		"descripcion": "Especialista en psicología clínica con enfoque humanista. Tratamiento de depresión, autoestima y acompañamiento en procesos de duelo en adolescentes.",
		"foto_ruta": "res://game/assets/Psicologo1.png",
		"clave": false
	},
	{
		"nombre": "Dra. Sofía Ramírez",
		"telefono": "+57 312 876 5432",
		"descripcion": "Psicóloga clínica enfocada en victimología digital. Amplia experiencia en casos de ciberacoso, trauma por redes sociales y suplantación de identidad en jóvenes.",
		"foto_ruta": "res://game/assets/psicologo2.png",
		"clave": false
	},
	{
		"nombre": "Dr. Javier Ospina",
		"telefono": "+57 315 345 6789",
		"descripcion": "Terapeuta sistémico familiar. Manejo de conflictos en el hogar, problemas de comunicación intrafamiliar y mediación entre padres e hijos.",
		"foto_ruta": "res://game/assets/psicologo4.png",
		"clave": false
	},
	{
		"nombre": "Dra. Laura Martínez",
		"telefono": "+57 8665826975",
		"descripcion": "Psicóloga educativa. Orientación vocacional, dificultades de aprendizaje y desarrollo de habilidades sociales en lenguajes ASCII",
		"foto_ruta": "res://game/assets/psicologo3.png",
		"clave": true # Este es el contacto clave para investigar el caso de Alex
	},
	{
		"nombre": "Dr. Santiago Castro",
		"telefono": "+57 317 456 7890",
		"descripcion": "Especialista en psicología conductual. Tratamiento de adicciones, control de impulsos y manejo de la ira en jóvenes adultos.",
		"foto_ruta":"res://game/assets/psicologo5.png",
		"clave": false
	},
	{
		"nombre": "Dra. Camila Rojas",
		"telefono": "+57 311 654 3210",
		"descripcion": "Psicoterapeuta con enfoque cognitivo-conductual. Intervención en trastornos de ansiedad, fobias y manejo extremo del estrés académico universitario.",
		"foto_ruta": "res://game/assets/psicologo6.png",
		"clave": false
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
