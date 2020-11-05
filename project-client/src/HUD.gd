extends CanvasLayer


func _process(_delta) -> void:
	var my_player:= PlayerInfo.get_owned_player()
	$Control.show()
	$Control/CurrencyLabel.text = "$" + str(my_player.currency)
	$Control/AmmoLabel.text = str(my_player.current_weapon.ammo_mag_current)
	$Control/AmmoLabel.text += "/" + str(my_player.current_weapon.ammo_mag_max)
	$Control/AmmoLabel.text += "\n" + str(my_player.current_weapon.ammo_total_current)
	$Control/AmmoLabel.text += "/" + str(my_player.current_weapon.ammo_total_max)
	$Control/HealthBar.value = lerp(int($Control/HealthBar.value), my_player.health, .01)

