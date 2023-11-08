# meta-name: New Action
# meta-description: New type of action for rules
# meta-default: true

@tool # Actions MUST be @tool
# MUST have a class_name. Recommended use of the suffix 'Action'
#class_name Action
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

# Should ONLY be implemented IF Agent_Nodes = false
#func trigger(bindings: Dictionary) -> Array:
#	## Returns some result of triggering rhis action
#	return []

# Can be optionally implemented if Agent_Nodes = true
#func _get_agent_nodes(bindings: Dictionary) -> Array:
#	## Returns all the nodes that will perform the action
#	## consider checking agent_type
#	return []

# NEEDS to be implemeted IF Agent_Nodes = true
func _trigger_node(agent: Node, bindings: Dictionary) -> Variant:
	## Returns some result of triggering this node
	## Should check bindings for data variables, e.g.:
	# if data_var is String and data_var.begins_with('?'):
	# 	data_var = bindings.get(data_var.trim_prefix('?'))
	push_error("Abstract Method")
	return null
