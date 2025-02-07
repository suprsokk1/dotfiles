check  = --dry-run -- dotfiles/ $(HOME)/
export = -- dotfiles/ $(HOME)/
import = -- $(HOME)/ dotfiles/

default: check

import export check:
	find dotfiles/ -type f -printf '%P\0' | rsync --files-from=- --from0 --backup-dir $(HOME)/Backup/rsync/$(shell systemd-escape $(PWD))-$(shell date +%s) --verbose $(call $@)

clean-ignored:
	git clean --dry-run --force -X

font-config:
	pkl eval etc/fonts.pkl | sh
