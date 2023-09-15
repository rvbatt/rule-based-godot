@icon("../ruler_icon.png")
class_name RuleBasedSystem
extends Node
# System object that will be placed in scenes

# Identifier for the RulesInspectorPlugin
@export var _rule_based_godot: StringName = "System"

@export var arbiter: AbstractArbiter = FirstApplicableArbiter.new()
@export var rule_list := RuleList.new()

func _ready():
	if rule_list != null:
		rule_list.setup(self)
	print(rule_list.to_json_repr())

func iterate() -> Array:
	var satified_rules = rule_list.satisfied_rules()

	if not satified_rules.is_empty():
		var selected_rule = arbiter.select_rule_to_trigger(satified_rules)
		return selected_rule.trigger_actions()

	return []
