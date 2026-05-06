extends RefCounted
class_name HashTable

const DEFAULT_BUCKETS := 64
const MAX_LOAD_FACTOR := 0.7


class HashEntry:
	var key: String
	var offset: int
	var next: HashEntry

	func _init(p_key: String, p_offset: int) -> void:
		key = p_key
		offset = p_offset
		next = null


var buckets: Array
var bucket_count: int
var size: int = 0


func _init(p_bucket_count: int = DEFAULT_BUCKETS) -> void:
	bucket_count = p_bucket_count

	buckets = []
	buckets.resize(bucket_count)
	buckets.fill(null)


func _hash(key: String) -> int:
	return abs(key.hash()) % bucket_count


func put(key: String, offset: int) -> void:
	var idx: int = _hash(key)

	# bucket vacío
	if buckets[idx] == null:
		buckets[idx] = HashEntry.new(key, offset)
		size += 1

	else:
		var current = buckets[idx]

		while current != null:

			# clave existente -> actualizar offset
			if current.key == key:
				current.offset = offset
				return

			# insertar al final
			if current.next == null:
				current.next = HashEntry.new(key, offset)
				size += 1
				break

			current = current.next

	# verificar factor de carga
	var load_factor: float = float(size) / float(bucket_count)

	if load_factor > MAX_LOAD_FACTOR:
		_rehash(bucket_count * 2)


func _rehash(new_bucket_count: int) -> void:

	# guardar buckets anteriores
	var old_buckets = buckets

	# crear nueva tabla
	bucket_count = new_bucket_count

	buckets = []
	buckets.resize(bucket_count)
	buckets.fill(null)

	# reiniciar size
	size = 0

	# reinsertar todos los elementos
	for bucket in old_buckets:

		var current = bucket

		while current != null:

			put(current.key, current.offset)

			current = current.next


func get_offset(key: String) -> int:
	var idx: int = _hash(key)

	var current = buckets[idx]

	while current != null:

		if current.key == key:
			return current.offset

		current = current.next

	return -1


func delete(key: String) -> void:
	var idx: int = _hash(key)

	var current = buckets[idx]
	var prev = null

	while current != null:

		if current.key == key:

			# eliminar cabeza
			if prev == null:
				buckets[idx] = current.next

			# eliminar nodo intermedio/final
			else:
				prev.next = current.next

			size -= 1
			return

		prev = current
		current = current.next


func items() -> Array:
	var result: Array = []

	for bucket in buckets:

		var current = bucket

		while current != null:

			result.append([current.key, current.offset])

			current = current.next

	return result


func stats() -> Dictionary:

	var collisions: int = 0

	for bucket in buckets:

		if bucket != null and bucket.next != null:
			collisions += 1

	return {
		"size": size,
		"bucket_count": bucket_count,
		"load_factor": float(size) / float(bucket_count),
		"collisions": collisions
	}
