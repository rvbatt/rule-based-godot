class_name RulesFormatSaver
extends ResourceFormatSaver
# Saves the RuleList resource as a JSON file

func _recognize(resource) -> bool:
	# Recognizes RuleList
	if "_rule_based_godot" in resource:
		return resource.get("_rule_based_godot") == "RuleList"
	return false

func _get_recognized_extensions(resource) -> PackedStringArray:
	var extensions: PackedStringArray = ["json"]
	return extensions

func _save(resource, path, flags) -> Error:
	var file = FileAccess.open(path, FileAccess.WRITE)
	if file == null:
		return FileAccess.get_open_error()

	if not resource.has_method("to_json_repr"):
		return ERR_INVALID_PARAMETER

	file.store_string(JSON.stringify(resource.to_json_repr()))
	file.close()

	return OK
