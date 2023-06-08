class_name AbstractMatch
extends Resource
# Abstract class for condition components

var _system_node: Node

func setup(system_node: Node) -> void:
	_system_node = system_node

func is_satisfied() -> bool:
	# Abstract method
	push_error("AbstractMatch.is_satisfied()")
	return false

func representation() -> String:
	# Abstract method
	push_error("AbstractMatch.representation()")
	return "AbstractMatch"

func build_from_repr(representation: String) -> void:
	# Abstract method
	push_error("AbstractMatch.build_from_repr(representation)")
