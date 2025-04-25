class_name CWandTypes
static var Components:IComponents
static var Events:IEvents
static var Machines:IMachines

class IComponents:
	static var m_sBaseType:StringName = "BaseComponent"
	static var m_sMachineInputType:StringName = "MachineInput"
	static var m_sMachineOutputType:StringName = "MachineOutput"
	static var m_sMachineStorageType:StringName  = "MachineStorage"

class IMachines:
	static var m_conveyor:StringName = "Conveyor"
	static var m_drill:String = "Drill"

class IEvents:
	static var m_sEventMachineInputCreated:StringName  = "MachineInputCreated"
	static var m_sEventMachineOutputCreated:StringName  = "MachineOutputCreated"
	static var m_sEventMachineDestroyed:StringName  = "MachineDestroyed"
	