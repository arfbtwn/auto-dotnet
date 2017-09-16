# NuGet Makefile Support
#
# NUGET_OPTS := Passed directly
# NUGET_DIR  := Package cache
#
# NUGET           := NuGet packages
# NUGET_<PACKAGE> := <version> <path> e.g. 6.0.8 lib/net45

NUGET     ?= nuget
NUGET_DIR ?= $(top_builddir)/packages/

_nuget_dir_ = $(NUGET_DIR)$1.$2/

_nuget_dll_dir_      = $(_nuget_dir_$1)$2/
_nuget_dll_probe_    = $(wildcard $(_nuget_dll_dir_$1)*.dll)
_nuget_dll_resolved_ = $(notdir   $(_nuget_dll_probe_$1))

_nuget_version_ = $(word 1,$(NUGET_$1))
_nuget_hint_    = $(word 2,$(NUGET_$1))

nugetdir      = $(pkglibdir)
nuget_SCRIPTS =

define _nuget_ref_

$(eval _nuget_dir_$1          = $$(call _nuget_dir_,$1,$2))
$(eval _nuget_dll_dir_$1      = $$(call _nuget_dll_dir_,$1,$3))
$(eval _nuget_dll_probe_$1    = $$(call _nuget_dll_probe_,$1))
$(eval _nuget_dll_resolved_$1 = $$(call _nuget_dll_resolved_,$1))

$(eval  VPATH += :$$(_nuget_dll_dir_$1))

$$(_nuget_dir_$1):
	$$(NUGET) install $$(NUGET_OPTS) -OutputDirectory $$(NUGET_DIR) $1 -Version $2

nuget-$1: | $$(_nuget_dir_$1)

nuget-status: nuget-status-$1

nuget-status-$1: | nuget-$1
	@echo '$1.$2: $$(_nuget_dir_$1)'
	@echo
	@echo 'DLL dir:      $$(_nuget_dll_dir_$1)'
	@echo 'DLL probe:    $$(_nuget_dll_probe_$1)'
	@echo 'DLL resolved: $$(_nuget_dll_resolved_$1)'

distclean-local: nuget-distclean-$1

nuget-distclean-$1:
	$$(RM) -r $$(_nuget_dir_$1)

endef

$(eval $(foreach _,$(NUGET),$(call _nuget_ref_,$_,$(call _nuget_version_,$_),$(call _nuget_hint_,$_))))
