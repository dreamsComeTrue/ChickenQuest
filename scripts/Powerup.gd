extends Node2D

var amount : float = 0.1

func _on_Area2D_body_entered(body: Node) -> void:
	if body is Player:
		Signals.emit_signal("modify_life", amount)
		self.queue_free()
