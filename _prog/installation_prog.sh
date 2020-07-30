_check_prog() {
	# ATTENTION: AppImage. No known dependencies.
	#! _typeDep dependency && return 1
	
	return 0
}

_test_prog() {
	# ATTENTION: AppImage. No known dependencies.
	#_getDep dependency
	
	#! _check_prog && echo 'missing: dependency mismatch' && stop 1
	return 0
}

_setup_prog() {
	_messagePlain_request 'request: BEWARE: Apparently, freecad ignores or does not use entirely as expected, all variables and command line parameters, related to redirecting the "$HOME"/.FreeCAD directory or subdirectories. '
	_messagePlain_request 'request: install and manually test assembly2 module '
	
	return 0
}
