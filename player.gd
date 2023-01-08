extends KinematicBody2D


var vel = Vector2()
var state = "free"
# state can be free, inventory, or planting

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var mouse_pos = get_global_mouse_position()
	var mouse_direction = self.position.direction_to(mouse_pos).normalized()
	var mouse_angle = self.position.angle_to_point(mouse_pos)
	
	if get_node("../CanvasLayer/inventory").visible:
		state = "inventory"
	else:
		state = "free"
	if state == "free":
		if mouse_pos.y<position.y:
			$Sprite.texture = preload("res://assets/farmer_up.png")
		else:
			$Sprite.texture = preload("res://assets/farmer_down.png")
	$scythe.hide()
	$watercan.hide()
	$seed.hide()
	match Global.held_item:
		0:
			$scythe.show()
			if not $scythe/AnimationPlayer.is_playing():
				$scythe.rotation = 0
			if Input.is_action_just_pressed("scythe_button"):
				$scythe/AnimationPlayer.play("swing")
			$scythe.rotation += mouse_angle + PI/2
			$scythe/CollisionShape2D.shape.extents.x = 4 + Global.inventory["scythe+"]
		1:
			$watercan.show()
			$watercan.rotation = mouse_angle+PI
			$watercan.flip_v = mouse_pos.x<self.position.x
			$watercan.position = mouse_direction.normalized() * 16
		2:
			match Global.slots[2]:
				"":
					$seed.texture = null
				"wheat seed":
					$seed.texture = preload("res://assets/crops/wheat/1.png")
				"barley seed":
					$seed.texture = preload("res://assets/crops/barley/1.png")
				"oat seed":
					$seed.texture = preload("res://assets/crops/oats/1.png")
				"rice seed":
					$seed.texture = preload("res://assets/crops/rice/1.png")
			$seed.show()
			$seed.rotation = mouse_angle+PI
			$seed.flip_v = mouse_pos.x<self.position.x
			$seed.position = mouse_direction.normalized() * 16

func _physics_process(delta):
	vel = Vector2()
	if state == "free":
		if Input.is_action_pressed("move_down"):
			
			vel.y += 2/(delta/Global.time_scale)
		if Input.is_action_pressed("move_up"):
			vel.y -= 2/(delta/Global.time_scale)
		if Input.is_action_pressed("move_right"):
			vel.x += 2/(delta/Global.time_scale)
		if Input.is_action_pressed("move_left"):
			vel.x -= 2/(delta/Global.time_scale)
	move_and_slide(vel)


func _on_scythereaper_body_entered(body):
	get_tree().change_scene("res://lose_screen.tscn")
	pass # Replace with function body.
