extends CanvasLayer


func _process(_delta) -> void:
	if Server.server == null:
		var my_player:= PlayerInfo.get_owned_player()
		$Control.show()
		$Control/CurrencyLabel.text = "$" + str(my_player.currency)
		$Control/AmmoLabel.text = str(my_player.current_weapon.ammo_mag_current)
		$Control/AmmoLabel.text += "/" + str(my_player.current_weapon.ammo_mag_max)
		$Control/AmmoLabel.text += "\n" + str(my_player.current_weapon.ammo_total_current)
		$Control/AmmoLabel.text += "/" + str(my_player.current_weapon.ammo_total_max)
		$Control/HealthBar.value = lerp($Control/HealthBar.value, my_player.health, .1)
		if $Control/HealthBar.value > 99:
			$Control/HealthBar.value = my_player.health


func set_interactable_label_text(text: String) -> void:
	$Control/InteractableLabel.text = text


func show_reset_button() -> void:
	if Server.server == null:
		$Control/ResetButton.show()
	

func _on_ResetButton_pressed() -> void:
	get_tree().call_group("Enemies", "queue_free")
	get_node("/root/World").queue_free()
	var _err_change_scene = get_tree().change_scene("res://src/menus/Title.tscn")
