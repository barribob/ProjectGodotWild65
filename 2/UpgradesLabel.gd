extends Label

func _ready():
    EventBus.upgrade_added.connect(upgrade_added)

func upgrade_added(upgrades_by_type):
    text = "Current Upgrades:"
    for upgrade_type in upgrades_by_type:
        text += "\n %s %s" % [upgrade_type.name, Utils.format_whole(upgrades_by_type[upgrade_type].size())]
