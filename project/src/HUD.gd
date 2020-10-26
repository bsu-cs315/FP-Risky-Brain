extends CanvasLayer


func _process(delta):
	$HealthBar.value = PlayerInfo.playerNode.health
	$CurrencyLabel.text = "$" + str(PlayerInfo.playerNode.currency)
	$AmmoLabel.text = str(PlayerInfo.playerNode.current_weapon.current_ammo)

