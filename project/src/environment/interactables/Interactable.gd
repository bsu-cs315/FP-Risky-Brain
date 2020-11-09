class_name Interactable
extends Area2D


export var interactable_name: String


func _ready():
	connect("area_entered", self, "show_information")
	connect("area_exited", self, "hide_information")


func interact(_interactor: Node2D) -> void:
	assert(false, "Must override interact!")


func show_information(area: Area2D) -> void:
	assert(false, "Must overide show information!")


func hide_information(area: Area2D) -> void:
	if area.name == "PlayerInteractArea":
		PlayerInfo.hud.set_interactable_label_text("")
