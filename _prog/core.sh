
#_app_konsole() {
#	_userFakeHome "$scriptAbsoluteLocation" --parent _abstractfs konsole "$@"
#}

# Static parameters. Must be accepted if function overridden to point script contained installation.
_app_command_static() {
	# WARNING: Apparently, freecad ignores or does not use entirely as expected, all variables and command line parameters, related to redirecting the "$HOME"/.FreeCAD directory or subdirectories.
	#mkdir -p "$scriptLocal"/freecad_modules_extra
	#"$appExecutable" --module-path "$scriptLocal"/freecad_modules_extra --user-cfg "$UserParameter" --system-cfg "$SystemParameter" "$@"
	
	"$appExecutable" "$@"
}

#command
_app_command() {
	# DANGER: Consistent directory naming *REQUIRED* for assembly2 projects!
	# Force creation of 'project.afs' .
	export afs_nofs=false
	
	
	# Translate all file parameters to absolute paths. Precautionary, may or may not be necessary.
	export sharedHostProjectDir=/
	export sharedGuestProjectDir=/
	_virtUser "$@"
	
	
	# https://forum.freecadweb.org/viewtopic.php?f=3&t=30573
	
	# https://github.com/FreeCAD/FreeCAD/releases/tag/0.18.4
	# https://github.com/FreeCAD/FreeCAD/releases/download/0.18.4/FreeCAD_0.18-16146-Linux-Conda_Py3Qt5_glibc2.12-x86_64.AppImage
	# FreeCAD_0.18-16146-Linux-Conda_Py3Qt5_glibc2.12-x86_64.AppImage
	#export appExecutable="$scriptLocal"/setups/FreeCAD_0.18-16146-Linux-Conda_Py3Qt5_glibc2.12-x86_64.AppImage
	
	# https://github.com/FreeCAD/FreeCAD/releases/tag/0.19_pre
	# https://github.com/FreeCAD/FreeCAD/releases/download/0.19_pre/FreeCAD_0.19-22039-Linux-Conda_glibc2.12-x86_64.AppImage
	# FreeCAD_0.19-22039-Linux-Conda_glibc2.12-x86_64.AppImage
	export appExecutable="$scriptLocal"/setups/FreeCAD_0.19-22039-Linux-Conda_glibc2.12-x86_64.AppImage
	
# 	export appExecutable="konsole"
	
# 	export appExecutable="freecad"
	
	# WARNING: Apparently, AppImage and/or freecad ignores "$HOME" variable used by "_fakeHome" in favor of either its own internal system or result from '/etc/passwd' .
# 	export UserHomePath="$HOME"
# 	export UserAppData="$HOME"/.FreeCAD
# 	export UserParameter="$UserAppData"/user.cfg
# 	export SystemParameter="$UserAppData"/system.cfg
# 	#export PYTHONHOME="$HOME"
	
	# WARNING: Apparently, AppImage and/or freecad ignores "$HOME" variable used by "_fakeHome" in favor of either its own internal system or result from '/etc/passwd' .
# 	mkdir -p "$appExecutable".home
# 	mkdir -p "$appExecutable".config
# 	"$appExecutable" --appimage-portable-home > /dev/null 2>&1
# 	"$appExecutable" --appimage-portable-config > /dev/null 2>&1
# 	export UserHomePath="$appExecutable".home
# 	export UserAppData="$appExecutable".home/.FreeCAD
# 	export UserParameter="$UserAppData"/user.cfg
# 	export SystemParameter="$UserAppData"/system.cfg
# 	#export PYTHONHOME="$appExecutable".home
	
# 	_abstractfs "$appExecutable" "${processedArgs[@]}"
	_abstractfs _app_command_static "${processedArgs[@]}"
}

#edit
_app_edit() {
	# WARNING: Apparently, AppImage and/or freecad ignores "$HOME" variable used by "_fakeHome" in favor of either its own internal system or result from '/etc/passwd' .
	_editFakeHome "$scriptAbsoluteLocation" --parent _app_command "$@"
}

