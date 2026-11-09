extends CanvasLayer

signal build_requested(type: String)
signal save_requested
signal load_requested

@onready var wood_label: Label = $Panel/Resources/WoodLabel
@onready var food_label: Label = $Panel/Resources/FoodLabel
@onready var stone_label: Label = $Panel/Resources/StoneLabel
@onready var gold_label: Label = $Panel/Resources/GoldLabel
@onready var population_label: Label = $Panel/Resources/PopulationLabel
@onready var day_label: Label = $Panel/Resources/DayLabel
@onready var status_label: Label = $Panel/StatusText

func _ready() -> void:
    $Panel/Builds/BuildFarmButton.pressed.connect(func() -> void: emit_signal("build_requested", "farm"))
    $Panel/Builds/BuildLumberButton.pressed.connect(func() -> void: emit_signal("build_requested", "lumbermill"))
    $Panel/Builds/BuildQuarryButton.pressed.connect(func() -> void: emit_signal("build_requested", "quarry"))
    $Panel/Builds/BuildBarracksButton.pressed.connect(func() -> void: emit_signal("build_requested", "barracks"))
    $Panel/Builds/BuildWallButton.pressed.connect(func() -> void: emit_signal("build_requested", "wall"))
    $Panel/Builds/SaveButton.pressed.connect(func() -> void: emit_signal("save_requested"))
    $Panel/Builds/LoadButton.pressed.connect(func() -> void: emit_signal("load_requested"))
    update_resources(ResourceManager.resources)

func update_resources(resources: Dictionary) -> void:
    wood_label.text = "Wood: %d" % int(resources.get("wood", 0.0))
    food_label.text = "Food: %d" % int(resources.get("food", 0.0))
    stone_label.text = "Stone: %d" % int(resources.get("stone", 0.0))
    gold_label.text = "Gold: %d" % int(resources.get("gold", 0.0))

func update_city(population: int, buildings: Dictionary) -> void:
    population_label.text = "Population: %d" % population
    day_label.text = "Day: %d" % max(1, buildings.get("town_hall", 0))

func set_status(message: String) -> void:
    status_label.text = message
