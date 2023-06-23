class_name RulesFormatSaver
extends ResourceFormatSaver

func _recognize(resource):
	# Recognizes RuleSet
	if "_rule_based_godot" in resource:
		return resource.get("_rule_based_godot") == "RuleSet"
	return false

func _get_recognized_extensions(resource):
	var extensions: PackedStringArray = ["json"]
	return extensions

func _save(resource, path, flags) -> Error:
	var file = FileAccess.open(path, FileAccess.WRITE)
	if file == null:
		return FileAccess.get_open_error()

	if not resource.has_method("to_json_string"):
		return ERR_INVALID_PARAMETER

	file.store_string(resource.to_json_string())
	file.close()

	return OK
