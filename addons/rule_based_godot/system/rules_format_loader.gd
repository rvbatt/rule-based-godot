class_name RulesFormatLoader
extends ResourceFormatLoader
# Loads JSON file as RuleList resource

func _get_recognized_extensions() -> PackedStringArray:
	var extensions: PackedStringArray = ["json"]
	return extensions

func _handles_type(type) -> bool:
	return type == "RuleList"

func _get_resource_type(path) -> String:
	var dict = _load_json(path)
	if dict.has("Rules"):
		return "RuleList"
	return ""

func _load(path, original_path, use_sub_threads, cache_mode) -> Variant:
	var rule_list_repr = _load_json(path)
	if rule_list_repr.is_empty():
		return ERR_PARSE_ERROR

	var rule_list = RuleList.new()
	rule_list.build_from_repr(rule_list_repr)
	return rule_list

func _load_json(path: String) -> Dictionary:
	if not FileAccess.file_exists(path):
		return {}

	var string: String = FileAccess.get_file_as_string(path)
	if string == "":
		return {}

	var json_parser = JSON.new()
	if json_parser.parse(string) != OK:
		return {}

	return json_parser.data
