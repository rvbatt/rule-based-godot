class_name AbstractArbiter
extends Resource

func select_rule_to_trigger(satisfied_rules: Array[Rule]) -> Rule:
	# Abstract method
	push_error("AbstractArbiter.select_rule_to_trigger(satisfied_rules)")
	return Rule.new()
