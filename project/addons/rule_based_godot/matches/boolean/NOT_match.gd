class_name NOTMatch
extends AbstractMatch

@export var negated_condition: AbstractMatch

func _init(negated_condition = null):
	# We can define a default value because it's not an Array
	self.negated_condition = negated_condition

func set_system_node(system_node: Node) -> void:
	if negated_condition != null:
		negated_condition.set_system_node(system_node)

func is_satisfied() -> bool:
	return not (negated_condition.is_satisfied())
