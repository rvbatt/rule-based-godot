# meta-name: New Arbiter
# meta-description: New type of arbiter to select which rule to trigger
# meta-default: true

# There is no need to declare a new class_name,
# you can just create a .tres resource and Quick Load it
#class_name NewArbiter
extends AbstractArbiter

# MUST be implemented
func select_rule_to_trigger(satisfied_rules: Array[Rule]) -> Rule:
	## Returns one of the satisfied_rules
	push_error("Abstract Method")
	return null
