extends Panel

export var type = "wheat seed"
export(Texture) var icon
export var selling = false
var value = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	if selling:
		$selling.show()
		$inventory.queue_free()
		
	else:
		$selling.queue_free()
		$inventory.show()
		match type:
			"wheat seed":
				value = 4
			"barley seed":
				value = 2
			"oat seed":
				value = 3
			"rice seed":
				value = 5
	$TextureRect.texture = icon
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Label.text = type + "\n("+str(Global.inventory[type])+")"
	if !selling:
		
		if Global.inventory[type] < 1:
			$inventory/equip.disabled = true
		else:
			$inventory/equip.disabled = false
		
		if Global.money < value:
			$inventory/buy.disabled = true
		else:
			$inventory/buy.disabled = false
		match type:
			"mill-o-tron":
				value = 30 + pow(Global.inventory["mill-o-tron"],2)
			"scythe+":
				value = 10 + Global.inventory["scythe+"]*6
			"fertilizer":
				value = 30 + Global.inventory["fertilizer"]*6
			"crow cash":
				value = 20 + Global.inventory["crow cash"]*10
	else:
		match type:
			"wheat":
				value = 10*Global.inventory["wheat"]*(1+(0.05*Global.inventory["mill-o-tron"]))
			"barley":
				value = 5*Global.inventory["barley"]*(1+(0.05*Global.inventory["mill-o-tron"]))
			"oats":
				value = 4*Global.inventory["oats"]*(1+(0.05*Global.inventory["mill-o-tron"]))
			"rice":
				value = round(pow(Global.inventory["rice"],1.85))*(1+(0.05*Global.inventory["mill-o-tron"]))
	


func _on_buy_pressed():
	if Global.money >= value:
		Global.inventory[type] += 1
		Global.money -= value
	


func _on_hold_pressed(): # equip
	Global.slots[2] = type
	Global.held_item = 2



func _on_sell_pressed():
	Global.money += value
	Global.inventory[type] = 0


func _on_buy_mouse_entered():
	Global.hover_text = "cost: $"+str(value)
	match type:
		"mill-o-tron":
			Global.hover_text += "\n sell for more"
		"scythe+":
			Global.hover_text += "\n better scythe"
		"fertilizer":
			Global.hover_text += "\n grow grain fast"
		"crow cash":
			Global.hover_text += "\n crows give cash"


func _on_buy_mouse_exited():
	Global.hover_text = ""


func _on_sell_mouse_entered():
	Global.hover_text = ""
	if type == "rice":
		Global.hover_text += "Rice sells exponentially\n" 
	Global.hover_text += "value: $"+str(value)


func _on_sell_mouse_exited():
	Global.hover_text = ""
