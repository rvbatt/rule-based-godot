extends RuleBasedResource
class_name AbstractAction

var Agent_Nodes: bool = true:
	set(value):
		Agent_Nodes = value
		notify_property_list_changed()
# Group: Agent_Nodes, prefix: agent
enum AgentType {PATH, GROUPS, WILDCARD}
var agent_type: AgentType = AgentType.PATH:
	set(value):
		agent_type = value
		notify_property_list_changed()

var agent_path: NodePath = ^"."
var _agent_node: Node = null

var agent_groups: PackedStringArray = []

var agent_identifier: StringName = ""

func _get_property_list():
	var properties: Array[Dictionary] = [
		{"name": "Agent_Nodes",
		"type": TYPE_BOOL,
		"usage": PROPERTY_USAGE_GROUP,
		"hint_string": "agent"}
	]
	if not Agent_Nodes: return properties

	var agent_types := ""
	for type in AgentType:
		agent_types += type.capitalize() + ","
	agent_types = agent_types.trim_suffix(",")
	properties.append(
		{"name": "agent_type",
		"type": TYPE_INT,
		"usage": PROPERTY_USAGE_DEFAULT,
		"hint": PROPERTY_HINT_ENUM,
		"hint_string": agent_types}
	)
	match agent_type:
		AgentType.PATH:
			properties.append(
				{"name": "agent_path",
				"type": TYPE_NODE_PATH,
				"usage": PROPERTY_USAGE_DEFAULT,
				"hint": PROPERTY_HINT_NODE_PATH_TO_EDITED_NODE}
			)
		AgentType.GROUPS:
			properties.append(
				{"name": "agent_groups",
				"type": TYPE_PACKED_STRING_ARRAY,
				"usage": PROPERTY_USAGE_DEFAULT}
			)
		AgentType.WILDCARD:
			properties.append(
			{"name": "agent_identifier",
			"type": TYPE_STRING_NAME,
			"usage": PROPERTY_USAGE_DEFAULT}
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
	if agent_type == AgentType.PATH:
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
	var agents := []
	match agent_type:
		AgentType.PATH:
			agents.append(_agent_node)
		AgentType.GROUPS:
			var scene: SceneTree = _system_node.get_tree()
			for group in agent_groups:
				agents.append_array(scene.get_nodes_in_group(group))
		AgentType.WILDCARD:
			agents = bindings.get(agent_identifier, [])
		_:
			print_debug("Invalid agent type")

	if agents.is_empty():
		print_debug("No nodes to perform Action")
	return agents

func json_format() -> String:
	# ["ID", "?wild"|["groups"]|"agent", vars...]
	var string = '["' + resource_id() + '", "?wild"|["groups"]|"agent"'
	for variable in exported_vars():
		string += ', ' + variable
	return string + ']'

func to_json_repr() -> Variant:
	# ["ID", "?wild"|["groups"]|"agent", vars...]
	var json_array = [resource_id()]
	match agent_type:
		AgentType.PATH:
			json_array.append(var_to_str(agent_path))
		AgentType.GROUPS:
			json_array.append(var_to_str(agent_groups))
		AgentType.WILDCARD:
			json_array.append(var_to_str('?' + agent_identifier))

	for variable in exported_vars():
		json_array.append(var_to_str(get(variable)))
	return json_array

func build_from_repr(json_repr) -> void:
	# ["ID", "?wild"|["groups"]|"agent", vars...]
	var first_param = str_to_var(json_repr[1])
	if first_param is NodePath:
		agent_type = AgentType.PATH
		agent_path = first_param
	elif first_param is Array:
		agent_type = AgentType.GROUPS
		agent_groups = first_param
	elif first_param is String and first_param.begins_with('?'):
		agent_type = AgentType.WILDCARD
		agent_identifier = first_param.trim_prefix('?')

	var export_vars = exported_vars()
	for i in range(export_vars.size()):
		set(export_vars[i], str_to_var(json_repr[i+2]))
