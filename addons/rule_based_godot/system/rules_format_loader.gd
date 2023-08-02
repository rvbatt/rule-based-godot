class_name RulesFormatLoader
extends ResourceFormatLoader

func _get_recognized_extensions():
	var extensions: PackedStringArray = ["json"]
	return extensions

func _handles_type(type):
	return type == "RuleSet"

func _get_resource_type(path):
	var dict = _load_json(path)
	if dict.has("Rules"):
		return "RuleSet"
	return ""

func _load(path, original_path, use_sub_threads, cache_mode) -> Variant:
	var rule_set_repr = _load_json(path)
	if rule_set_repr.is_empty():
		return ERR_PARSE_ERROR

	var rule_set = RuleSet.new()
	rule_set.build_from_repr(rule_set_repr)
	return rule_set

func _load_json(path: String) -> Dictionary:
	if not FileAccess.file_exists(path):
		return {}

	var string: String = FileAccess.get_file_as_string(path)
	if string == "":
		return {}

	var dict: Dictionary = JSON.parse_string(string)
	if dict == null:
		return {}

	return dict
