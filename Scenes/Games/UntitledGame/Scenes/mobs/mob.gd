extends Node2D

var resistMap : Dictionary
var statusMap : Dictionary
var currentStatusMap: Dictionary

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	DesignData.LoadTable(DesignData.CResistanceData.m_tableName)
	DesignData.LoadTable(DesignData.CStatusData.m_tableName)
	initResistances()
	initStatuses()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func initResistances() -> void:
	var resistances: Array = DesignData.GetKeys("Resistances")
	for resist in resistances:
		resistMap[DesignData.GetData("Resistances", resist).m_name + "Resist"] = DesignData.GetData("Resistances", resist).m_resist
		resistMap[DesignData.GetData("Resistances", resist).m_name + "Health"] = DesignData.GetData("Resistances", resist).m_health

func initStatuses() -> void:
	var statuses: Array = DesignData.GetKeys("Statuses")
	for status in statuses:
		statusMap[DesignData.GetData("Statuses", status).m_name + "Buildup"] = DesignData.GetData("Statuses", status).m_statusBuildup
		statusMap[DesignData.GetData("Statuses", status).m_name + "Threshold"] = DesignData.GetData("Statuses", status).m_threshold
		currentStatusMap[DesignData.GetData("Statuses", status).m_name] = DesignData.GetData("Statuses", status).m_statusBuildup
	updateStatus()
	checkStatus()

func updateStatus() -> void:
	print("\nResist Map: ", resistMap)
	pass

func checkStatus() -> void:
	print("\n\nStatus Map: ", statusMap)
	pass