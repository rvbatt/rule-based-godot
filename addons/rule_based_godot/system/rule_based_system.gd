@icon("../ruler_icon.png")
extends Node
class_name RuleBasedSystem

# Identifier for the RulesInspectorPlugin
@export var _rule_based_godot: StringName = "System"

@export var arbiter: AbstractArbiter = FirstApplicableArbiter.new()
@export var rule_set: RuleSet

func _ready():
	if rule_set != null:
		rule_set.setup(self)
	print(rule_set.to_json_repr())

func test_rules() -> Array:
	var satified_rules = rule_set.satisfied_rules()

	if not satified_rules.is_empty():
		var selected_rule = arbiter.select_rule_to_trigger(satified_rules)
		return selected_rule.trigger_actions()

	return []
