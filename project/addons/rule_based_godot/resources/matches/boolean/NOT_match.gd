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

func to_json_string() -> String:
	# ["NOT", condition]
	return '["NOT", ' + negated_condition.to_json_string() + ']'

func build_from_repr(json_repr) -> void:
	# ["NOT", condition]
	var condition = RuleFactory.create_match(json_repr[1])
	condition.setup(_system_node)
