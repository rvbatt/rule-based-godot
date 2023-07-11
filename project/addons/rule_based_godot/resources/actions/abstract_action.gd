class_name AbstractAction
extends RuleBasedResource
# Abstract class

func trigger(bindings: Dictionary) -> Variant:
	# Abstract method
	push_error("Abstract Method Call")
	return null
