class_name Interactable
extends Area2D


export var interactable_name: String


func _ready() -> void:
	var _err_area_entered = connect("area_entered", self, "show_information")
	var _err_area_exited = connect("area_exited", self, "hide_information")


func interact(_interactor: Node2D) -> void:
	assert(false, "Must override interact!")


func show_information(_area: Area2D) -> void:
	assert(false, "Must overide show information!")


func hide_information(area: Area2D) -> void:
	if area.name == "PlayerInteractArea":
		PlayerInfo.hud.set_interactable_label_text("")
