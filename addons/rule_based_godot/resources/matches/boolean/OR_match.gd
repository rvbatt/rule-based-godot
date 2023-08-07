class_name ORMatch
extends AbstractMatch

@export var subconditions: Array[AbstractMatch]

static func json_format() -> String:
	return '\
["OR", [
	conditions
]]'

func setup(system_node: Node) -> void:
	for condition in subconditions:
		if condition == null: continue
		condition.setup(system_node)

func to_json_repr() -> Variant:
	# ["OR", [conditions]]
	var conditions_array := []
	for condition in subconditions:
		conditions_array.append(condition.to_json_repr())
	return ["OR", conditions_array]

func build_from_repr(json_repr) -> void:
	# ["OR", [conditions]]
	subconditions = []
	for match_repr in json_repr[1]:
		var new_condition = RuleFactory.create_match(match_repr)
		subconditions.append(new_condition)

func is_satisfied(bindings: Dictionary) -> bool:
	if subconditions.is_empty():
		print_debug("Empty ANDMatch")
		return false

	for condition in subconditions:
		if condition == null: continue
		if condition.is_satisfied(bindings):
			return true

	return false
