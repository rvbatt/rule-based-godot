class_name AbstractDatumMatch
extends AbstractMatch
# Abstract class for condition components

func _get_property_list():
	var properties = _tester_properties()
	properties.append_array(_retrieval_properties())
	properties.append_array(_extraction_properties())
	return properties

######################### The node that will be tested #########################
var Tester_Node: bool = true:
	set(value):
		Tester_Node = value
		if value == false:
			Data_Based_Node = false
		notify_property_list_changed()
# Group: Tester_Node, prefix: tester
var tester_is_wildcard: bool = false:
	set(value):
		tester_is_wildcard = value
		if value:
			should_retrieve_data = false
		notify_property_list_changed()
var tester_search_groups: Array[StringName] = []
var tester_identifier: StringName = &""
var tester_path: NodePath = ^""

var _tester_node: Node # internal reference

func _tester_properties() -> Array[Dictionary]:
	var properties: Array[Dictionary] = []
	if not Tester_Node: return properties

	properties.append_array([
		{"name": "Tester_Node",
		"type": TYPE_BOOL,
		"usage": PROPERTY_USAGE_GROUP,
		"hint_string": "tester"},
		{"name": "tester_is_wildcard",
		"type": TYPE_BOOL,
		"usage": PROPERTY_USAGE_DEFAULT}
	])
	if tester_is_wildcard:
		properties.append_array([
			{"name": "tester_search_groups",
			"type": TYPE_ARRAY,
			"usage": PROPERTY_USAGE_DEFAULT,
			"hint": PROPERTY_HINT_TYPE_STRING,
			"hint_string": "%d:" % [TYPE_STRING_NAME]},
			{"name": "tester_identifier",
			"type": TYPE_STRING_NAME,
			"usage": PROPERTY_USAGE_DEFAULT}
		])
	else:
		properties.append(
			{"name": "tester_path",
			"type": TYPE_NODE_PATH,
			"usage": PROPERTY_USAGE_DEFAULT,
			"hint": PROPERTY_HINT_NODE_PATH_TO_EDITED_NODE}
		)
	return properties

######################### Match is based on node data ##########################
var Data_Based_Node: bool = true:
	set(value):
		Data_Based_Node = value
		if value == false:
			Get_Node_Data_Preset = false
		notify_property_list_changed()
var should_retrieve_data: bool = false:
	set(value):
		should_retrieve_data = value
		if value:
			tester_is_wildcard = false
		notify_property_list_changed()
var data_variable: StringName = &""

func _retrieval_properties() -> Array[Dictionary]:
	var properties: Array[Dictionary] = []
	if not Data_Based_Node: return properties

	properties.append(
		{"name": "should_retrieve_data",
		"type": TYPE_BOOL,
		"usage": PROPERTY_USAGE_DEFAULT}
	)
	if should_retrieve_data:
		properties.append(
			{"name": "data_variable",
			"type": TYPE_STRING_NAME,
			"usage": PROPERTY_USAGE_DEFAULT}
		)
	return properties

################### Presets for the _get_data(node) function ###################
var Get_Node_Data_Preset: bool = false:
	set(value):
		Get_Node_Data_Preset = value
		notify_property_list_changed()
var Data_Extraction # just group name
# Group: Data_Extraction, prefix: extraction
enum ExtractionType {PROPERTY, METHOD}
var extraction_type: ExtractionType = ExtractionType.PROPERTY:
	set(value):
		extraction_type = value
		notify_property_list_changed()
var extraction_property: StringName = &""
var extraction_method: StringName = &""
var extraction_arguments: Array = []

func _extraction_properties() -> Array[Dictionary]:
	var properties: Array[Dictionary] = []
	if not Get_Node_Data_Preset: return properties

	var extract_types := ""
	for type in ExtractionType:
		extract_types += type.capitalize() + ","
	extract_types = extract_types.trim_suffix(",")
	properties.append_array([
		{"name": "Data_Extraction",
		"type": TYPE_BOOL,
		"usage": PROPERTY_USAGE_GROUP,
		"hint_string": "extraction"},
		{"name": "extraction_type",
		"type": TYPE_INT,
		"usage": PROPERTY_USAGE_DEFAULT,
		"hint": PROPERTY_HINT_ENUM,
		"hint_string": extract_types}
	])

	match extraction_type:
		ExtractionType.PROPERTY:
			properties.append(
				{"name": "extraction_property",
				"type": TYPE_STRING_NAME,
				"usage": PROPERTY_USAGE_DEFAULT}
			)
		ExtractionType.METHOD:
			properties.append_array([
			{"name": "extraction_method",
			"type": TYPE_STRING_NAME,
			"usage": PROPERTY_USAGE_DEFAULT},
			{"name": "extraction_arguments",
			"type": TYPE_ARRAY,
			"usage": PROPERTY_USAGE_DEFAULT}
			])

	return properties

######################### Setup on system node ready ###########################
func setup(system_node: RuleBasedSystem) -> void:
	if system_node == null:
		print_debug("Setup with null system node")
		return
	_system_node = system_node
	if Tester_Node and not tester_is_wildcard:
		_tester_node = system_node.get_node(tester_path)
	for path in _preset_paths:
		set(_preset_paths[path], system_node.get_node(get(path)))
	for connection in _preset_connections:
		var node: Node = get(connection[0])
		node.connect(connection[1], _preset_connections[connection])

var _preset_paths: Dictionary = {} # path_var -> node_var
func _preset_node_path(path_variable: StringName,
		node_variable: StringName) -> void:
	_preset_paths[path_variable] = node_variable

