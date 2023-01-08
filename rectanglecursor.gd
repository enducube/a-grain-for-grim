extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.position = Vector2(
		floor(get_global_mouse_position().x/16),
		floor(get_global_mouse_position().y/16))*16 + Vector2(8,8)
	if Global.held_item == 1 or Global.held_item == 2:
		show()
	else:
		hide()
	pass
