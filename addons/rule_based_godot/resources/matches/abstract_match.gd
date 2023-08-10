class_name AbstractMatch
extends RuleBasedResource
# Abstract class for condition components

var match_id: StringName # ID for json format

func is_satisfied(bindings: Dictionary) -> bool:
	push_error("Abstract method")
	return false
