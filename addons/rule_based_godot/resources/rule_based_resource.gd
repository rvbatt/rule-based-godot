class_name RuleBasedResource
extends Resource
# Abstract class for all resources used in defining a RuleList

var _system_node: RuleBasedSystem

func setup(system_node: RuleBasedSystem, rule_factory: RuleFactory = null) -> void:
	# Abstract method called when the RuleBasedSystem is ready
	_system_node = system_node

func json_format() -> String:
	# Returns the expected format for to_json_repr()
	push_error("Abstract method call")
	return ""

func to_json_repr() -> Variant:
	# Returns an Array or a Dictionary with an identification and
	# all needed variables
	push_error("Abstract method call")
	return ""

func build_from_repr(json_repr) -> void:
	# Receives the representation from to_json_repr() and
	# builds itself with its information
	push_error("Abstract method call")

func _resource_id() -> String:
	# The class_name without the suffix Action or Match
	var source_code: String = get_script().source_code
	var start_index: int = source_code.find("class_name") + 11
	var length: int = \
			min(source_code.find("\n", start_index), source_code.find(" ", start_index)) \
			- start_index
	var id: String = source_code.substr(start_index, length)
	return id.trim_suffix("Match").trim_suffix("Action")

func _exported_vars() -> Array[String]:
	var var_dicts = get_property_list().filter(
		func(class_dict):
			return class_dict["usage"] & PROPERTY_USAGE_DEFAULT != 0 and \
					class_dict["usage"] & PROPERTY_USAGE_SCRIPT_VARIABLE != 0
	)
	var export_vars: Array[String] = []
	for var_dict in var_dicts:
		export_vars.append(var_dict["name"])
	return export_vars

func _var_to_repr(variable: Variant) -> Variant:
	match typeof(variable):
		TYPE_STRING, TYPE_FLOAT, TYPE_BOOL:
			return variable
		TYPE_INT:
			if variable == INF:
				return "inf"
			elif variable == -INF:
				return "-inf"
			else:
				return variable
		TYPE_STRING_NAME:
			return String(variable)
		TYPE_NODE_PATH:
			return '^' + variable.get_concatenated_names()
		TYPE_ARRAY:
			return variable.map(_var_to_repr)
		TYPE_PACKED_STRING_ARRAY:
			# "PackedStringArray(a, b, c)"
			return var_to_str(variable).replace('\"', '')
		TYPE_DICTIONARY:
			var dict = variable.duplicate(true)
			for key in dict.keys():
				var value = _var_to_repr(dict[key])
				dict.erase(key)
				dict[_var_to_repr(key)] = value
			return dict
		_:
			return var_to_str(variable)

func _repr_to_var(representation: Variant) -> Variant:
	match typeof(representation):
		TYPE_STRING:
			if representation == "inf":
				return INF
			elif representation == "-inf":
				return -INF
			elif representation.begins_with('^'):
				return NodePath(representation.trim_prefix('^'))
			elif representation.match("PackedStringArray(*)"):
				var pack_array: PackedStringArray = []
				var array_string = representation.\
						trim_prefix("PackedStringArray(").trim_suffix(")")
				for string in array_string.split(','):
					pack_array.append(string.strip_edges())
				return pack_array

			var variable = str_to_var(representation)
			if variable == null:
				return representation
			else:
				return variable

		TYPE_INT, TYPE_FLOAT, TYPE_BOOL:
			return representation
		TYPE_ARRAY:
			return representation.map(_repr_to_var)
		TYPE_DICTIONARY:
			for key in representation.keys():
				var value = _repr_to_var(representation[key])
				representation.erase(key)
				representation[_repr_to_var(key)] = value
			return representation
		_:
			push_error("Invalid representation")
			return null
