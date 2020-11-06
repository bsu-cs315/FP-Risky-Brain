extends Interactable

export var weapon : Script 
export var cost := 0
export var refill_cost := 0

var purchased := false


func interact(interactor: Node2D):
	if interactor.currency >= cost and !purchased:
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
