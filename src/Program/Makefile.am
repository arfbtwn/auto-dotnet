include $(top_srcdir)/build/dotnet.env.mk
include $(top_srcdir)/build/mcs.rules.mk
include $(top_srcdir)/build/nuget.rules.mk

assembly_SCRIPTS = Program.exe

Program.exe: target = winexe

Program.exe: .nuget.Program

.nuget.Program:
	$(file > $@,$(NUNIT_LIBS) $(NEWTONSOFT_LIBS))

Program_SRC = Program.cs
Program_REF = ../Library/Library.dll ../Library2/Library2.dll
Program_GAC = System System.Web

$(Program_REF):
	$(MAKE) -C $(dir $@) $(notdir $@)

NUGET := NUnit Newtonsoft.Json

NUGET_NUnit           := 2.6.4 lib
NUGET_Newtonsoft.Json := 6.0.8 lib/net45

bin_SCRIPTS = program

program:
	$(file >  $@,#!/bin/sh)
	$(file >> $@,path=$${path:-$(assemblydir)})
	$(file >> $@,lib=$${lib:-$(assemblydir)})
	$(file >> $@,MONO_PATH=$$path mono $$lib/Program.exe $$*)

CLEANFILES = program Program.exe{,.mdb}
