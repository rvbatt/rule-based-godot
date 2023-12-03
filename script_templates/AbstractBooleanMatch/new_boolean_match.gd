# meta-name: New Boolean Match
# meta-description: New type of multi-input boolean match for rules
# meta-default: true

# MUST have a class_name. Recommended use of the suffix 'Match'
#class_name Match 
extends AbstractBooleanMatch

# Inherited varible: subconditions (Array[AbstractMatch])

# MUST be implemented, using the subconditions
func is_satisfied(bindings: Dictionary) -> bool:
	push_error("Abstract method")
	return false
