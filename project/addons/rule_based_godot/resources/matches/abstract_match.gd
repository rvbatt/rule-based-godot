class_name AbstractMatch
extends RuleBasedResource
# Abstract class for condition components

func is_satisfied() -> bool:
	# Abstract method
	push_error("Abstract Method Call")
	return false
