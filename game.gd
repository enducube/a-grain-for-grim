extends Node2D

var second_counter = 0
var time_minutes = 0
var time_hours = 7
var time_days = 0
var daystate = "day"
var inter = 0
var standlerp = 0

var grim_camera_focus = false

onready var crowspawn = preload("res://crow.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	$CanvasLayer/pause/volume.value = Global.volume
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var cancrowspawn = false
	for i in Global.inventory:
		if Global.inventory[i]>0 and !(i in ["mill-o-tron", "scythe+", "fertilizer", "crow cash"]):
			cancrowspawn = true
	if Input.is_action_just_pressed("one"):
		Global.held_item = 0
	if Input.is_action_just_pressed("two"):
		Global.held_item = 1
	if Input.is_action_just_pressed("three"):
		Global.held_item = 2
	match Global.slots[2]:
		"":
			$CanvasLayer/gui/slot3/TextureRect.texture = null
		"wheat seed":
			$CanvasLayer/gui/slot3/TextureRect.texture = preload("res://assets/crops/wheat/1.png")
		"barley seed":
			$CanvasLayer/gui/slot3/TextureRect.texture = preload("res://assets/crops/barley/1.png")
		"oat seed":
			$CanvasLayer/gui/slot3/TextureRect.texture = preload("res://assets/crops/oats/1.png")
		"rice seed":
			$CanvasLayer/gui/slot3/TextureRect.texture = preload("res://assets/crops/rice/1.png")
	
	
	second_counter += delta * Global.time_scale
	$AudioStreamPlayer.pitch_scale = clamp(Global.time_scale,0.01,1)
	
	if second_counter >= 1:
		time_minutes += 10
		second_counter = 0
	if time_minutes>=60:
		time_hours += 1
		time_minutes = 0
		if time_hours % 3 == 0 and cancrowspawn:
			var c = crowspawn.instance()
			add_child(c)
	if time_hours>=24:
		time_hours = 0
		time_days += 1
		if time_days % 3 == 0:
			Global.time_going = false
			Global.grim_reaper = true
			grim_camera_focus = true
			print("grim reaper")
			$CanvasLayer/inventory.visible = false
			$player.state = "free"
			
	# stand opening and closing times
	if time_hours == 12:
		$CanvasLayer/notification.notify("shops opened at the top!")
	if time_hours>=12 and time_hours<18:
		standlerp += 0.01
		$stands.visible = true
	else:
		$stands.visible = false
		standlerp -= 0.01
	standlerp = clamp(standlerp,0,1)
	$stands.position.y = lerp(-64,0,standlerp)
	
	if time_hours>=18:
		daystate = "night"
	if time_hours>=6 and time_hours<18:
		daystate = "day"
		
	$CanvasLayer/gui/time_and_cash.bbcode_text = "[right]"
	$CanvasLayer/gui/time_and_cash.bbcode_text += str(time_hours)+":"+str(time_minutes)
	if time_minutes<10:
		$CanvasLayer/gui/time_and_cash.bbcode_text += "0"
	$CanvasLayer/gui/time_and_cash.bbcode_text += "\n"+daystate+" "+str(time_days)+"\n"
	$CanvasLayer/gui/time_and_cash.bbcode_text += "[color=#FFD700]$"+str(Global.money)+"[/color]"
	
	if grim_camera_focus:
		$Camera2D.position.x = clamp($grim_reaper.position.x,0+$Camera2D.get_viewport_rect().size.x/2,384-$Camera2D.get_viewport_rect().size.x/2)
		$Camera2D.position.y = clamp($grim_reaper.position.y,0+$Camera2D.get_viewport_rect().size.y/2,384-$Camera2D.get_viewport_rect().size.y/2)
	else:
		$Camera2D.position.x = clamp($player.position.x,0+$Camera2D.get_viewport_rect().size.x/2,384-$Camera2D.get_viewport_rect().size.x/2)
		$Camera2D.position.y = clamp($player.position.y,0+$Camera2D.get_viewport_rect().size.y/2,384-$Camera2D.get_viewport_rect().size.y/2)
	
	if Input.is_action_just_pressed("inventory"):
		$CanvasLayer/inventory.visible = not $CanvasLayer/inventory.visible
	if Input.is_action_just_pressed("pause") and !$CanvasLayer/inventory.visible and !$CanvasLayer/selling_menu.visible:
		pass # pause game
	if Input.is_action_just_pressed("pause") and $CanvasLayer/inventory.visible:
		$CanvasLayer/inventory.visible = false
	if Input.is_action_just_pressed("pause") and $CanvasLayer/selling_menu.visible:
		$CanvasLayer/selling_menu.visible = false
	if daystate == "night":
		inter += delta/6
	if daystate == "day":
		inter -= delta/6
	inter = clamp(inter,0,1)
	$CanvasModulate.color = lerp(Color(1,1,1),Color(0.5,0.5,0.8),inter)
	
	
func _on_close_pressed(): # close inventory
	$CanvasLayer/inventory.visible = false


func _on_selling_close_pressed():
	$CanvasLayer/selling_menu.visible = false


func _on_sell_pressed():
	if not $CanvasLayer/inventory.visible:
		$CanvasLayer/selling_menu.show()
		$CanvasLayer/upgrades.visible = false


func _on_closeupgrad_pressed():
	$CanvasLayer/upgrades.visible = false



func _on_magic_pressed():
	if not $CanvasLayer/upgrades.visible:
		$CanvasLayer/upgrades.show()
		$CanvasLayer/selling_menu.visible = false


func _on_volume_value_changed(value):
	Global.volume = value


func _on_menu_pressed():
	get_tree().change_scene("res://menu.tscn")
