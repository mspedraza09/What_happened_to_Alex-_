extends Node

# ─────────────────────────────────────────────────────────────────────────────
# GameManager — Autoload singleton
# Claves en el StorageEngine:
#   "session:usuario_actual"       → String (username del jugador activo)
#   "progress:fase"                → int   (0–5)
#   "progress:pista1/2/3"          → String
#   "progress:diario_desbloqueado" → bool
#   "progress:pin_resuelto"        → bool
# ─────────────────────────────────────────────────────────────────────────────

var engine: StorageEngine

signal fase_cambiada(nueva_fase: int)

func _ready() -> void:
	engine = StorageEngine.new("user://save_data")

# ── Sesión ────────────────────────────────────────────────────────────────────

func get_usuario_activo() -> String:
	var u = engine.get_data("session:usuario_actual")
	if u == null:
		return ""
	return str(u)

func iniciar_sesion(username: String) -> void:
	engine.save("session", "session:usuario_actual", username)

func cerrar_sesion() -> void:
	engine.delete("session:usuario_actual")

func hay_sesion_activa() -> bool:
	return get_usuario_activo() != ""

# ── Progreso ──────────────────────────────────────────────────────────────────

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

func is_pin_resuelto() -> bool:
	var p = engine.get_data("progress:pin_resuelto")
	if p == null:
		return false
	return bool(p)

# ── Escritura ─────────────────────────────────────────────────────────────────

func set_fase(nueva_fase: int) -> void:
	engine.save("progress", "progress:fase", nueva_fase)
	fase_cambiada.emit(nueva_fase)

func set_pista(numero: int, valor: String) -> void:
	engine.save("progress", "progress:pista%d" % numero, valor)

func desbloquear_diario() -> void:
	engine.save("progress", "progress:diario_desbloqueado", true)

# ── Desbloqueo de apps ────────────────────────────────────────────────────────

func is_app_desbloqueada(app_id: String) -> bool:
	var fase := get_fase()
	match app_id:
		"mensajes":  return true
		"archivos":  return true
		"galeria":   return true
		"buscador":  return true
		"redsocial": return true
		"notas":     return fase >= 2
		"diario":    return is_diario_desbloqueado()
	return false

# ── Contraseña final ──────────────────────────────────────────────────────────

func intentar_contrasena_final(intento: String) -> bool:
	var clave := (get_pista(1) + get_pista(2) + get_pista(3)).to_lower().strip_edges()
	if intento.to_lower().strip_edges() == clave:
		desbloquear_diario()
		return true
	return false
