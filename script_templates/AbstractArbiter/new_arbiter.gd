# meta-name: New Arbiter
# meta-description: New type of arbiter to select the rule to trigger
# meta-default: true

# There is no need to declare a new class_name, just create a .tres resource
# and Quick Load it
#class_name NewArbiter
extends AbstractArbiter

# Needs to be implemented
func select_rule_to_trigger(satisfied_rules: Array[Rule]) -> Rule:
	push_error("Abstract Method")
	return null
