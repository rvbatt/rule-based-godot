class_name AbstractMatch
extends RuleBasedResource
# Abstract class for condition components

func is_satisfied(bindings: Dictionary) -> bool:
	push_error("Abstract method")
	return false
