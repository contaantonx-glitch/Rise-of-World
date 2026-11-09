extends Node2D

signal city_updated

var population: int = 12
var buildings: Dictionary = {
    "town_hall": 1,
    "farm": 1,
    "lumbermill": 1,
    "quarry": 1,
    "barracks": 1,
    "wall": 1,
}

const BUILD_COSTS: Dictionary = {
    "farm": {"wood": 25, "stone": 15},
    "lumbermill": {"wood": 30, "stone": 10},
    "quarry": {"wood": 20, "stone": 25},
    "barracks": {"wood": 40, "stone": 30, "gold": 20},
    "wall": {"wood": 35, "stone": 45},
    "town_hall": {"wood": 60, "stone": 40, "gold": 20},
}

func _ready() -> void:
    set_process(true)
    emit_signal("city_updated")

func _process(delta: float) -> void:
    var production = {
        "food": buildings.get("farm", 0) * 1.2,
        "wood": buildings.get("lumbermill", 0) * 1.1,
        "stone": buildings.get("quarry", 0) * 0.9,
        "gold": buildings.get("barracks", 0) * 0.75,
    }

    ResourceManager.add_resource("food", production["food"] * delta)
    ResourceManager.add_resource("wood", production["wood"] * delta)
    ResourceManager.add_resource("stone", production["stone"] * delta)
    ResourceManager.add_resource("gold", production["gold"] * delta)

    if Engine.get_process_frames() % 45 == 0:
        emit_signal("city_updated")

func build_building(type: String) -> bool:
    if not BUILD_COSTS.has(type):
        return false

    var cost = BUILD_COSTS[type]
    if not ResourceManager.can_afford(cost):
        return false

    for resource_name in cost:
        ResourceManager.spend_resource(resource_name, cost[resource_name])

    if buildings.has(type):
        buildings[type] += 1
    else:
        buildings[type] = 1

    if type == "farm":
        population += 2
    elif type == "barracks":
        population += 3
    elif type == "wall":
        population += 1

    emit_signal("city_updated")
    return true

func _draw() -> void:
    var bg_color = Color(0.17, 0.35, 0.20)
    draw_rect(Rect2(0, 0, 520, 380), bg_color)

    var wall_color = Color(0.52, 0.52, 0.52)
    draw_rect(Rect2(40, 40, 440, 300), wall_color, false, 3.0)

    var positions = {
        "town_hall": Vector2(220, 145),
        "farm": Vector2(95, 240),
        "lumbermill": Vector2(145, 80),
        "quarry": Vector2(360, 85),
        "barracks": Vector2(365, 240),
        "wall": Vector2(220, 35),
    }

    var colors = {
        "town_hall": Color(0.85, 0.70, 0.15),
        "farm": Color(0.30, 0.75, 0.25),
        "lumbermill": Color(0.65, 0.45, 0.18),
        "quarry": Color(0.58, 0.62, 0.68),
        "barracks": Color(0.75, 0.28, 0.18),
        "wall": Color(0.45, 0.46, 0.53),
    }

    for building_name in positions:
        var count = max(1, buildings.get(building_name, 0))
        for i in range(count):
            var offset = Vector2((i % 2) * 22, (i / 2) * 18)
            var rect_pos = positions[building_name] + offset
            var rect_size = Vector2(50, 35)
            draw_rect(Rect2(rect_pos, rect_size), colors[building_name], true)
            draw_rect(Rect2(rect_pos, rect_size), Color(0.0, 0.0, 0.0, 0.4), false, 2.0)

    draw_circle(Vector2(230, 150), 22, Color(0.9, 0.9, 0.8))

func get_save_data() -> Dictionary:
    return {
        "population": population,
        "buildings": buildings,
        "resources": ResourceManager.resources,
    }

func load_save_data(data: Dictionary) -> void:
    if data.is_empty():
        return

    if data.has("population"):
        population = int(data["population"])
    if data.has("buildings"):
        buildings = data["buildings"]
    if data.has("resources"):
        ResourceManager.resources = data["resources"]
    emit_signal("city_updated")
