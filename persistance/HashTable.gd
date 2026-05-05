class_name HashTable
extends RefCounted

var buckets: Array
var bucket_count: int
var size: int
var collisions: int

func _init(initial_capacity: int = 64) -> void:
	bucket_count = max(initial_capacity, 1)
	buckets = []
	for i in range(bucket_count):
		buckets.append(null)
	size = 0
	collisions = 0

func _hash(key: String) -> int:
	return abs(key.hash()) % bucket_count

func put(key: String, offset: int) -> void:
	var index: int = _hash(key)
	var entry = buckets[index]
	if entry == null:
		buckets[index] = HashEntry.new(key, offset)
		size += 1
		return
	var current = entry
	while current != null:
		if current.key == key:
			current.offset = offset
			return
		if current.next == null:
			break
		current = current.next
	current.next = HashEntry.new(key, offset)
	collisions += 1
	size += 1

func get_offset(key: String) -> int:
	var entry = buckets[_hash(key)]
	while entry != null:
		if entry.key == key:
			return entry.offset
		entry = entry.next
	return -1

func delete(key: String) -> bool:
	var index: int = _hash(key)
	var entry = buckets[index]
	if entry == null:
		return false
	if entry.key == key:
		buckets[index] = entry.next
		size -= 1
		return true
	var previous = entry
	entry = entry.next
	while entry != null:
		if entry.key == key:
			previous.next = entry.next
			size -= 1
			return true
		previous = entry
		entry = entry.next
	return false

func items() -> Array:
	var result: Array = []
	for bucket in buckets:
		var entry = bucket
		while entry != null:
			result.append([entry.key, entry.offset])
			entry = entry.next
	return result

func stats() -> Dictionary:
	return {
		"size": size,
		"load_factor": float(size) / bucket_count,
		"collisions": collisions
	}

class HashEntry:
	extends RefCounted
	var key: String
	var offset: int
	var next: HashEntry

	func _init(k: String, o: int) -> void:
		key = k
		offset = o
		next = null
