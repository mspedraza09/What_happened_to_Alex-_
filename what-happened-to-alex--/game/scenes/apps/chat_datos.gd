extends Resource
class_name ChatDatos

@export var nombre_usuario: String
@export var foto_perfil: Texture2D
@export var nivel: int # 1, 2 o 3
@export var mensajes: Array[Dictionary] # [{ "sender": "Alex", "text": "Hola" }, ...]
