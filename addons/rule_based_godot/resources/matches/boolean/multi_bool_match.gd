class_name MultiBoolMatch
extends AbstractMatch
# Abstract class for multiple-input boolean matches

@export var subconditions: Array[AbstractMatch]

func setup(system_node: Node) -> void:
	for condition in subconditions:
		if condition == null: continue
		condition.setup(system_node)

func json_format() -> String:
	# ["ID", [conditions]]
	return '["' + match_id + '", [conditions]]'

func to_json_repr() -> Variant:
	# ["ID", [conditions]]
	var conditions_array := []
	for condition in subconditions:
		conditions_array.append(condition.to_json_repr())
	return [match_id, conditions_array]

func build_from_repr(json_repr) -> void:
	# ["ID", [conditions]]
	subconditions = []
	for match_repr in json_repr[1]:
		var new_condition = RuleFactory.create_match(match_repr)
		subconditions.append(new_condition)

func is_satisfied(bindings: Dictionary) -> bool:
	push_error("Abstract method")
	return false
