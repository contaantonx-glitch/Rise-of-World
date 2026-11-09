extends Node

var resources: Dictionary = {
    "wood": 120.0,
    "food": 150.0,
    "stone": 90.0,
    "gold": 50.0,
}

func reset() -> void:
    resources = {
        "wood": 120.0,
        "food": 150.0,
        "stone": 90.0,
        "gold": 50.0,
    }

func add_resource(name: String, amount: float) -> void:
    if resources.has(name):
        resources[name] += amount

func spend_resource(name: String, amount: float) -> bool:
    if resources.has(name) and resources[name] >= amount:
        resources[name] -= amount
        return true
    return false

func can_afford(costs: Dictionary) -> bool:
    for resource_name in costs:
        if not resources.has(resource_name):
            return false
        if resources[resource_name] < costs[resource_name]:
            return false
    return true

func get_resource_value(name: String) -> float:
    return resources.get(name, 0.0)
