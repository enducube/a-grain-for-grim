extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	Global.money = 25
	Global.inventory = {
		"": 0,
		"barley": 0,
		"wheat": 0,
		"rice": 0,
		"oats": 0,
		"barley seed": 0,
		"wheat seed": 0,
		"rice seed": 0,
		"oat seed": 0,
		# upgrades
		"mill-o-tron": 0,
		"scythe+": 0,
		"fertilizer": 0,
		"crow cash": 0
	}
	Global.slots = ["scythe", "watering can", ""]
	Global.held_item = 0
	Global.time_going = true
	Global.time_scale = 1
	Global.grim_reaper = false
	$CanvasLayer/Control/volume.value = Global.volume
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_volume_value_changed(value):
	Global.volume = value


func _on_play_pressed():
	get_tree().change_scene("res://game.tscn")
