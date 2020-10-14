extends Control

func _ready() -> void:
	Signals.connect("eggs_changed", self, "_on_eggs_changed")
	Signals.connect("life_changed", self, "_on_life_changed")

func _on_eggs_changed(eggs_left : int) -> void:
	for i in range(0, 4):
		var egg_icon_name = "Egg" + str(i + 1)
		var node = get_node("CanvasLayer/Control/HBoxContainer/" + egg_icon_name)
		if i < eggs_left:
			node.visible = true
		else:
			node.visible = false

func _on_life_changed(value: float) -> void:
	$CanvasLayer/Control/NinePatchRect/TextureProgress.value = value
