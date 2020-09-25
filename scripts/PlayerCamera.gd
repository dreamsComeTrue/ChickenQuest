extends Camera2D

export var shake_power : float = 4.0
export var shake_time : float = 0.2
var is_shake : = false
var current_pos : Vector2
var elapsed_time :float = 0.0

func _ready() -> void:
	current_pos = offset
	Signals.connect("shake_camera", self, "shake")

func shake():
	if not is_shake:
		elapsed_time = 0.0
		is_shake = true

func _process(delta : float) -> void:
	if is_shake:
		_shake_process(delta)

func _shake_process(delta : float):
	if elapsed_time < shake_time:
		offset = Vector2(randf(), randf()) * shake_power
		elapsed_time += delta
	else:
		is_shake = false
		elapsed_time = 0
		offset = current_pos
