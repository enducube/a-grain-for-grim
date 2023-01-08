extends Label


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var timer = 3
# Called when the node enters the scene tree for the first time.
func _ready():
	text = ""
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timer += delta
	if timer>1:
		text = ""
	pass

func notify(txt):
	text = txt
	timer = 0
