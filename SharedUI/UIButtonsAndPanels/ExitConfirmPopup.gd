extends Popup


func _on_yes_pressed():
	EventBus.game_unpaused.emit()
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
	get_tree().quit()


func _on_no_pressed():
	EventBus.game_unpaused.emit()
	hide()
