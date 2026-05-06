extends Node

# ─────────────────────────────────────────────────────────────────────────────
# GameManager — Autoload singleton
# Claves en el StorageEngine:
#   "session:usuario_actual"       → String (username del jugador activo)
#   "progress:{usuario}:fase"      → int   (0–5)
#   "progress:{usuario}:pista1/2/3" → String
#   "progress:{usuario}:diario_desbloqueado" → bool
#   "progress:{usuario}:pin_resuelto" → bool
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
	var usuario = get_usuario_activo()
	if usuario.is_empty():
		return 0
	var key = "progress:%s:fase" % usuario
	var f = engine.get_data(key)
	if f == null:
		return 0
	return int(f)

func get_pista(numero: int) -> String:
	var usuario = get_usuario_activo()
	if usuario.is_empty():
		return ""
	var key = "progress:%s:pista%d" % [usuario, numero]
	var p = engine.get_data(key)
	if p == null:
		return ""
	return str(p)

func is_diario_desbloqueado() -> bool:
	var usuario = get_usuario_activo()
	if usuario.is_empty():
		return false
	var key = "progress:%s:diario_desbloqueado" % usuario
	var d = engine.get_data(key)
	if d == null:
		return false
	return bool(d)

func is_pin_resuelto() -> bool:
	var usuario = get_usuario_activo()
	if usuario.is_empty():
		return false
	var key = "progress:%s:pin_resuelto" % usuario
	var p = engine.get_data(key)
	if p == null:
		return false
	return bool(p)

# ── Escritura ─────────────────────────────────────────────────────────────────

func set_fase(nueva_fase: int) -> void:
	var usuario = get_usuario_activo()
	if usuario.is_empty():
		return
	var key = "progress:%s:fase" % usuario
	engine.save("progress", key, nueva_fase)
	fase_cambiada.emit(nueva_fase)

func set_pista(numero: int, valor: String) -> void:
	var usuario = get_usuario_activo()
	if usuario.is_empty():
		return
	var key = "progress:%s:pista%d" % [usuario, numero]
	engine.save("progress", key, valor)

func desbloquear_diario() -> void:
	var usuario = get_usuario_activo()
	if usuario.is_empty():
		return
	var key = "progress:%s:diario_desbloqueado" % usuario
	engine.save("progress", key, true)

func set_pin_resuelto() -> void:
	var usuario = get_usuario_activo()
	if usuario.is_empty():
		return
	var key = "progress:%s:pin_resuelto" % usuario
	engine.save("progress", key, true)

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
