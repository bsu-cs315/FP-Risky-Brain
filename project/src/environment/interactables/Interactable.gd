class_name Interactable
extends Area2D


var is_interactable: bool = true

export var interactable_name: String


func interact(_interactor: Node2D) -> void:
	assert(false, "Must override interact!")


func show_information(_interactor: Node2D) -> void:
	assert(false, "Must overide show information!")
