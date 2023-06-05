class_name AbstractAction
extends Resource

var _system_node: Node

func setup(system_node: Node) -> void:
	_system_node = system_node

func trigger():
	# Abstract method
	printerr("ABSTRACT METHOD CALL AT " + str(self))
