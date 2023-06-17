class_name AbstractAction
extends RuleBasedResource
# Abstract class

func trigger() -> Variant:
	# Abstract method
	push_error("Abstract Method Call")
	return null
