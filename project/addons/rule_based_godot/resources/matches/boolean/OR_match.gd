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

func to_json_string() -> String:
	# ["OR", [conditions]]
	var subconditions_string: String
	for condition in subconditions:
		subconditions_string += condition.to_json_string() + ", "

	return '["OR", [' + subconditions_string + ']]'

func build_from_repr(json_repr) -> void:
	# ["OR", [conditions]]
	subconditions = []
	for match_repr in json_repr[1]:
		var new_condition = RuleFactory.create_match(match_repr)
		new_condition.setup(_system_node)
		subconditions.append(new_condition)

func is_satisfied() -> bool:
	if subconditions.is_empty():
		print_debug("Empty ANDMatch")
		return false

	for condition in subconditions:
		if condition == null: continue
		if condition.is_satisfied():
			return true

	return false
