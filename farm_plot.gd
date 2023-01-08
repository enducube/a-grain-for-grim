extends Node2D


var grow_state = 0
export var grow_time = 60
var hydrated = false
export var crop_type = ""
# wheat, barley, oats, rice
export(Array) var crop_state_images
var plottex = preload("res://assets/plot.png")
var plothydtex = preload("res://assets/plot_hydrated.png")
var time = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	match crop_type:
		"wheat":
			pass
		"barley":
			pass
		"oats":
			pass
		"rice":
			pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if hydrated:
		$plot.texture_normal = plothydtex
	else:
		$plot.texture_normal = plottex
	if crop_type != "":
		self.add_to_group("crop")
		$crop.show()
		time += delta*Global.time_scale
		if time>=grow_time/2:
			time=grow_time/2
			if grow_state<2 and hydrated:
				grow_state += 1
				$crop/Sprite.texture = crop_state_images[grow_state]
				hydrated = false
				time = 0
			
	else:
		if self in get_tree().get_nodes_in_group("crop"):
			self.remove_from_group("crop")
		$crop.hide()
		time = 0
		grow_state = 0 
	if grow_state == 2:
		$crop.monitoring = true
	else:
		$crop.monitoring = false

func _on_crop_area_entered(area):
	if grow_state == 2 and area in get_tree().get_nodes_in_group("scythe"):
		if area in get_tree().get_nodes_in_group("player_scythe"):
			Global.inventory[crop_type] += 1
			get_node("/root/game/player/sfx/harvest").play()
			self.crop_type = ""
			self.grow_state = 0
		else:
			get_node("/root/game/player/sfx/harvest").play()
			self.crop_type = ""
			self.grow_state = 0


func _on_plot_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		match event.button_index:
			BUTTON_LEFT:
				if Global.held_item == 1:
					hydrated = true
					get_node("/root/game/player/sfx/water").play()
				if Global.held_item == 2 and self.crop_type == "":
					match Global.slots[2]:
						"":
							pass
						"wheat seed":
							grow_time = 144 * 2 * (1-(0.05*Global.inventory["fertilizer"]))
							crop_type = "wheat"
							crop_state_images = [
								preload("res://assets/crops/wheat/1.png"),
								preload("res://assets/crops/wheat/2.png"),
								preload("res://assets/crops/wheat/3.png")
							]
						"barley seed":
							grow_time = 144 * 1 * (1-(0.05*Global.inventory["fertilizer"]))
							crop_type = "barley"
							crop_state_images = [
								preload("res://assets/crops/wheat/1.png"),
								preload("res://assets/crops/wheat/2.png"),
								preload("res://assets/crops/wheat/3.png")
							]
						"oat seed":
							grow_time = 144 * 0.5 * (1-(0.05*Global.inventory["fertilizer"]))
							crop_type = "oats"
							crop_state_images = [
								preload("res://assets/crops/oats/1.png"),
								preload("res://assets/crops/oats/2.png"),
								preload("res://assets/crops/oats/3.png")
							]
						"rice seed":
							grow_time = 144 * 2 * (1-(0.05*Global.inventory["fertilizer"]))
							crop_type = "rice"
							crop_state_images = [
								preload("res://assets/crops/rice/1.png"),
								preload("res://assets/crops/rice/2.png"),
								preload("res://assets/crops/rice/3.png")
							]
					if Global.slots[2] != "":
						Global.inventory[Global.slots[2]] -= 1
						if Global.inventory[Global.slots[2]]<1:
							Global.slots[2] = ""
							Global.held_item = 0
						$crop/Sprite.texture = crop_state_images[0]



