class_name Door
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
		is_interactable = false


func unlock(delta: float) -> void:
	rotation_degrees = lerp(rotation_degrees, open_rot, delta)
	if abs(open_rot - rotation_degrees) <= 1:
		opened = true
		
		
func show_information(_interactor: Node2D) -> void:
	if !interacted:
		PlayerInfo.hud.set_interactable_label_text(interactable_name + ": $" + str(cost))
