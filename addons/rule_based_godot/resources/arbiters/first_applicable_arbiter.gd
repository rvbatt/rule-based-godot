class_name FirstApplicableArbiter
extends AbstractArbiter

func select_rule_to_trigger(satisfied_rules: Array[Rule]) -> Rule:
	return satisfied_rules[0]
