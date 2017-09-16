# xbuild based .NET Makefile
#
# TARGET = *.{csproj|sln}
# OPTS   = Passed verbosely to $(XBUILD)

XBUILD ?= xbuild

include $(top_srcdir)/build/dotnet.env.mk

if ENABLE_RELEASE
CONFIG := Release
else
CONFIG := Debug
endif

_xbuild_opts = $(OPTS) /p:Configuration=$(CONFIG)

all:
	$(XBUILD) /target:Build $(_xbuild_opts) $(TARGET)

rebuild:
	$(XBUILD) /target:Rebuild $(_xbuild_opts) $(TARGET)

clean:
	$(XBUILD) /target:Clean $(_xbuild_opts) $(TARGET)

.PHONY: rebuild
