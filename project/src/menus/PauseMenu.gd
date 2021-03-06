extends CanvasLayer
	

func _process(_delta):
	if Input.is_action_just_pressed("game_pause"):
		pause_game()


func pause_game() -> void:
	if !GameState.is_client_connected_to_server():
		get_tree().paused = true
		$Control.show()


func _on_ResumeButton_pressed():
	get_tree().paused = false
	$Control.hide()