var _preset_connections: Dictionary = {} #[node_var, signal_name] -> func
func _pre_connect(node_variable: StringName, signal_name: StringName,
		function: Callable):
	var node_and_signal = [node_variable, signal_name]
	_preset_connections[node_and_signal] = function

############################# Is match satisfied ###############################
func is_satisfied(bindings: Dictionary) -> bool:
	# Uses Template method
	if not Tester_Node:
		push_error("is_satisfied() should be implemented if Tester_Node = false")
		return false

	if tester_is_wildcard:
		var candidates: Array = bindings.get(tester_identifier) \
			if bindings.has(tester_identifier) \
			else _get_candidates()

		var valid_candidates := []
		for candidate in candidates:
			if _node_satisfies_match(candidate, bindings):
				valid_candidates.append(candidate)

		bindings[tester_identifier] = valid_candidates
		return not valid_candidates.is_empty()

	return _node_satisfies_match(_tester_node, bindings)

func _get_candidates() -> Array[Node]:
	# If no group is provided, default to descendants of system node
	if tester_search_groups.is_empty():
		return _system_node.get_children(true)

	var scene: SceneTree = _system_node.get_tree()
	var candidates: Array[Node] = []
	for group in tester_search_groups:
		candidates.append_array(scene.get_nodes_in_group(group))
	return candidates

func _is_in_search_groups(node: Node) -> bool:
	# If there is no group, allow any node
	if tester_search_groups.is_empty(): return true

	for group in tester_search_groups:
		if node.is_in_group(group): return true

	return false

func _node_satisfies_match(tester_node: Node, bindings: Dictionary) -> bool:
	if not Data_Based_Node:
		push_error("_node_satisfies_match() should be implemented if Data_Based_Node = false")
		return false

	var data = _get_data(tester_node)
	if should_retrieve_data:
		bindings[data_variable] = data
	return _data_satisfies_match(data)

func _data_satisfies_match(data: Variant) -> bool:
	push_error("Abstract Method")
	return false

func _get_data(tester_node: Node) -> Variant:
	if not Get_Node_Data_Preset:
		push_error("_get_data() should be implemented if Get_Node_Data_Preset = false")
		return null

	if tester_node == null:
		print_debug("Invalid node")
		return null
	match extraction_type:
		ExtractionType.PROPERTY:
			if not extraction_property in tester_node:
				print_debug("Invalid property")
				return null
			return tester_node.get(extraction_property)

		ExtractionType.METHOD:
			if not tester_node.has_method(extraction_method):
				print_debug("Invalid method")
				return null
			return tester_node.callv(extraction_method, extraction_arguments)

		_:
			print_debug("Invalid DataExtraction type")
			return null

################################ JSON format ###################################
func json_format() -> String:
	# [ID, <?data>, vars..., (tester_path|?wild, [groups]) <, (prop|method, [args])>]
	var string = '[' + _resource_id() + ', <?data>'
	for variable in _exported_vars():
		string += ', ' + variable
	string += ', (tester_path|?wild, [groups]) <, (prop|method, [args])>]'
	return string

func to_json_repr() -> Variant:
	# [ID, <?data>, vars..., (tester_path|?wild, [groups]) <, (prop|method, [args])>]
	var json_array = [_resource_id()]
	if Data_Based_Node and should_retrieve_data:
		json_array.append(_var_to_repr('?' + data_variable))

	for variable in _exported_vars():
		json_array.append(_var_to_repr(get(variable)))

	if Tester_Node:
		if tester_is_wildcard:
			json_array.append(_var_to_repr('?' + tester_identifier))
			json_array.append(_var_to_repr(tester_search_groups))
		else:
			json_array.append(_var_to_repr(tester_path))

	if Get_Node_Data_Preset:
		match extraction_type:
			ExtractionType.PROPERTY:
				json_array.append(_var_to_repr(extraction_property))
			ExtractionType.METHOD:
				json_array.append_array([
					_var_to_repr(extraction_method),
					_var_to_repr(extraction_arguments)
				])

	return json_array

func build_from_repr(json_repr: Array) -> void:
	# [ID, <?data>, vars..., (tester_path|?wild, [groups]) <, (prop|method, [args])>]
	var offset = 1
	var first_param = _repr_to_var(json_repr[1])
	if first_param is String and first_param.begins_with('?'):
		Data_Based_Node = true
		should_retrieve_data = true
		data_variable = first_param.trim_prefix('?')
		offset = 2

	var export_vars = _exported_vars()
	var num_vars = export_vars.size()
	for i in range(num_vars):
		set(export_vars[i], _repr_to_var(json_repr[i + offset]))

	var var_or_path = _repr_to_var(json_repr[num_vars + offset])
	if var_or_path is String and var_or_path.begins_with('?'):
		offset += 1
		tester_is_wildcard = true
		tester_identifier = var_or_path.trim_prefix('?')
		tester_search_groups = []
		tester_search_groups.assign(_repr_to_var(json_repr[num_vars + offset]))
	elif var_or_path is NodePath:
		tester_is_wildcard = false
		tester_path = var_or_path

	var num_data_params = json_repr.size() - num_vars - offset - 1
	if num_data_params == 1:
		Get_Node_Data_Preset = true
		extraction_type = ExtractionType.PROPERTY
		extraction_property = _repr_to_var(json_repr[-1])
	elif num_data_params == 2:
		Get_Node_Data_Preset = true
		extraction_type = ExtractionType.METHOD
		extraction_method = _repr_to_var(json_repr[-2])
		extraction_arguments = _repr_to_var(json_repr[-1])
