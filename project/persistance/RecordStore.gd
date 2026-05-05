class_name RecordStore
extends RefCounted

var filepath: String

func _init(path: String) -> void:
	filepath = path
	if not FileAccess.file_exists(filepath):
		var f = FileAccess.open(filepath, FileAccess.WRITE)
		f.close()

func append(record_type: String, key: String, data: Variant) -> int:
	var record: Dictionary = {
		"type": record_type,
		"key": key,
		"data": data
	}
	var line: String = JSON.stringify(record) + "\n"
	var f = FileAccess.open(filepath, FileAccess.READ_WRITE)
	f.seek_end()
	var offset: int = f.get_position()
	f.store_string(line)
	f.close()
	return offset

func read_at(offset: int) -> Variant:
	if not FileAccess.file_exists(filepath):
		return null
	var f = FileAccess.open(filepath, FileAccess.READ)
	f.seek(offset)
	var line: String = f.get_line()
	f.close()
	if line.is_empty():
		return null
	var result = JSON.parse_string(line)
	if result == null:
		return null
	return result

func iter_all() -> Array:
	var results: Array = []
	if not FileAccess.file_exists(filepath):
		return results
	var f = FileAccess.open(filepath, FileAccess.READ)
	while not f.eof_reached():
		var offset: int = f.get_position()
		var line: String = f.get_line()
		if line.is_empty():
			continue
		var result = JSON.parse_string(line)
		if result != null:
			results.append([offset, result])
	f.close()
	return results
