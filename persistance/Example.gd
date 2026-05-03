extends Node

func _ready() -> void:
	var engine = StorageEngine.new("user://save_data")

	engine.save("profile", "player:1", {"score": 5200})
	engine.save("settings", "settings:global", {"volume": 80})
	engine.save("leaderboard", "leaderboard:top", {"entries": [{"score": 5200, "name": "Player1"}]})

	var profile = engine.get_data("player:1")
	print("Score: ", profile["score"])

	var settings = engine.get_data("settings:global")
	print("Volumen: ", settings["volume"])

	var stats = engine.stats()
	print("Tabla hash - size: ", stats["size"],
		  " | load: ", stats["load_factor"],
		  " | colisiones: ", stats["collisions"])
