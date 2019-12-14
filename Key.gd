extends KinematicBody2D

func _physics_process(delta):
	if get_slide_count() > 0:
		for i in range (get_slide_count()):
			if "KinematicBody2D" in get_slide_collision(i).collider.name:
					print("KEY COLLISION")
					
func disappear():
	self.hide()
	$CollisionShape2D.set_deferred("disabled", true)