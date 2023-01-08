extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var d = 0.1
var hints = [
	"hint: have more crop variety",
	"hint: grim comes on every third night",
	"hint: rice is only good in bulk",
	"hint: oats are good to make consistent profit",
	]
# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	$Control/hint.text = hints[randi() % len(hints)]
	$Control/Label2.text = "money: " + str(Global.money)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$ColorRect.modulate.a -= d
	d *= 0.9
	pass


func _on_Button_pressed():
	get_tree().change_scene("res://menu.tscn")
