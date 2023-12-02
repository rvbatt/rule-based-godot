@icon("../ruler_icon.png")
class_name RuleBasedSystem
extends Timer
# System object that will be placed in scenes

signal iteration_results(results: Array)
enum IterationUpdate {EVERY_FRAME, ON_TIMER, ON_CALL}

# Identifier for the RulesInspectorPlugin
@export var _rule_based_godot := &"System"

@export var iteration_update := IterationUpdate.ON_TIMER:
	set = _set_iteration_update
@export var arbiter: AbstractArbiter = FirstApplicableArbiter.new()
@export var rule_list := RuleList.new()

var _iterate_every_frame := false

func _ready():
	if rule_list != null:
		rule_list.setup(self)
	#print(rule_list.to_json_repr())
	if iteration_update == IterationUpdate.ON_TIMER:
		connect("timeout", _on_timeout)
		start()

func _physics_process(_delta):
	if _iterate_every_frame:
		iterate()

func iterate() -> Array:
	var results := []

	var satified_rules = rule_list.satisfied_rules()
	if not satified_rules.is_empty():
		var selected_rule = arbiter.select_rule_to_trigger(satified_rules)
		results = selected_rule.trigger_actions()

	iteration_results.emit(results)
	return results

func _set_iteration_update(type: IterationUpdate) -> void:
	match(type):
		IterationUpdate.EVERY_FRAME:
			_iterate_every_frame = true
			if is_connected("timeout", _on_timeout):
				disconnect("timeout", _on_timeout)
			stop()
		IterationUpdate.ON_TIMER:
			_iterate_every_frame = false
			if not is_connected("timeout", _on_timeout):
				connect("timeout", _on_timeout)
			start()
		IterationUpdate.ON_CALL:
			_iterate_every_frame = false
			if is_connected("timeout", _on_timeout):
				disconnect("timeout", _on_timeout)
			stop()
		_:
			push_error("Invalid Iteration Update")
			return

	iteration_update = type

func _on_timeout() -> void:
	iterate()
	start()
