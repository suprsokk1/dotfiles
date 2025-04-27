check			 = dotfiles/ $(HOME)/
check_rsync		 = --dry-run
export			 = dotfiles/ $(HOME)/
import			 = $(HOME)/ dotfiles/
prepare			 = dotfiles/ $(HOME)/
prepare_rsync	 = --dry-run --recursive
backup_dir		 = $(HOME)/Backup/rsync/$(shell systemd-escape $(PWD))-$(shell date +%s)
git-dirs		 = $(subst /.git,,$(wildcard $(HOME)/*/*/.git))
sysd			 = $(foreach ITEM,$(git-dirs),$(HOME)/.config/system/user/paths.target.wants/git@$(shell systemd-escape --path $(ITEM)).path)


path: $(sysd)

%.path: %
	$(file > /dev/stdout,$@ -> $(shell systemd-escape -u ${^}))

.PHONY: default
default: check

.PHONY: install
install: clean themes fonts export

.PHONY: import export check prepare
import export check prepare: install.dat
	rsync $(call ${@}_rsync) --files-from=$^ --from0 --backup-dir ${backup_dir} --verbose -- $(call $@)

install.dat:
ifeq (1,1)
	find dotfiles/ -type f -iwholename '*$(call filter-$(@))*' -fprintf $@ '%P\0'
else
	git -C dotfiles/ ls-files --modified --format='%(path)%x00' | sed -zE -e 's,\x0a,,g' -e w$@
endif

hardlink: $(HOME)/.config/rofi/scripts/menu.sh

# $(HOME)/.config/rofi/scripts/%.sh.target:

.PHONY: clean
clean:
	rm -vf -- *.dat

.PHONY: clean-ignored
clean-ignored:
	git clean --dry-run --force -X

.PHONY: theme fonts
theme font:
	$(HOME)/.local/bin/pkl eval etc/pkl/$@.pkl -m $(HOME)/

expect exp:
	./etc/makefile-helper.exp

$(HOME)/% %:;$(file > /dev/stdout,FALLBACK($@))
