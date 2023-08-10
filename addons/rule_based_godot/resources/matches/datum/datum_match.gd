class_name DatumMatch
extends AbstractMatch
# Abstract class for condition components

var repr_vars: Array[StringName] # variables of json format

func _get_property_list():
	var properties = _tester_properties()
	properties.append_array(_extraction_properties())
	properties.append_array(_retrieval_properties())
	return properties

######################### The node that will be tested #########################
var Tester_Node: bool = true:
	set(value):
		Tester_Node = value
		notify_property_list_changed()
# Group: Tester_Node, prefix: tester
var tester_is_wildcard: bool = false:
	set(value):
		tester_is_wildcard = value
		if value:
			retrieval_should_retrieve = false
		notify_property_list_changed()
var tester_search_groups: PackedStringArray = []
var tester_identifier: StringName = ""
var tester_path: NodePath = ^""

var _tester_node: Node # internal reference

func _tester_properties() -> Array[Dictionary]:
	var properties: Array[Dictionary] = [
		{"name": "Tester_Node",
		"type": TYPE_BOOL,
		"usage": PROPERTY_USAGE_GROUP,
		"hint_string": "tester"}
	]
	if not Tester_Node: return properties

	properties.append(
		{"name": "tester_is_wildcard",
		"type": TYPE_BOOL,
		"usage": PROPERTY_USAGE_DEFAULT}
	)
	if tester_is_wildcard:
		properties.append_array([
			{"name": "tester_search_groups",
			"type": TYPE_PACKED_STRING_ARRAY,
			"usage": PROPERTY_USAGE_DEFAULT},
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

################# The data that will be extracted from the node ################
var Data_Extraction: bool = false:
	set(value):
		Data_Extraction = value
		notify_property_list_changed()
# Group: Data_Extraction, prefix: extraction
enum ExtractionType {PROPERTY, METHOD}
var extraction_type: ExtractionType = ExtractionType.PROPERTY:
	set(value):
		extraction_type = value
		notify_property_list_changed()
var extraction_property: StringName = ""
var extraction_method: StringName = ""
var extraction_arguments: Array = []

func _extraction_properties() -> Array[Dictionary]:
	var properties: Array[Dictionary] = [
		{"name": "Data_Extraction",
		"type": TYPE_BOOL,
		"usage": PROPERTY_USAGE_GROUP,
		"hint_string": "extraction"}
	]
	if not Data_Extraction: return properties

	var extract_types := ""
	for type in ExtractionType:
		extract_types += type.capitalize() + ","
	extract_types = extract_types.trim_suffix(",")
	properties.append(
		{"name": "extraction_type",
		"type": TYPE_INT,
		"usage": PROPERTY_USAGE_DEFAULT,
		"hint": PROPERTY_HINT_ENUM,
		"hint_string": extract_types}
	)

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

####################### Retrieve data from verification ########################
var Data_Retrieval: bool = true:
	set(value):
		Data_Retrieval = value
		notify_property_list_changed()
# Group: Data_Retrieval, prefix: retrieval
var retrieval_should_retrieve: bool = false:
	set(value):
		retrieval_should_retrieve = value
		if value:
			tester_is_wildcard = false
		notify_property_list_changed()
var retrieval_variable: StringName = ""

func _retrieval_properties() -> Array[Dictionary]:
	var properties: Array[Dictionary] = [
		{"name": "Data_Retrieval",
		"type": TYPE_BOOL,
		"usage": PROPERTY_USAGE_GROUP,
		"hint_string": "retrieval"}
	]
	if not Data_Retrieval: return properties

	properties.append(
		{"name": "retrieval_should_retrieve",
		"type": TYPE_BOOL,
		"usage": PROPERTY_USAGE_DEFAULT}
	)
	if retrieval_should_retrieve:
		properties.append(
			{"name": "retrieval_variable",
			"type": TYPE_STRING_NAME,
			"usage": PROPERTY_USAGE_DEFAULT}
		)
	return properties

######################### Setup on system node ready ###########################
func setup(system_node: Node) -> void:
	if system_node == null:
		print_debug("Setup with null system node")
		return
	_system_node = system_node
	if not tester_is_wildcard:
		_tester_node = system_node.get_node(tester_path)
	for path in _preset_paths:
		set(_preset_paths[path], system_node.get_node(get(path)))
	for connection in _preset_connections:
		var node: Node = get(connection[0])
		node.connect(connection[1], _preset_connections[connection])

var _preset_paths: Dictionary = {} # path_var -> node_var
func preset_node_path(path_variable: StringName,
		node_variable: StringName) -> void:
	_preset_paths[path_variable] = node_variable

var _preset_connections: Dictionary = {} #[node_var, signal_name] -> func
func pre_connect(node_variable: StringName, signal_name: StringName,
		function: Callable):
	var node_and_signal = [node_variable, signal_name]
	_preset_connections[node_and_signal] = function

############################# Is match satisfied ###############################
func is_satisfied(bindings: Dictionary) -> bool:
	# Uses Template method
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

func is_in_search_groups(node: Node) -> bool:
	# If there is no group, allow any node
	if tester_search_groups.is_empty(): return true

	for group in tester_search_groups:
		if node.is_in_group(group): return true

	return false

func _node_satisfies_match(tester_node: Node, bindings: Dictionary) -> bool:
	var data = _get_data(tester_node)
	if retrieval_should_retrieve:
		bindings[retrieval_variable] = data
	return _data_satisfies_match(data)

func _data_satisfies_match(data: Variant) -> bool:
	push_error("Abstract Method")
	return false

func _get_data(tester_node: Node) -> Variant:
	if tester_node == null:
		print_debug("Invalid node")
		return null

	if not Data_Extraction:
		push_error(
			"_get_data(node) should be implemented if Data_Extraction = false")
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
	# ["ID", ("?data"), vars..., "?wild"|"tester", ("prop"|"method", [args])]
	var string = '["' + match_id + '", ("?data")'
	for variable in repr_vars:
		string += ', ' + variable
	string += ', "?wild"|"tester", ("prop"|"method", [args])]'
	return string

func to_json_repr() -> Variant:
	# ["ID", ("?data"), vars..., "?wild"|"tester", ("prop"|"method", [args])]
	var json_array = [match_id]
	if retrieval_should_retrieve:
		json_array.append(var_to_str('?' + retrieval_variable))

	for variable in repr_vars:
		json_array.append(var_to_str(get(variable)))

	if Tester_Node:
		if tester_is_wildcard:
			json_array.append(var_to_str('?' + tester_identifier))
		else:
			json_array.append(var_to_str(tester_path))

	if Data_Extraction:
		match extraction_type:
			ExtractionType.PROPERTY:
				json_array.append(var_to_str(extraction_property))
			ExtractionType.METHOD:
				json_array.append_array([
					var_to_str(extraction_method),
					var_to_str(extraction_arguments)
				])

	return json_array

func build_from_repr(json_repr: Array) -> void:
	# ["ID", ("?data"), vars..., "?wild"|"tester", ("prop"|"method", [args])]
	var offset = 1
	var first_param = str_to_var(json_repr[1])
	if first_param is String and first_param.begins_with('?'):
		Data_Retrieval = true
		retrieval_should_retrieve = true
		retrieval_variable = first_param.trim_prefix('?')
		offset = 2

	var num_vars = repr_vars.size()
	for i in range(num_vars):
		set(repr_vars[i], str_to_var(json_repr[i+offset]))

	var var_or_path = str_to_var(json_repr[offset + num_vars])
	if var_or_path is String and var_or_path.begins_with('?'):
		tester_is_wildcard = true
		tester_identifier = var_or_path.trim_prefix('?')
	elif var_or_path is NodePath:
		tester_is_wildcard = false
		tester_path = var_or_path

	var num_data_params = json_repr.size() - num_vars - offset - 1
	if num_data_params == 1:
		Data_Extraction = true
		extraction_type = ExtractionType.PROPERTY
		extraction_property = str_to_var(json_repr[-1])
	elif num_data_params == 2:
		Data_Extraction = true
		extraction_type = ExtractionType.METHOD
		extraction_method = str_to_var(json_repr[-2])
		extraction_arguments = str_to_var(json_repr[-1])
