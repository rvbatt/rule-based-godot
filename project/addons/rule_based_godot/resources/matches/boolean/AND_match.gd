class_name ANDMatch
extends AbstractMatch

@export var subconditions: Array[AbstractMatch]

func setup(system_node: Node) -> void:
	for condition in subconditions:
		if condition == null: continue
		condition.setup(system_node)

func is_satisfied() -> bool:
	if subconditions.is_empty():
		print_debug("Empty ANDMatch")
		return false

	for condition in subconditions:
		if condition == null: continue
		if not condition.is_satisfied():
			return false

	return true

func representation() -> String:
	# ["AND", [subconditions]]
	var string = '["AND", ['
	for condition in subconditions:
		string += condition.representation() + ', '
	string = string.trim_suffix(', ') # remove last comma
	string += ']]'

	return string

func build_from_repr(representation: Array) -> void:
	# ["AND", [subconditions]]
	subconditions = []

	for subcondition_repr in representation[1]:
		var new_condition = AbstractMatch.specialize(subcondition_repr[0])
		new_condition.build_from_repr(subcondition_repr)
		subconditions.append(new_condition)
