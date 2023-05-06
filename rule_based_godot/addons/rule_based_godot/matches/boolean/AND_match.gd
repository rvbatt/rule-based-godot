class_name ANDMatch
extends AbstractMatch

@export var subconditions: Array[AbstractMatch] = []
# We can't set a default value for subconditions in _init(),
# Godot crashes with Arrays for some reason

func set_system_node(system_node: Node) -> void:
	for condition in subconditions:
		if condition == null: continue
		condition.set_system_node(system_node)

func is_satisfied() -> bool:
	for condition in subconditions:
		if condition == null: continue
		if not condition.is_satisfied():
			return false

	return true
