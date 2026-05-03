class_name IndexStore
extends RefCounted

var filepath: String

func _init(path: String) -> void:
	filepath = path

func save(hash_table: HashTable) -> void:
	var pairs: Array = hash_table.items()
	var f = FileAccess.open(filepath, FileAccess.WRITE)
	f.store_string(JSON.stringify(pairs))
	f.close()

func load(hash_table: HashTable) -> bool:
	if not FileAccess.file_exists(filepath):
		return false
	var f = FileAccess.open(filepath, FileAccess.READ)
	var content: String = f.get_as_text()
	f.close()
	if content.is_empty():
		return false
	var pairs = JSON.parse_string(content)
	if pairs == null:
		return false
	for pair in pairs:
		if pair.size() >= 2:
			hash_table.put(pair[0], pair[1])
	return true

func exists() -> bool:
	return FileAccess.file_exists(filepath) and FileAccess.get_file_as_bytes(filepath).size() > 0
