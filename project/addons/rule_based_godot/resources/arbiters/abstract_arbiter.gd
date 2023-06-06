class_name AbstractArbiter
extends Resource

func select_rule_to_trigger(satisfied_rules: Array[Rule]) -> Rule:
	# Abstract method
	printerr("ABSTRACT METHOD CALL AT " + str(self))
	return Rule.new()
