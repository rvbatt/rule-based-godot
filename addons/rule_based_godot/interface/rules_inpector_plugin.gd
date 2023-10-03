@tool
extends EditorInspectorPlugin
# Connects Rules Editor with current RuleBasedSystem

var _rules_editor: Control
var _rules_editor_button: Button
var _current_system_node: RuleBasedSystem

func set_rules_editor(rules_editor_panel: Control, button: Button):
	# Called at plugin startup
	_rules_editor = rules_editor_panel
	_rules_editor_button = button

	_rules_editor.rule_list_defined.connect(_apply_current_rules)

func _can_handle(object):
	match object.get_class():
		"SectionedInspectorFilter":
			return false
		"ImportDockParameters":
			return false
		"ScriptEditorDebuggerVariables":
			return false
		_:
			return "_rule_based_godot" in object

func _parse_category(object, category):
	pass

func _parse_group(object, group):
	pass

func _parse_begin(object):
	if object.get("_rule_based_godot") == "System":
		_current_system_node = object as RuleBasedSystem
	# Open bottom panel
	if not _rules_editor_button.button_pressed:
		_rules_editor_button.emit_signal("toggled", true)

func _parse_property(object, type, name, hint_type, hint_string, usage_flags, wide):
	# removes _rule_based_godot from inspector
	if name == "_rule_based_godot": return true
	return false

func _parse_end(object):
	pass

func _apply_current_rules(rules_string: String) -> void:
	if _current_system_node == null: return

	var rule_list = RuleList.new()
	rule_list.build_from_repr(JSON.parse_string(rules_string))
	_current_system_node.set("rule_list", rule_list)
