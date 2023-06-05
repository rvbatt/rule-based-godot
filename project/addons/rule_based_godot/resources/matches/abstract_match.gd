class_name AbstractMatch
extends Resource
# Abstract class for condition components

var _system_node: Node

func setup(system_node: Node) -> void:
	_system_node = system_node

func is_satisfied() -> bool:
	# Abstract method
	printerr("ABSTRACT METHOD CALL AT " + str(self))
	return false
