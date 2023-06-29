@tool
extends EditorInspectorPlugin
class_name RulesInspectorPlugin

var _rules_edit_panel: RulesEditPanel
var _rules_edit_button: Button
var _current_system_node: RuleBasedSystem

func set_rules_edit(panel: RulesEditPanel, button: Button):
	_rules_edit_panel = panel
	_rules_edit_button = button

	_rules_edit_panel.rule_set_defined.connect(_apply_current_rules)

func _can_handle(object):
	return "_rule_based_godot" in object

func _parse_begin(object):
	if object.get("_rule_based_godot") == "System":
		_current_system_node = object as RuleBasedSystem
	# Open bottom panel
	if not _rules_edit_button.button_pressed:
		_rules_edit_button.emit_signal("toggled", true)

func _apply_current_rules(rules_string: String):
	
	var rule_set = RuleSet.new()
	rule_set.build_from_repr(JSON.parse_string(rules_string))
	_current_system_node.set("rule_set", rule_set)
