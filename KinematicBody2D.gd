extends KinematicBody2D

const UP = Vector2(0, -1)
const GRAVITY = 20
const SPEED = 200
const JUMP_HEIGHT = -500

var motion = Vector2()

var is_dead = false

var is_attacking = false

var has_key = false

var entered_door = false

func _physics_process(delta):
	motion.y += GRAVITY
	
	if is_dead == false && is_attacking == false && entered_door == false:
		if Input.is_action_pressed("ui_right"):
			motion.x = SPEED
			$Sprite.flip_h = false
			$Sprite.play("Run")
		elif Input.is_action_pressed("ui_left"):
			motion.x = -SPEED
			$Sprite.flip_h = true
			$Sprite.play("Run")
		else:
			$Sprite.play("Idle")
			motion.x = 0
			
		if is_on_floor():
			if Input.is_action_just_pressed("ui_up"):
				motion.y = JUMP_HEIGHT
		else:
			$Sprite.play("Jump")
			
		motion = move_and_slide(motion, UP)
		
		if get_global_position().y > 600:
			get_tree().change_scene("res://GameOver.tscn")
					
		if Input.is_key_pressed(KEY_E):
			is_attacking = true
			$Sprite.play("Attack")
		
		if is_attacking == false:
			if get_slide_count() > 0:
				for i in range(get_slide_count()):
					if "Enemy" in get_slide_collision(i).collider.name:
						die()
					if "Key" in get_slide_collision(i).collider.name:
						get_slide_collision(i).collider.disappear()
						has_key = true
	
func die():
	if is_attacking == false:
		is_dead = true
		motion = Vector2(0, 0)
		$Sprite.play("Dead")
		
func enter_door():
	entered_door = true
	$Sprite.play("Turn")

func _on_Sprite_animation_finished():
	if is_dead:
		get_tree().change_scene("res://GameOver.tscn")
	if is_attacking:
		is_attacking = false
	if entered_door:
		get_tree().change_scene("res://GameOver.tscn")

func _on_Door_body_entered(body):
	print("DOOR AREA")
	if has_key:
		enter_door()
	pass # Replace with function body.
