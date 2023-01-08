extends Node

var money = 25
var inventory = {
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

var hover_text = ""
var selected_crop = null
var slots = ["scythe", "watering can", ""]
var held_item = 0
var time_going = true
var time_scale = 1
var grim_reaper = false

var volume = -10 # measured in negative dB

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for i in get_tree().get_nodes_in_group("music"):
		i.volume_db = volume
	for i in get_tree().get_nodes_in_group("sfx"):
		i.volume_db = volume
	if inventory[slots[2]] < 1:
		slots[2] = ""
	if time_going:
		time_scale *= 2
	else:
		time_scale *= 0.97
	time_scale = clamp(time_scale,0,1)
	pass
