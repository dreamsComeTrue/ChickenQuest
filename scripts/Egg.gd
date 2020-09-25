extends Node2D

func _ready():
	$AnimatedSprite.playing = true
	$Timer.wait_time = rand_range(1.5, 2.5)
	$Timer.start()

func _on_Timer_timeout():
	$AnimationPlayer.play("explode")
	Signals.emit_signal("shake_camera")
