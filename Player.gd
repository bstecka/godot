extends KinematicBody2D


const SPEED = 60
const GRAVITY = 10
const JUMP_POWER = -250
const FLOOR = Vector2(0, -1)

var velocity = Vector2()

var on_ground = false

var is_attacking = false

var is_dead = false

var fireball_power = 1


func _physics_process(delta):
	
	if is_dead == false:
	
		if Input.is_action_pressed("ui_right"):
			if is_on_floor() == false:
				velocity.x = SPEED
		elif Input.is_action_pressed("ui_left"):
			if is_on_floor() == false:
				velocity.x = -SPEED
		else:
			velocity.x = 0
			if on_ground == true:
				$AnimatedSprite.play("idle")
			
		if Input.is_action_pressed("ui_accept"):
			if is_attacking == false:
				if on_ground == true:
					velocity.y = JUMP_POWER
					on_ground = false
	
		if Input.is_action_just_pressed("ui_focus_next") && is_attacking == false:
			if is_on_floor():
				velocity.x = 0
			is_attacking = true
			$AnimatedSprite.play("attack")
			var fireball = null
			if fireball_power == 1:
				fireball = FIREBALL.instance()
			elif fireball_power == 2:
				fireball = FIREBALLRED.instance()
			if sign($Position2D.position.x) == 1:
				fireball.set_fireball_direction(1)
			else:
				fireball.set_fireball_direction(-1)
			get_parent().add_child(fireball)
			fireball.position = $Position2D.global_position
	
		velocity.y += GRAVITY
	
		if is_on_floor():
			if on_ground == false:
				is_attacking = false
			on_ground = true
		else:
			if is_attacking == false:
				on_ground = false
				if velocity.y < 0:
					$AnimatedSprite.play("jump")
				else:
					$AnimatedSprite.play("fall")
	
		velocity = move_and_slide(velocity, FLOOR)
		
		if get_slide_count() > 0:
			for i in range(get_slide_count()):
				if "Enemy" in get_slide_collision(i).collider.name:
					dead()
					
		
	

func dead():
	is_dead = true
	velocity = Vector2(0, 0)
	$AnimatedSprite.play("dead")
	$CollisionShape2D.disabled = true
	$Timer.start()
	

func _on_AnimatedSprite_animation_finished():
	is_attacking = false


func _on_Timer_timeout():
	get_tree().change_scene("TitleScreen.tscn")
	

func crown_power_up():
	fireball_power = 2
