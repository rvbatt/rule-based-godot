class_name ANDMatch
extends AbstractMatch

@export var subconditions: Array[AbstractMatch]

static func json_format() -> String:
	return '\
["AND", [
	conditions
]]'

func setup(system_node: Node) -> void:
	for condition in subconditions:
		if condition == null: continue
		condition.setup(system_node)

func to_json_string() -> String:
	# ["AND", [conditions]]
	var subconditions_string: String
	for condition in subconditions:
		subconditions_string += condition.to_json_string() + ", "

	return '["AND", [' + subconditions_string + ']]'

func build_from_repr(json_repr) -> void:
	# ["AND", [conditions]]
	subconditions = []
	for match_repr in json_repr[1]:
		var new_condition = RuleFactory.create_match(match_repr)
		new_condition.setup(_system_node)
		subconditions.append(new_condition)

func is_satisfied(bindings: Dictionary) -> bool:
	if subconditions.is_empty():
		print_debug("Empty ANDMatch")
		return false

	for condition in subconditions:
		if condition == null: continue
		if not condition.is_satisfied(bindings):
			return false

	return true
