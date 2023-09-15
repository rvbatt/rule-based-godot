class_name AbstractArbiter
extends Resource
# Defines rule arbitration

func select_rule_to_trigger(satisfied_rules: Array[Rule]) -> Rule:
	# Abstract method
	push_error("Abstract Method Call")
	return null
