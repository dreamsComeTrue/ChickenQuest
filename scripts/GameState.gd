extends Node


func _unhandled_key_input(event):
	if event.pressed:
		match event.scancode:
			KEY_F12:
				OS.window_fullscreen = !OS.window_fullscreen
