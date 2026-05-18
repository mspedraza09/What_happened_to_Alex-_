extends Button
signal item_opened(data)

var entry_data = {}

func _on_click_button_pressed():
	# When clicked, we send the signal with the data
	item_opened.emit(entry_data)
	print("Entró")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
