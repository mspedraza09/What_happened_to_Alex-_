class_name StorageEngine
extends RefCounted

var record_store: RecordStore
var index_store: IndexStore
var hash_table: HashTable

func _init(data_dir: String = "user://save_data") -> void:
	DirAccess.make_dir_recursive_absolute(data_dir)
	record_store = RecordStore.new(data_dir + "/data.log")
	index_store  = IndexStore.new(data_dir + "/index.bin")
	hash_table   = HashTable.new()
	if not index_store.load(hash_table):
		var recovery = Recovery.new(record_store, index_store)
		recovery.rebuild(hash_table)

func save(record_type: String, key: String, data: Variant) -> void:
	var offset: int = record_store.append(record_type, key, data)
	hash_table.put(key, offset)
	index_store.save(hash_table)

func get_data(key: String) -> Variant:
	var offset: int = hash_table.get_offset(key)
	if offset == -1:
		return null
	var record = record_store.read_at(offset)
	if record == null:
		return null
	return record.get("data", null)

func delete(key: String) -> bool:
	var offset: int = hash_table.get_offset(key)
	if offset != -1:
		record_store.append("delete", key, null)
		var removed: bool = hash_table.delete(key)
		if removed:
			index_store.save(hash_table)
		return removed
	return false

func stats() -> Dictionary:
	return hash_table.stats()

func _hash_password(password: String) -> String:
	var ctx = HashingContext.new()
	ctx.start(HashingContext.HASH_SHA256)
	ctx.update(password.to_utf8_buffer())
	var digest = ctx.finish()
	return digest.hex_encode()

func register_user(username: String, password: String) -> bool:
	username = username.strip_edges()
	if username.is_empty() or password.is_empty():
		return false
	var key: String = "user:%s" % username
	if get_data(key) != null:
		return false
	save("user", key, {
		"password": _hash_password(password),
		"created_at": Time.get_unix_time_from_system()
	})
	return true

func authenticate_user(username: String, password: String) -> bool:
	username = username.strip_edges()
	if username.is_empty() or password.is_empty():
		return false
	var key: String = "user:%s" % username
	var stored = get_data(key)
	if stored == null:
		return false
	return stored.get("password", "") == _hash_password(password)
