#
# Utils.gd - Project-wide utils functions
#

extends Node

#
# Connects two objects and checks for any error
#
func conn_nodes(srcObj: Object,
		srcSignal: String,
		destObj: Object,
		destFunc: String,
		binds: Array = [],
		flags: int = 0) -> void:

	if (!srcObj.is_connected(srcSignal, destObj, destFunc)):
		var error := srcObj.connect(srcSignal, destObj, destFunc, binds, flags)
		if (error):
			printerr("Error (" + String(error) + ") connecting " + srcSignal + " to " + destFunc)
	else:
		printerr(srcSignal + " is already connected to " + destFunc + " for objects: ", srcObj, " ", destObj)
