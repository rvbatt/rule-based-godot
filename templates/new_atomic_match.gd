@tool # Atomic matches need to be @tool
# Must have a class_name. Use the suffix 'Match'
class_name NewAtomicMatch 
extends AbstractAtomicMatch

# Export variables and give them a default value 
@export var num_var := 1.0 # Use float instead of int
@export_node_path() var path_var := ^""
var _node_var: Node # Keep an internal reference to nodes

func _init():
	# Should the match check some Node?
	Tester_Node = true

	# Requires Tester_Node
	# Is the check based on some data from the node?
	Data_Based_Node = true

	# Requires Data_Based_Node
	# Is the data extracted from a property or method call?
	Get_Node_Data_Preset = false

	# When using nodes that may change position in the SceneTree,
	# save the reference to the original node in the exported path
	_preset_node_path("path_var", "_node_var")

	# Connect signal when match is created
	#_pre_connect("_node_var", "signal", receiving_func)

# Should only be implemented if Tester_Node = false
#func is_satisfied(bindings: Dictionary) -> bool:
#	return false

# Can be optionally implemented if Tester_Node = true
#func _get_candidates() -> Array[Node]:   
#	## Gets all the nodes that may satisfy the match
#	var candidates: Array[Node] = []
#	return candidates

# Needs to be implemeted if Tester_Node = true and Data_Based_Node = false
#func _node_satisfies_match(tester_node: Node, bindings: Dictionary) -> bool: 
#	return false

# Needs to be implemented if Data_Based_Node = true
func _data_satisfies_match(data: Variant) -> bool:
	push_error("Abstract Method")
	return false

# Needs to be implemented if Data_Based_Node = true
# and Get_Node_Data_Preset = false
func _get_data(tester_node: Node) -> Variant:
	push_error("Abstract Method")
	return null
