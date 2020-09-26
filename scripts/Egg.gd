extends Node2D

func _ready():
	$AnimatedSprite.playing = true
	$Timer.wait_time = rand_range(1.5, 2.5)
	$Timer.start()

func _on_Timer_timeout():
	$AnimationPlayer.play("explode")
	Signals.emit_signal("shake_camera")
		
func apply_damage() -> void:
	var bodies : Array = $Area2D.get_overlapping_bodies()
	
	for body in bodies:
		if body is Enemy:
			body.damage()
