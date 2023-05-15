class_name AbstractAction
extends Resource

var _system_node: Node

func set_system_node(system_node: Node) -> void:
	_system_node = system_node

func trigger():
	# Abstract method
	printerr("ABSTRACT METHOD CALL AT " + str(self))
