class_name RulesFormatSaver
extends ResourceFormatSaver

func _recognize(resource):
	return resource.has_meta("RuleBasedGodot")

func _get_recognized_extensions(resource):
	var extensions: PackedStringArray = ["tres", "rules", "txt"]
	return extensions

func _save(resource, path, flags):
	var file = FileAccess.open(path, FileAccess.WRITE)
	if file == null:
		return FileAccess.get_open_error()

	if not resource.has_method("representation"):
		return ERR_INVALID_PARAMETER

	file.store_string(resource.representation())
	file.close()

	return OK
