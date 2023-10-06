# meta-name: New Action
# meta-description: New type of action for rules
# meta-default: true


@tool # Actions need to be @tool
# Must have a class_name. Use the suffix 'Action'
class_name NewAction
extends AbstractAction

# Export variables and give them a default value 
@export var num_var := 1.0 # Use float instead of int
var _signal_var := "signal_name"
# This is a dictionary with the name of the signal parameters as keys and
# an arbitrary element with the same type as the corresponding argument as value 
var _parameter_to_type: Dictionary# = {number_param: 1, string_param: ""}

func _init():
	# Does the action trigger some Node(s)?
	Agent_Nodes = true

	# Adds a signal if Agent_Nodes = true and (agent_)type = Path
	_pre_add_signal("_signal_var", "_parameter_to_type")

# Should only be implemented if Agent_Nodes = false
#func trigger(bindings: Dictionary) -> Array:
#	return []

# Can be optionally implemented if Agent_Nodes = true
#func _get_agent_nodes(bindings: Dictionary) -> Array:
#	## Gets all the nodes that will perform the action
#	## consider checking agent_type
#	return []

# Needs to be implemeted if Agent_Nodes = true
func _trigger_node(agent_node: Node, bindings: Dictionary) -> Variant:
	push_error("Abstract Method")
	return null
