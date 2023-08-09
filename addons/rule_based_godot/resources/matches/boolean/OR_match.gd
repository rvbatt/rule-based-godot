class_name ORMatch
extends MultiBoolMatch

static func json_format() -> String:
	return '\
["OR", [
	conditions
]]'

func _init():
	match_id = "OR"

func is_satisfied(bindings: Dictionary) -> bool:
	if subconditions.is_empty():
		print_debug("Empty ORMatch")
		return false

	for condition in subconditions:
		if condition == null: continue
		if condition.is_satisfied(bindings):
			return true

	return false
