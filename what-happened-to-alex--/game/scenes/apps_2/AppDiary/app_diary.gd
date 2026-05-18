extends Control
# We load the saved scene of the single diary item
var item_scene = preload("res://game/scenes/apps_2/AppDiary/ItemsDiary.tscn")

# We connect to the VBoxContainer where all items will be stacked
@onready var list_container = $ScrollContainer/VBoxContainer

# Variables for the reading page
@onready var reading_page = $ReadingPage
@onready var page_title = $ReadingPage/PageTitle
@onready var page_content = $ReadingPage/PageContent

var entries_data = [
	{
		"num": "17", "month": "Apr", "year": "2026", "title": "Día uno", 
		"content": "Hoy encontré este diario viejo. Decidí empezar a escribir porque las cosas se sienten extrañas últimamente."
	},
	{
		"num": "18", "month": "Apr", "year": "2026", "title": "Todo se complica", 
		"content": "Alguien movió mis cosas en la habitación. Estoy seguro de que dejé la llave sobre la mesa, pero apareció en el suelo."
	},
	{
		"num": "19", "month": "Apr", "year": "2026", "title": "El mensaje extraño", 
		"content": "Recibí un texto de un número desconocido. Solo decía: 'No vayas al muelle esta noche'. ¿Cómo sabían que planeaba ir?"
	}
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	reading_page.visible = false
	create_diary_list()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func create_diary_list():
	for entry in entries_data:
		var new_item = item_scene.instantiate()
		
		# Set the texts in the list item
		new_item.get_node("HBoxContainer/DateContainer/Num").text = entry["num"]
		new_item.get_node("HBoxContainer/DateContainer/Month").text = entry["month"]
		new_item.get_node("HBoxContainer/DateContainer/Year").text = entry["year"]
		new_item.get_node("HBoxContainer/Label").text = entry["title"]
		
		# --- NEW: We pass the data to the item and connect the signal ---
		new_item.entry_data = entry
		new_item.item_opened.connect(_on_item_opened)
		
		list_container.add_child(new_item)
# This function runs when any diary item is clicked
func _on_item_opened(data):
	page_title.text = data["title"]
	page_content.text = data["content"]
	# We show the reading overlay
	reading_page.visible = true



func _on_back_button_pressed() -> void:
	# We hide the reading overlay to see the list again
	reading_page.visible = false
