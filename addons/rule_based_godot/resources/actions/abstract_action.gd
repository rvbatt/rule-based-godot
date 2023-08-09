extends RuleBasedResource
class_name AbstractAction

var action_id: StringName
var repr_vars: Array[StringName] # variables of json format

var Agent_Nodes: bool = true:
	set(value):
		Agent_Nodes = value
		notify_property_list_changed()
# Group: Agent_Nodes, prefix: agent
var agent_is_wildcard: bool = false:
	set(value):
		agent_is_wildcard = value
		notify_property_list_changed()
var agent_identifier: StringName = ""
var agent_path: NodePath = ^"."
var _agent_node: Node

func _get_property_list():
	var properties: Array[Dictionary] = [
		{"name": "Agent_Nodes",
		"type": TYPE_BOOL,
		"usage": PROPERTY_USAGE_GROUP,
		"hint_string": "agent"}
	]
	if not Agent_Nodes: return properties

	properties.append(
		{"name": "agent_is_wildcard",
		"type": TYPE_BOOL,
		"usage": PROPERTY_USAGE_DEFAULT}
	)
	if agent_is_wildcard:
		properties.append(
			{"name": "agent_identifier",
			"type": TYPE_STRING_NAME,
			"usage": PROPERTY_USAGE_DEFAULT}
		)
	else:
		properties.append(
			{"name": "agent_path",
			"type": TYPE_NODE_PATH,
			"usage": PROPERTY_USAGE_DEFAULT,
			"hint": PROPERTY_HINT_NODE_PATH_TO_EDITED_NODE}
		)
	return properties

var _preset_signals = {} # name_var -> param_to_type_var
func pre_add_signal(name_var: StringName, param_to_type_var: StringName) -> void:
	_preset_signals[name_var] = param_to_type_var

func signal_param_array(param_to_type: Dictionary) -> Array[Dictionary]:
	var params: Array[Dictionary] = []
	for name in param_to_type:
		params.append(
			{"name": name, "type": typeof(param_to_type[name])}
		)
	return params

func setup(system_node: Node) -> void:
	_system_node = system_node
	if agent_is_wildcard: return

	_agent_node = system_node.get_node(agent_path)
	for name_var in _preset_signals:
		var signal_name = get(name_var)
		if _agent_node.has_signal(signal_name): continue

		var params = signal_param_array(get(_preset_signals[name_var]))
		_agent_node.add_user_signal(get(name_var), params)

func trigger(bindings: Dictionary) -> Array:
	# Uses Template Method
	var results := []
	for agent in _get_agent_nodes(bindings):
		var agent_result = _result_from_agent(agent, bindings)
		if agent_result != null:
			results.append(agent_result)
	return results

func _result_from_agent(agent: Node, bindings: Dictionary) -> Variant:
	push_error("Abstract Method")
	return null

func _get_agent_nodes(bindings: Dictionary) -> Array:
	if agent_is_wildcard:
		var bound_nodes: Array = bindings.get(agent_identifier, [])
		if bound_nodes.is_empty():
			print_debug("No nodes to perform Action")
		return bound_nodes
	else:
		return [_agent_node]

func to_json_repr() -> Variant:
	# ["ID", "?wild"|"agent", vars...]
	var json_array = [action_id]
	if agent_is_wildcard:
		json_array.append(var_to_str('?' + agent_identifier))
	else:
		json_array.append(var_to_str(agent_path))
	for variable in repr_vars:
		json_array.append(var_to_str(get(variable)))
	return json_array

func build_from_repr(json_repr) -> void:
	# ["ID", "?wild"|"agent", vars...]
	var var_or_path = str_to_var(json_repr[1])
	if var_or_path is String and var_or_path.begins_with('?'):
		agent_is_wildcard = true
		agent_identifier = var_or_path.trim_prefix('?')
	elif var_or_path is NodePath:
		agent_is_wildcard = false
		agent_path = var_or_path

	for i in range(repr_vars.size()):
		set(repr_vars[i], str_to_var(json_repr[i+2]))
