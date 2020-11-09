extends Interactable


export var cost := 0
export var open_rot := 0.0

var opened := false
var interacted := false


func _physics_process(delta) -> void:
	if interacted and !opened:
		unlock(delta)
		
		
func interact(interactor: Node2D) -> void:
	if interactor.currency >= cost and !interacted:
		interactor.currency -= cost
		$KinematicBody2D/PhysicsCollider.disabled = true
		interacted = true
		force_hide_information()


func unlock(delta: float) -> void:
	rotation_degrees = lerp(rotation_degrees, open_rot, delta)
	if open_rot == rotation_degrees:
		opened = true
		
		
func show_information(area: Area2D) -> void:
	if area.name == "PlayerInteractArea" and !interacted:
		PlayerInfo.hud.set_interactable_label_text(interactable_name + ": $" + str(cost))


func force_hide_information() -> void:
	PlayerInfo.hud.set_interactable_label_text("")
