extends Node2D

var _ai_recalc_seconds : float = 1.0

func _ready():
	var particle_emitters : Array = get_tree().get_nodes_in_group("rain")
	for particle_emitter in particle_emitters:
		particle_emitter.emitting = true

	$YSort/TileMap/Player/Camera2D.limit_left = $LimitLeft.position.x

	_recalc_ai()

func _recalc_ai() -> void:
	var enemies : Array = get_tree().get_nodes_in_group("enemy")
	for enemy in enemies:
		var path = $Navigation2D.get_simple_path(enemy.global_position, $YSort/TileMap/Player.global_position)
		enemy.path = path

func _process(delta):
	if get_tree().get_frame() % int(60.0 * _ai_recalc_seconds) == 1:
		_recalc_ai()
