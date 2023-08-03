# Rule-Based Godot
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
### Actions
- SetProperty: `["Set", "?var"|"node", {"property": "?var"|value}]`
- CallMethod: `["Call", "?var"|"node", "method", ["?vars"|arguments]]`
- EmitSignal: `["Emit", "?var"|"node", "signal"]`
### Matches
- Boolean
  - NOT: `["NOT", condition]`
  - AND: `["AND", [conditions]]`
  - OR: `["OR", [conditions]]`
- AreaDetection: `["AreaDetection", "area", "?var"|"node"]`
- Distance: `["Distance", min, max, "node", "?var"|"node"]`
- Numeric: `["Numeric", min, max, "?var"|"node", ("property"|"method", [arguments])]`
- String: `["String", "value", "?var"|"node", ("property"|"method", [arguments])]`
- Hierarchy: `["Hierarchy", "node", "(Parent|Sibling|Child) of", "?var"|"node"]`
