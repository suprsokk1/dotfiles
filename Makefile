check   = dotfiles/ $(HOME)/
check_rsync = --dry-run
export  = dotfiles/ $(HOME)/
import  = $(HOME)/ dotfiles/
prepare = dotfiles/ $(HOME)/
prepare_rsync = --dry-run --recursive
backup_dir = $(HOME)/Backup/rsync/$(shell systemd-escape $(PWD))-$(shell date +%s)

.PHONY: default
default: check

.PHONY: install
install: $(nest)
ifndef nest
	make install nest="export themes fonts" | ./etc/makefile-helper.sed
endif

.PHONY: import export check prepare
import export check prepare:
	find dotfiles/ -type f -printf '%P\0' | \
      rsync $(call ${@}_rsync) --files-from=- --from0 --backup-dir ${backup_dir} --verbose -- $(call $@)

.PHONY: clean-ignored
clean-ignored:
	git clean --dry-run --force -X

.PHONY: themes fonts
themes fonts:
	$(HOME)/.local/bin/pkl eval etc/$@.pkl -m $(HOME)/
