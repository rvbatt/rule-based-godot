class_name NOTMatch
extends AbstractMatch

@export var negated_condition: AbstractMatch

func set_system_node(system_node: Node) -> void:
	if negated_condition != null:
		negated_condition.set_system_node(system_node)

func is_satisfied() -> bool:
	if negated_condition == null:
		print_debug("Empty NOTMatch")
		return false
	else:
		return not (negated_condition.is_satisfied())
