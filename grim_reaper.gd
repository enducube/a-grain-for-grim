extends KinematicBody2D


var angry = false
var demands = {
	"wheat": 0,
	"oats": 0,
	"barley": 0,
	"rice": 0
}
var temp = true
var inter = 0
var interdelta = 0.1
var timer = 0
var demandscale = 1
onready var grim_menu = get_node("../CanvasLayer/grim_menu")
onready var target = null


var maxhp = 5
var hp = maxhp
# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Global.grim_reaper:
		if temp:
			timer += delta
			var hp = maxhp
			inter += interdelta
			interdelta *= 0.9
			inter = clamp(inter,0,1)
			position.y = lerp(-64,64,inter)
			demands = {
					"wheat": fmod(randi(),round(2 + clamp(get_parent().time_days-3,0,20) )),
					"oats": fmod(randi(),round(2 + clamp(get_parent().time_days-3,0,20) )),
					"barley": fmod(randi(),round(2 + clamp(get_parent().time_days-3,0,20) )),
					"rice": fmod(randi(),round(2 + clamp(get_parent().time_days-3,0,20) ))
				}
			grim_menu.get_node("Panel/ScrollContainer/dialogue").text = "hi im grim reaper "
			grim_menu.get_node("Panel/ScrollContainer/dialogue").text += "i want some grain please\n"
			grim_menu.get_node("Panel/ScrollContainer/dialogue").text += "do you have:\n\n"
			grim_menu.get_node("Panel/give").disabled = false
			for i in demands:
				if demands[i]>0:
					grim_menu.get_node("Panel/ScrollContainer/dialogue").text += str(demands[i])+" "+i+"\n"
				if Global.inventory[i]<demands[i]:
					grim_menu.get_node("Panel/give").disabled = true
			grim_menu.get_node("Panel/ScrollContainer/dialogue").text += "\n if you do i will take them "
			grim_menu.get_node("Panel/ScrollContainer/dialogue").text += "and if you dont i will delete you and your farm from this earth"
			if timer>2:
				grim_menu.show()
				temp = false
		else:
			if !angry:
				pass
			else:
				if target == null and len(get_tree().get_nodes_in_group("crop"))>1:
					target = get_tree().get_nodes_in_group("crop")[randi()%(len(get_tree().get_nodes_in_group("crop"))+1)]
				if target == null:
					target = get_node("../player")
				if target != null:
					position += position.direction_to(target.global_position).normalized()*(0.04/delta)
				if not $scythe/AnimationPlayer.is_playing():
					$scythe.rotation = 0
				if position.distance_to(target.position)<32:
					$scythe/AnimationPlayer.play("swing")
				$scythe.rotation += self.position.angle_to_point(target.position) + PI/2
	else:
		temp = true
		interdelta = 0.1
		inter -= interdelta
		inter = clamp(inter,0,1)
		position.y = lerp(-64,64,inter)
		


func _on_give_pressed():
	Global.grim_reaper = false
	Global.time_going = true
	for i in demands:
		Global.inventory[i] -= demands[i]
	grim_menu.hide()
	get_parent().grim_camera_focus = false


func _on_dont_pressed():
	angry = true
	Global.time_going = true
	grim_menu.hide()
	get_parent().grim_camera_focus = false


func _on_scythe_body_entered(body):
	if body.name == "grim_reaper":
		hp -= 1
		if hp < 1:
			Global.grim_reaper = false
			Global.time_going = true
