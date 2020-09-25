extends KinematicBody2D

var speed = 40
var path : = PoolVector2Array()
var enemy_type : int = 0

func _ready():
	randomize()
	enemy_type = randi() % 2 + 1
	$AnimatedSprite.playing = true

func _process(delta):
	# Calculate the movement distance for this frame
	var distance_to_walk = speed
	
	# Move the player along the path until he has run out of movement or the path ends.
	while distance_to_walk > 0 and path.size() > 0:
		$AnimatedSprite.play(str(enemy_type) + "_Attack")
		var distance_to_next_point = position.distance_to(path[0])
		if distance_to_walk <= distance_to_next_point:
			# The player does not have enough movement left to get to the next point.
			var delta_move : Vector2 = (position.direction_to(path[0]) * 100)
			self.move_and_slide(delta_move)
		else:
			# The player get to the next point
			#position = path[0]
			path.remove(0)
		# Update the distance to walk
		distance_to_walk -= distance_to_next_point

	if path.empty():
		$AnimatedSprite.play(str(enemy_type) + "_Idle")
