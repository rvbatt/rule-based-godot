class_name FirstApplicableArbiter
extends AbstractArbiter

func select_rule_to_trigger(satisfied_rules: Array[Rule]) -> Rule:
	# We assume the array ir ordered by priority, descending
	return satisfied_rules[0]
