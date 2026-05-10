extends Control
signal chat_seleccionado(usuario: String)
@export var usuario_chat: String = "Usuario"
@export var mensaje_ultimo: String = "Hola..."
@export var foto_usuario: Texture2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%usuario_chat.text = usuario_chat
	%mensaje_ultimo.text = mensaje_ultimo
	if foto_usuario:
		%foto_usuario.texture = foto_usuario


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	print("1. El botón fue presionado en el item de: ", usuario_chat)
	chat_seleccionado.emit(usuario_chat)
