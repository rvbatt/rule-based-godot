class_name AbstractMatch
extends RuleBasedResource
# Abstract class for condition components

func is_satisfied(bindings: Dictionary) -> bool:
	# Abstract Method
	push_error("Abstract Method call")
	return false
