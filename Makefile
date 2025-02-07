check  = --dry-run -- dotfiles/ $(HOME)/
export = -- dotfiles/ $(HOME)/
import = -- $(HOME)/ dotfiles/

default: check

import check:
	find dotfiles/ -type f -printf '%P\0' | rsync --files-from=- --from0 --backup-dir $(HOME)/Backup/rsync/$(shell systemd-escape $(PWD))-$(shell date +%s)  --verbose $(call $@)
