extends Interactable

export var weapon : Script 
export var cost := 0
export var refill_cost := 0

var purchased := false


func interact(interactor: Node2D) -> void:
	if interactor.currency >= cost and !(interactor.current_weapon is weapon):
		interactor.currency -= cost
		if interactor.inventory.secondary == null:
			interactor.inventory.secondary = weapon.new(interactor)
			interactor.change_current_weapon(interactor.inventory.secondary)
		else:
			if interactor.current_weapon == interactor.inventory.primary:
				interactor.inventory.primary = weapon.new(interactor)
				interactor.change_current_weapon(interactor.inventory.primary)
			else:
				interactor.inventory.secondary = weapon.new(interactor)
				interactor.change_current_weapon(interactor.inventory.secondary)
		purchased = true
		$AnimatedSprite.frame = 1
	elif interactor.currency >= refill_cost and purchased and interactor.current_weapon is weapon:
		interactor.currency -= refill_cost
		interactor.current_weapon.refill_ammo()
	force_show_information(interactor)


func show_information(area: Area2D) -> void:
	if area.name == "PlayerInteractArea":
		if !(area.owner.current_weapon is weapon):
			PlayerInfo.hud.set_interactable_label_text(interactable_name + ": $" + str(cost))
		else:
			PlayerInfo.hud.set_interactable_label_text(interactable_name + " ammo: $" + str(refill_cost))
			

func force_show_information(interactor: Node2D) -> void:
	if !(interactor.current_weapon is weapon):
		PlayerInfo.hud.set_interactable_label_text(interactable_name + ": $" + str(cost))
	else:
		PlayerInfo.hud.set_interactable_label_text(interactable_name + " ammo: $" + str(refill_cost))
