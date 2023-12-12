extends Popup


func _on_yes_pressed():
	pass # Replace with function body.


func _on_no_pressed():
	Input.action_press("ui_pause")
	hide()
