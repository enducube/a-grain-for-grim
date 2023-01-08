extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var dir = 0
var target = null
var spawn = Vector2()
var stole = ""
# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	position.x = 160*((randi()%3) - 1)
	position.y = 160*((randi()%3) - 1)
	spawn = position
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var cansteal = false
	if !stole:
		for i in Global.inventory:
			if Global.inventory[i]>0 and !(i in ["mill-o-tron", "scythe+", "fertilizer", "crow cash"]):
				cansteal = true
		if cansteal:
			if target == null:
				target = get_node("../player")
			if target != null:
				position += position.direction_to(target.global_position).normalized()*(0.02/delta) * Global.time_scale
			$Sprite.rotation = position.angle_to_point(target.global_position) + PI
		else:
			position += position.direction_to(spawn).normalized()*(0.02/delta) * Global.time_scale
			$Sprite.rotation = position.angle_to_point(spawn) + PI
			if position.distance_to(spawn) <8:
				queue_free()
	else:
		position += position.direction_to(spawn).normalized()*(0.02/delta) * Global.time_scale
		$Sprite.rotation = position.angle_to_point(spawn) + PI
		if position.distance_to(spawn) <8:
			queue_free()
	


func _on_crow_area_entered(area):
	if area in get_tree().get_nodes_in_group("player_scythe"):
		Global.money += Global.inventory["crow cash"]
		var c = preload("res://crowsplosion.tscn").instance()
		c.position = self.position
		get_parent().add_child(c)
		c.emitting = true
		c.get_node("AudioStreamPlayer2D").play()
		if stole:
			Global.inventory[stole] +=1
		self.queue_free()
		
			


func _on_crow_body_entered(body):
	var cansteal = false
	for i in Global.inventory:
		if Global.inventory[i]>0 and !(i in ["mill-o-tron", "scythe+", "fertilizer", "crow cash"]):
			cansteal = true
	if body.name == "player" and cansteal:
		var list_of_stealables = []
		for i in Global.inventory:
			if Global.inventory[i]>0 and !(i in ["mill-o-tron", "scythe+", "fertilizer", "crow cash"]):
				list_of_stealables.append(i)
		var thing = list_of_stealables[randi() % len(list_of_stealables)]
		get_parent().get_node("CanvasLayer/notification").notify("a crow stole "+thing)
		Global.inventory[thing] -= 1
		stole = thing
