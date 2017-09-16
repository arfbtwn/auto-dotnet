# mcs based .NET Makefile
#
# OUTPUT      := Assembly.{dll|exe|netmodule|foo}
# OPTS        := Passed directly
# LIBS        := Passed directly
# FLAGS       := Passed with -d:
# TARGET      := Passed with -target:
# PLATFORM    := Passed with -platform:
# SDK         := Passed with -sdk:
#
# SOURCES     := Passed directly
# KEYFILE     := Passed with -keyfile:
# RESOURCES   := Passed with -resource:
# REFERENCES  := Passed with -r:
#
# GAC         := GAC references
# PACKAGES    := pkg-config references
#
# Compatibility Options
#
# ASSEMBLY    := Assembly name (requires known TARGET)

_target_.exe       := exe
_target_.dll       := library
_target_.netmodule := module

_suffix_exe     := exe
_suffix_winexe  := exe
_suffix_library := dll
_suffix_module  := netmodule

if ENABLE_RELEASE
FLAGS := RELEASE
OPTS  := -debug- -optimize+
else
FLAGS := DEBUG TRACE
OPTS  := -debug+ -optimize-
endif

SDK      ?= 4.5
PLATFORM ?= anycpu
TARGET   ?= $(_target_$(suffix $(OUTPUT)))
OUTPUT   ?= $(ASSEMBLY).$(_suffix_$(TARGET))

$(OUTPUT): .keyfile .sources .resources .references | .doc
$(OUTPUT):
	$(MCS) \
		 -platform:$(PLATFORM) \
		 -sdk:$(SDK) \
		 -target:$(TARGET) \
		 -out:$@ \
		 $(addprefix -d:,$(FLAGS)) \
		 $(OPTS) \
		 $(strip $(foreach _,$|,$(file < $_))) \
		 $(strip $(foreach _,$^,$(file < $_)))

$(DOC):

.doc: $(DOC)
	$(file > $@,$(addprefix -doc:,$<))

.keyfile: $(KEYFILE)
	$(file > $@,$(addprefix -keyfile:,$<))

.sources: $(SOURCES)
	$(file > $@,$^)

.resources: $(RESOURCES)
	$(file > $@,$(addprefix -resource:,$^))

.references: $(REFERENCES)
	$(file >  $@,$(addprefix   -r:,$^))
	$(file >> $@,$(addprefix   -r:,$(GAC)))
	$(file >> $@,$(addprefix -pkg:,$(PACKAGES)))

$(REFERENCES):
	$(MAKE) -C $(dir $@) $(notdir $@)
