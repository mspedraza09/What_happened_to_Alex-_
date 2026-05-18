extends Control
# We load the saved scene of the single diary item
var item_scene = preload("res://game/scenes/apps_2/AppDiary/ItemsDiary.tscn")

# We connect to the VBoxContainer where all items will be stacked
@onready var list_container = $ScrollContainer/VBoxContainer

var entries_data = [
	{"num": "17", "month": "Apr", "year": "2026", "title": "Día uno"},
	{"num": "18", "month": "Apr", "year": "2026", "title": "Todo se complica"},
	{"num": "19", "month": "Apr", "year": "2026", "title": "El mensaje extraño"},
	{"num": "20", "month": "Apr", "year": "2026", "title": "Sombras en la ventana"},
	{"num": "21", "month": "Apr", "year": "2026", "title": "Ya no confío en nadie"},
	{"num": "22", "month": "Apr", "year": "2026", "title": "La caja de madera"},
	{"num": "23", "month": "Apr", "year": "2026", "title": "Un viejo mapa"},
	{"num": "24", "month": "Apr", "year": "2026", "title": "Siguiendo las pistas"},
	{"num": "25", "month": "Apr", "year": "2026", "title": "El encuentro en el muelle"},
	{"num": "26", "month": "Apr", "year": "2026", "title": "La verdad oculta"}
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	create_diary_list()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func create_diary_list():
	# We use a 'for' loop to go through each entry in our data list
	for entry in entries_data:
		# 1. We create a new physical copy (instance) of the item scene
		var new_item = item_scene.instantiate()
		
		# 2. We search inside this new item for the specific labels and change their text
		new_item.get_node("HBoxContainer/DateContainer/Num").text = entry["num"]
		new_item.get_node("HBoxContainer/DateContainer/Month").text = entry["month"]
		new_item.get_node("HBoxContainer/DateContainer/Year").text = entry["year"]
		new_item.get_node("HBoxContainer/Label").text = entry["title"]
		
		# 3. We add this configured item into the VBoxContainer so it shows on screen
		list_container.add_child(new_item)
