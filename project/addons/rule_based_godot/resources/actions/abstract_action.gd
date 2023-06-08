class_name AbstractAction
extends Resource

var _system_node: Node

func setup(system_node: Node) -> void:
	_system_node = system_node

func trigger() -> Variant:
	# Abstract method
	push_error("AbstractAction.trigger()")
	return null

func representation() -> String:
	# Abstract method
	push_error("AbstractAction.representation()")
	return "AbstractAction"

func build_from_repr(representation: String) -> void:
	# Abstract method
	push_error("AbstractAction.build_from_repr(representation)")
