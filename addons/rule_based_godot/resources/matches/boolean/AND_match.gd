class_name ANDMatch
extends MultiBoolMatch

static func json_format() -> String:
	return '\
["AND", [
	conditions
]]'

func _init():
	match_id = "AND"

func is_satisfied(bindings: Dictionary) -> bool:
	if subconditions.is_empty():
		print_debug("Empty ANDMatch")
		return false

	for condition in subconditions:
		if condition == null: continue
		if not condition.is_satisfied(bindings):
			return false

	return true
