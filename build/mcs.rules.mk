# mcs based .NET Makefile
#
# SRC := Passed directly
# RES := Passed with -resource:
# REF := Passed with -r:
#
# GAC := GAC references
# PKG := pkg-config references

_isndef_ = $(findstring undefined,$(origin $1))
_ifndef_ = $(if $(call _isndef_,$1),$2,$($1))
_choose_ = $(call _ifndef_,$1,$($2))

AL  ?= al
MCS ?= mcs
SN  ?= sn

if ENABLE_RELEASE
MCSARGS = -d:RELEASE -debug- -optimize+
else
MCSARGS = -d:DEBUG -d:TRACE -debug+ -optimize-
endif

sign-%.dll: %.dll %.snk
	$(SN) -R $^

sign-%.exe: %.exe %.snk
	$(SN) -R $^

%.exe %.exe.mdb: target = exe

%.dll %.dll.mdb \
%.exe %.exe.mdb \
%.netmodule %.netmodule.mdb \
: _mcsargs = $(call _choose_,$*_MCSARGS,MCSARGS)

%.dll %.dll.mdb \
%.exe %.exe.mdb \
: _alargs  = $(call _choose_,$*_ALARGS,ALARGS)

%.dll %.dll.mdb: .src.% .res.% .ref.%
	$(MCS) $(_mcsargs) $(foreach _,$^,$(strip $(file < $_))) -target:library -out:$@

%.exe %.exe.mdb: .src.% .res.% .ref.%
	$(MCS) $(_mcsargs) $(foreach _,$^,$(strip $(file < $_))) -target:$(target) -out:$@

%.netmodule %.netmodule.mdb: .src.% .res.% .ref.%
	$(MCS) $(_mcsargs) $(foreach _,$^,$(strip $(file < $_))) -target:module -out:$@

%.dll %.dll.mdb: %.netmodule
	$(AL) $(_alargs) -target:library -out:$@ $<

%.exe %.exe.mdb: %.netmodule
	$(AL) $(_alargs) -target:$(target) -out:$@ $<

.SECONDEXPANSION:

.src.%: $$($$*_SRC)
	$(file > $@,$^)

.res.%: $$($$*_RES)
	$(file > $@,$(addprefix -resource:,$^))

.ref.%: _gac = $(call _choose_,$*_GAC,GAC)
.ref.%: _pkg = $(call _choose_,$*_PKG,PKG)
.ref.%: $$($$*_REF)
	$(file >  $@,$(addprefix   -r:,$^))
	$(file >> $@,$(addprefix   -r:,$(_gac)))
	$(file >> $@,$(addprefix -pkg:,$(_pkg)))
