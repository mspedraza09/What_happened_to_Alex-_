class_name Recovery
extends RefCounted

var record_store: RecordStore
var index_store: IndexStore

func _init(rs: RecordStore, ist: IndexStore) -> void:
	record_store = rs
	index_store = ist

func rebuild(hash_table: HashTable) -> int:
	var temp_list: Array = []
	for entry in record_store.iter_all():
		var offset: int = entry[0]
		var record: Dictionary = entry[1]
		var key: String = record.get("key", "")
		var record_type: String = record.get("type", "")
		if key.is_empty():
			continue
		var is_delete: bool = (record_type == "delete")
		var found: bool = false
		for i in range(temp_list.size()):
			if temp_list[i][0] == key:
				temp_list[i] = [key, offset, is_delete]
				found = true
				break
		if not found:
			temp_list.append([key, offset, is_delete])
	var count: int = 0
	for item in temp_list:
		if not item[2]:
			hash_table.put(item[0], item[1])
			count += 1
	index_store.save(hash_table)
	return count
