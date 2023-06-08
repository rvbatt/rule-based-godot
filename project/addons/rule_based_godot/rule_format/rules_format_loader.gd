class_name RulesFormatLoader
extends ResourceFormatLoader

func _get_recognized_extensions():
	var extensions: PackedStringArray = ["tres", "rules", "txt"]
	return extensions

func _load(path, original_path, use_sub_threads, cache_mode):
	if not FileAccess.file_exists(path):
		return ERR_FILE_NOT_FOUND

	var rule_representation = FileAccess.get_file_as_string(path)
	if rule_representation == "":
		return ERR_FILE_EOF

	var rule_resource = Rule.new()
	rule_resource.build_from_repr(rule_representation)

	return rule_resource
