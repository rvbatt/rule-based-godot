# rule-based-godot
A plugin for Godot game engine that  implements a generic Rule-Based System. This was developed as the capstone project for my Computer Science bachelor degree at USP.

## JSON Syntax
### Rule Set
```
{"Rules": [rules]}
```
### Rule
```
{"if": condition, "then": [actions]}
```
Actions and Matches are arrays with the first element being a string that identifies the resource.
- Actions
   - SetProperty: `["Set", setter, property, type, value]`
   - CallMethod: `["Call", agent, method, {types: arguments}]`
   - EmitSignal: `["Emit", signal]`
- Matches
   - AreaDetection: `["Area", area, [colliders]]`
   - Distance: `["Distance", min, max, first, second]`
   - Numeric: `["Numeric", min, max, test_node, property_or_method, {types: arguments}]`
   - String: `["String", value, test_node, property_or_method, {types: arguments}]`
