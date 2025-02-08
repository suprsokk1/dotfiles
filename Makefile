check  = --dry-run -- dotfiles/ $(HOME)/
export = -- dotfiles/ $(HOME)/
import = -- $(HOME)/ dotfiles/

.PHONY: default
default: check

.PHONY: install
install: export fonts theme

.PHONY: import export check
import export check:
	find dotfiles/ -type f -printf '%P\0' | rsync --files-from=- --from0 --backup-dir $(HOME)/Backup/rsync/$(shell systemd-escape $(PWD))-$(shell date +%s) --verbose $(call $@)

.PHONY: clean-ignored
clean-ignored:
	git clean --dry-run --force -X

.PHONY: fonts theme
fonts theme:
	$(HOME)/.local/bin/pkl eval etc/$@.pkl -m $(HOME)/ | sed -En -e '/sway/s#.*#sway reload#ep' -e '/waybar/s#.*#pkill -SIGUSR2 waybar#ep'
