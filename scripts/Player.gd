extends KinematicBody2D

var move_speed : float = 150.0
var _move_dir_mask : int = 0
var _move_vec := Vector2.ZERO
var _last_move_mask := 0
var _action_eat : bool = false
var _action_eat_counter : float = 0.0

onready var egg_scene = preload("res://scenes/Egg.tscn")

const MOVE_UP_MASK = 1
const MOVE_RIGHT_MASK = 1 << 2
const MOVE_DOWN_MASK = 1 << 3
const MOVE_LEFT_MASK = 1 << 4

func _physics_process(delta):
	if _action_eat:
		_action_eat_counter += delta
		
		if _action_eat_counter >= 0.4:
			_launch_egg()
			_action_eat_counter = 0.0
						
		if _move_dir_mask > 0:
			if is_bit_enabled(_move_dir_mask, MOVE_UP_MASK):
				$AnimatedSprite.play("EatUp")
			elif is_bit_enabled(_move_dir_mask, MOVE_RIGHT_MASK):
				$AnimatedSprite.play("EatRight")
			elif is_bit_enabled(_move_dir_mask, MOVE_DOWN_MASK):
				$AnimatedSprite.play("EatDown")
			elif is_bit_enabled(_move_dir_mask, MOVE_LEFT_MASK):
				$AnimatedSprite.play("EatLeft")
		else:
			if _last_move_mask == MOVE_UP_MASK:
				$AnimatedSprite.play("EatUp")
			elif _last_move_mask == MOVE_RIGHT_MASK:
				$AnimatedSprite.play("EatRight")
			elif _last_move_mask == MOVE_DOWN_MASK:
				$AnimatedSprite.play("EatDown")
			elif _last_move_mask == MOVE_LEFT_MASK:
				$AnimatedSprite.play("EatLeft")
				
	if _move_dir_mask > 0 and not _action_eat:
		var move : Vector2 = _move_vec.normalized() * move_speed
		self.move_and_slide(move)
	else:
		_move_vec = Vector2.ZERO

func _unhandled_key_input(event):
	if event.pressed:
		match event.scancode:
			KEY_SPACE:
				if _action_eat == false:
					_launch_egg()

				_action_eat = true
			KEY_LEFT, KEY_A:
				_move_dir_mask = enable_bit(_move_dir_mask, MOVE_LEFT_MASK)
			KEY_RIGHT, KEY_D:
				_move_dir_mask = enable_bit(_move_dir_mask, MOVE_RIGHT_MASK)
			KEY_UP, KEY_W:
				_move_dir_mask = enable_bit(_move_dir_mask, MOVE_UP_MASK)
			KEY_DOWN, KEY_S:
				_move_dir_mask = enable_bit(_move_dir_mask, MOVE_DOWN_MASK)
	else:
		if (event.scancode == KEY_UP or event.scancode == KEY_W) and is_bit_enabled(_move_dir_mask, MOVE_UP_MASK):
				_move_vec.y = 0
				_move_dir_mask = disable_bit(_move_dir_mask, MOVE_UP_MASK)
				_last_move_mask = MOVE_UP_MASK
		if (event.scancode == KEY_RIGHT or event.scancode == KEY_D) and is_bit_enabled(_move_dir_mask, MOVE_RIGHT_MASK):
				_move_vec.x = 0
				_move_dir_mask = disable_bit(_move_dir_mask, MOVE_RIGHT_MASK)
				_last_move_mask = MOVE_RIGHT_MASK
		if (event.scancode == KEY_DOWN or event.scancode == KEY_S) and is_bit_enabled(_move_dir_mask, MOVE_DOWN_MASK):
				_move_vec.y = 0
				_move_dir_mask = disable_bit(_move_dir_mask, MOVE_DOWN_MASK)
				_last_move_mask = MOVE_DOWN_MASK
		if (event.scancode == KEY_LEFT or event.scancode == KEY_A) and is_bit_enabled(_move_dir_mask, MOVE_LEFT_MASK):
				_move_vec.x = 0
				_move_dir_mask = disable_bit(_move_dir_mask, MOVE_LEFT_MASK)
				_last_move_mask = MOVE_LEFT_MASK
		if event.scancode == KEY_SPACE:
			_action_eat = false
			_action_eat_counter = 0.0
			yield(get_tree().create_timer(0.3), "timeout")
			
	if not _action_eat:
		if is_bit_enabled(_move_dir_mask, MOVE_UP_MASK):
			$AnimatedSprite.play("MoveUp")
			_move_vec.y = -1
		elif is_bit_enabled(_move_dir_mask, MOVE_RIGHT_MASK):
			$AnimatedSprite.play("MoveRight")
			_move_vec.x = 1
		elif is_bit_enabled(_move_dir_mask, MOVE_DOWN_MASK):
			$AnimatedSprite.play("MoveDown")
			_move_vec.y = 1
		elif is_bit_enabled(_move_dir_mask, MOVE_LEFT_MASK):
			$AnimatedSprite.play("MoveLeft")
			_move_vec.x = -1
		else:
			match _last_move_mask:
				MOVE_UP_MASK:
					$AnimatedSprite.play("IdleUp")
				MOVE_RIGHT_MASK:
					$AnimatedSprite.play("IdleRight")
				MOVE_DOWN_MASK:
					$AnimatedSprite.play("IdleDown")
				MOVE_LEFT_MASK:
					$AnimatedSprite.play("IdleLeft")
		
func is_bit_enabled(mask, index):
	return mask & (1 << index) != 0
			
func enable_bit(mask, index):
	return mask | (1 << index)

func disable_bit(mask, index):
	return mask & ~(1 << index)

func _launch_egg() -> void:
	var egg = egg_scene.instance()
	get_parent().add_child(egg)
	
	if _move_dir_mask > 0:
		if is_bit_enabled(_move_dir_mask, MOVE_UP_MASK):
			egg.global_position = $EggDownSpawnPoint.global_position
			egg.z_index = 2
		elif is_bit_enabled(_move_dir_mask, MOVE_RIGHT_MASK):
			egg.global_position = $EggLeftSpawnPoint.global_position
		elif is_bit_enabled(_move_dir_mask, MOVE_DOWN_MASK):
			egg.global_position = $EggUpSpawnPoint.global_position
		elif is_bit_enabled(_move_dir_mask, MOVE_LEFT_MASK):
			egg.global_position = $EggRightSpawnPoint.global_position
	else:
		if _last_move_mask == MOVE_UP_MASK:
			egg.global_position = $EggDownSpawnPoint.global_position
			egg.z_index = 2
		elif _last_move_mask == MOVE_RIGHT_MASK:
			egg.global_position = $EggLeftSpawnPoint.global_position
		elif _last_move_mask == MOVE_DOWN_MASK:
			egg.global_position = $EggUpSpawnPoint.global_position
		elif _last_move_mask == MOVE_LEFT_MASK:
			egg.global_position = $EggRightSpawnPoint.global_position
				
	egg.get_node("AnimationPlayer").play("launch")
