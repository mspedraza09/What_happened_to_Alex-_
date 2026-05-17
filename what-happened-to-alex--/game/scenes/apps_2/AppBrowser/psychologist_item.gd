extends PanelContainer
@onready var name_label: Label = $MarginContainer/HBoxContainer/TextContainer/NameLabel
@onready var phone_label: Label = $MarginContainer/HBoxContainer/TextContainer/PhoneLabel
@onready var description_label: Label = $MarginContainer/HBoxContainer/TextContainer/DescriptionLabel
@onready var profile_photo: TextureRect = $MarginContainer/HBoxContainer/ProfilePhoto
var is_key_clue: bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func setup_profile(data: Dictionary) -> void:
	name_label.text = data["nombre"]
	phone_label.text = data["telefono"]
	description_label.text = data["descripcion"]
	is_key_clue = data["clave"]
	
	if data["foto_ruta"] != "":
		profile_photo.texture = load(data["foto_ruta"])
