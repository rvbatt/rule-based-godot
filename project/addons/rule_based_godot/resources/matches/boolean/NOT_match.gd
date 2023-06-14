class_name NOTMatch
extends AbstractMatch

@export var negated_condition: AbstractMatch

func setup(system_node: Node) -> void:
	if negated_condition != null:
		negated_condition.setup(system_node)

func is_satisfied() -> bool:
	if negated_condition == null:
		print_debug("Empty NOTMatch")
		return false
	else:
		return not (negated_condition.is_satisfied())

func representation() -> String:
	# ["NOT", negated_condition]
	return '["NOT", ' + negated_condition.representation() + ']'

func build_from_repr(representation: Array) -> void:
	# ["NOT", negated_condition]
	var condition_repr: Array = representation[1]
	negated_condition = AbstractMatch.specialize(condition_repr[0])
	negated_condition.build_from_repr(condition_repr)
