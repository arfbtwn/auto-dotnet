_icondir_ = $(datarootdir)/pixmaps/$1
_icons_   = $(wildcard ThemeIcons/$1)

RESOLUTIONS = 16x16 22x22 24x24 32x32 48x48 192x192 scalable
CATEGORIES  = actions categories devices emblems status

# These targets shamefully stolen from a generated
# Makefile with xdir and x_DATA variables
#
# $1 = resolution
# $2 = category
define _icon_targets_
$(eval $1$2dir = $(call _icondir_,$1/$2/))
$(eval $1$2_DATA = $$(wildcard $$(srcdir)/ThemeIcons/$1/$2/*.png $$(srcdir)/ThemeIcons/$1/$2/*.svg))
install-$(1)$(2)DATA: $($(1)$(2)_DATA)
	@$(NORMAL_INSTALL)
	@list='$$($(1)$(2)_DATA)'; test -n "$$($(1)$(2)dir)" || list=; \
	if test -n "$$$$list"; then \
	  echo " $$(MKDIR_P) '$$(DESTDIR)$$($(1)$(2)dir)'"; \
	  $$(MKDIR_P) "$$(DESTDIR)$$($(1)$(2)dir)" || exit 1; \
	fi; \
	for p in $$$$list; do \
	  if test -f "$$$$p"; then d=; else d="$$(srcdir)/"; fi; \
	  echo "$$$$d$$$$p"; \
	done | $$(am__base_list) | \
	while read files; do \
	  echo " $$(INSTALL_DATA) $$$$files '$$(DESTDIR)$$($(1)$(2)dir)'"; \
	  $$(INSTALL_DATA) $$$$files "$$(DESTDIR)$$($(1)$(2)dir)" || exit $$$$?; \
	done

uninstall-$(1)$(2)DATA:
	@$(NORMAL_UNINSTALL)
	@list='$$($(1)$(2)_DATA)'; test -n "$$($(1)$(2)dir)" || list=; \
	files=`for p in $$$$list; do echo $$$$p; done | sed -e 's|^.*/||'`; \
	dir='$$(DESTDIR)$$($(1)$(2)dir)'; $$(am__uninstall_files_from_dir)

install-data-am: install-$(1)$(2)DATA
uninstall-am: uninstall-$(1)$(2)DATA
endef

$(foreach res,$(RESOLUTIONS),$(foreach cat,$(CATEGORIES),$(eval $(call _icon_targets_,$(res),$(cat)))))
