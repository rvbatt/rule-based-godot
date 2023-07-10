class_name AbstractMatch
extends RuleBasedResource
# Abstract class for condition components

func is_satisfied(bindings: Dictionary) -> bool:
	# Abstract method
	push_error("Abstract Method Call")
	return false
