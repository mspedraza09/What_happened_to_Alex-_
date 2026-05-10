extends PanelContainer
func configurar(texto: String, es_jugador: bool):
	$Label.text = texto
	$Label.autowrap_mode = TextServer.AUTOWRAP_WORD
	
	if es_jugador:
		# Si es el jugador, a la derecha y azulito
		size_flags_horizontal = Control.SIZE_SHRINK_END
		self.modulate = Color(0.7, 0.9, 1.0) 
	else:
		# Si es el NPC, a la izquierda y blanco
		size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
		self.modulate = Color(1, 1, 1)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
