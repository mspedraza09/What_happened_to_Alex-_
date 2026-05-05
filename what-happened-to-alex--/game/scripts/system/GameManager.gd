extends Node

# ─────────────────────────────────────────────────────────────────────────────
# GameManager — Autoload singleton
# Gestiona el progreso del jugador usando el StorageEngine existente.
# No modifica la capa de persistencia; solo usa engine.save() y engine.get_data()
#
# Claves en el StorageEngine:
#   "progress:fase"                → int   (0–5)
#   "progress:pista1"              → String (letra/palabra encontrada)
#   "progress:pista2"              → String
#   "progress:pista3"              → String
#   "progress:diario_desbloqueado" → bool
# ─────────────────────────────────────────────────────────────────────────────

var engine: StorageEngine

# Emitida cuando el jugador avanza de fase (por ej. para que el menú refresque)
signal fase_cambiada(nueva_fase: int)

func _ready() -> void:
	engine = StorageEngine.new("user://save_data")

# ── Lectura de progreso ───────────────────────────────────────────────────────

func get_fase() -> int:
	var f = engine.get_data("progress:fase")
	if f == null:
		return 0
	return int(f)

func get_pista(numero: int) -> String:
	var p = engine.get_data("progress:pista%d" % numero)
	if p == null:
		return ""
	return str(p)

func is_diario_desbloqueado() -> bool:
	var d = engine.get_data("progress:diario_desbloqueado")
	if d == null:
		return false
	return bool(d)

# ── Escritura de progreso ─────────────────────────────────────────────────────

func set_fase(nueva_fase: int) -> void:
	engine.save("progress", "progress:fase", nueva_fase)
	fase_cambiada.emit(nueva_fase)

func set_pista(numero: int, valor: String) -> void:
	engine.save("progress", "progress:pista%d" % numero, valor)

func desbloquear_diario() -> void:
	engine.save("progress", "progress:diario_desbloqueado", true)

# ── Lógica de desbloqueo de apps ─────────────────────────────────────────────
# Devuelve true si la app está desbloqueada para la fase actual del jugador.
# Agregar aquí nuevas condiciones a medida que se diseñen más fases.

func is_app_desbloqueada(app_id: String) -> bool:
	var fase := get_fase()
	match app_id:
		"mensajes":   return true          # Siempre activa
		"archivos":   return true          # Siempre activa
		"galeria":    return true          # Siempre activa
		"buscador":   return true          # Siempre activa
		"redsocial":  return fase >= 2     # Se desbloquea al completar fase 1
		"notas":      return fase >= 2     # Se desbloquea al completar fase 1
		"diario":     return is_diario_desbloqueado()
	return false

# ── Verificación de contraseña final ─────────────────────────────────────────
# El jugador combina las 3 pistas para intentar abrir el Diario.
# Ajustar la lógica de combinación cuando se diseñen las pistas exactas.

func intentar_contrasena_final(intento: String) -> bool:
	var p1 := get_pista(1)
	var p2 := get_pista(2)
	var p3 := get_pista(3)
	# Combinación: concatenación directa de las 3 pistas (ajustar según diseño)
	var clave_correcta: String = (p1 + p2 + p3).to_lower().strip_edges()
	if intento.to_lower().strip_edges() == clave_correcta:
		desbloquear_diario()
		return true
	return false
