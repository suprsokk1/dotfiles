check  = --dry-run -- dotfiles/ $(HOME)/
export = -- dotfiles/ $(HOME)/
import = -- $(HOME)/ dotfiles/

default: check

import check:
	rsync --backup-dir $(HOME)/Backup/rsync/$(shell systemd-escape $(PWD))-$(shell date +%s)  --verbose --recursive $(call $@)