#user
_app_user() {
	# WARNING: Apparently, AppImage and/or freecad ignores "$HOME" variable used by "_fakeHome" in favor of either its own internal system or result from '/etc/passwd' .
	_userFakeHome "$scriptAbsoluteLocation" --parent _app_command "$@"
}

#virtualized
_v_app() {
	# WARNING: Apparently, AppImage and/or freecad ignores "$HOME" variable used by "_fakeHome" in favor of either its own internal system or result from '/etc/passwd' .
# 	_userQemu "$scriptAbsoluteLocation" _app_user "$@"
	_userQemu "$scriptAbsoluteLocation" _app_command "$@"
}

#default
_app() {
	if ! _check_prog
	then
		_messageNormal 'Launch: _v'${FUNCNAME[0]}
		_v${FUNCNAME[0]} "$@"
		return
	fi
	
	# WARNING: Apparently, AppImage and/or freecad ignores "$HOME" variable used by "_fakeHome" in favor of either its own internal system or result from '/etc/passwd' .
# 	_app_user "$@" && return 0
	_app_command "$@" && return 0

	#_messageNormal 'Launch: _v'${FUNCNAME[0]}
	#_v${FUNCNAME[0]} "$@"
}
_freecad-assembly2() {
	# https://github.com/hamish2014/FreeCAD_assembly2
	# 2da784f18b8af16facf3c0e28a69f0430dc7bb60
	_app "$@"
}
_freecad-assembly4() {
	# https://github.com/Zolko-123/FreeCAD_Assembly4
	# 4714df86e97e7b2ee1bb8ffd5a1b676c464a4302
	
	# DANGER: Not thoroughly tested successfully. Several errors or warning messages are shown which may have untested consequences from minor nuisance to cripling malfunction.
	# If assembly2 module is present (even to be used only with prior FreeCAD version 0.18.4), irrelevant popup error message will appear.
		# File does not exist!
		# /:/assembly2/icons/workBenchIcon.svg
	# When switching to assembly4 workbench through the GUI, several ominous error messages appear under "Report view" .
		# Unknown command 'Part_Import'
		# Unknown command 'Asm4_insertRod'
		# Unknown command 'Asm4_FSparameters'
	
	_app "$@"
}








_refresh_anchors_specific() {
	#_refresh_anchors_specific_single_procedure _freecad-assembly2
	_refresh_anchors_specific_single_procedure _freecad-assembly4
}


_refresh_anchors_user() {
	#_refresh_anchors_user_single_procedure _freecad-assembly2
	_refresh_anchors_user_single_procedure _freecad-assembly4
}

_associate_anchors_request() {
	if type "_refresh_anchors_user" > /dev/null 2>&1
	then
		_tryExec "_refresh_anchors_user"
		#return
	fi
	
	#_messagePlain_request 'association: dir'
	#echo _scope_konsole"$ub_anchor_suffix"
	
	
	#_messagePlain_request 'association: dir, *.FCStd'
	#echo _freecad-assembly2"$ub_anchor_suffix"
	
	_messagePlain_request 'association: *.FCStd'
	#echo _freecad-assembly2"$ub_anchor_suffix"
	
	#_messagePlain_request 'association: *.FCStd'
	echo _freecad-assembly4"$ub_anchor_suffix"
}


#duplicate _anchor
_refresh_anchors() {
	#_refresh_anchors_ubiquitous
	
	#cp -a "$scriptAbsoluteFolder"/_anchor "$scriptAbsoluteFolder"/_app_konsole
	
	#cp -a "$scriptAbsoluteFolder"/_anchor "$scriptAbsoluteFolder"/_freecad-assembly2
	cp -a "$scriptAbsoluteFolder"/_anchor "$scriptAbsoluteFolder"/_freecad-assembly4
}


#####^ Core
