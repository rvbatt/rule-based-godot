# Must have a class_name. Use the suffix 'Match'
class_name NewBooleanMatch
extends AbstractBooleanMatch

# Inherited varible: subconditions (Array[AbstractMatch])

# Must be implemented, using the subconditions
func is_satisfied(bindings: Dictionary) -> bool:
	push_error("Abstract method")
	return false
