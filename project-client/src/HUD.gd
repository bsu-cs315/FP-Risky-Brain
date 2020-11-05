extends CanvasLayer


onready var playerNode:= get_parent()


func _process(_delta) -> void:
	if "SinglePlayer" == playerNode.name || str(get_tree().get_network_unique_id()) == playerNode.name:
		$Control.show()
		$Control/HealthBar.value = playerNode.health
		$Control/CurrencyLabel.text = "$" + str(playerNode.currency)
		$Control/AmmoLabel.text = str(playerNode.current_weapon.ammo_mag_current)
		$Control/AmmoLabel.text += "/" + str(playerNode.current_weapon.ammo_mag_max)
		$Control/AmmoLabel.text += "\n" + str(playerNode.current_weapon.ammo_total_current)
		$Control/AmmoLabel.text += "/" + str(playerNode.current_weapon.ammo_total_max)
