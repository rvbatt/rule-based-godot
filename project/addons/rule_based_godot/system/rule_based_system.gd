@icon("../ruler_icon.png")
extends Node

@export_enum("First Applicable", "Least Recently Used")
var rule_arbitration: String = "First Applicable":
	set(arbitration):
		_set_arbiter(arbitration)
		rule_arbitration = arbitration
	get:
		return rule_arbitration

@export var rules: Array[Rule]

var _arbiter: AbstractArbiter


func _ready():
	_set_arbiter(rule_arbitration)
	var i = 0
	for rule in rules:
		rule.setup(self)
		print(error_string(ResourceSaver.save(rule, "res://test_scenes/" + str(i) + ".json")))
		i += 1

func test_rules() -> Array:
	var satified_rules: Array[Rule] = []
	for rule in rules:
		if rule.condition.is_satisfied():
			satified_rules.append(rule)

	if not satified_rules.is_empty():
		var selected_rule = _arbiter.select_rule_to_trigger(satified_rules)
		var index = rules.find(selected_rule)
		var loaded_rule: Rule = ResourceLoader.load("res://test_scenes/" + str(index) + ".json", "Rule")
		print("RULE\n" + loaded_rule.representation())
		loaded_rule.setup(self)
		rules.append(loaded_rule)
		return selected_rule.trigger_actions()

	return []


func _set_arbiter(arbitration: StringName) -> void:
	match arbitration:
		"First Applicable":
			_arbiter = FirstApplicableArbiter.new()
		"Least Recently Used":
			_arbiter = LeastRecentlyUsedArbiter.new()
