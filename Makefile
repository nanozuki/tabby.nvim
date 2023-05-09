test-nvim:
	mkdir -p testenv/config/nvim/lua
	mkdir -p testenv/config/nvim/plugin
	-cp -n ./testdata/config.lua ./testenv/config/nvim/init.lua
	ln -sf $(PWD)/testdata/setup.lua ./testenv/config/nvim/lua/setup.lua
	ln -sf $(PWD)/lua/tabby ./testenv/config/nvim/lua/tabby
	ln -sf $(PWD)/plugin/tabby.vim ./testenv/config/nvim/plugin/tabby.vim
	nvim -u ./testenv/config/nvim/init.lua -R -p lua/tabby/feature/tabwins.lua lua/tabby/feature/lines.lua \
		"+0tabnew" "+terminal" "+tabnext $$" "+vs README.md"

clear-test-nvim:
	-rm -rf ./testenv

gendoc:
	@if [ ! -d "panvimdoc" ]; then git clone https://github.com/kdheepak/panvimdoc.git; fi
	@gsed -e 's/^##/#/' README.md | pandoc --metadata=project:tabby \
		--metadata="description:A declarative, highly configurable tabline plugin" \
		--lua-filter panvimdoc/scripts/skip-blocks.lua --lua-filter panvimdoc/scripts/include-files.lua \
		-t panvimdoc/scripts/panvimdoc.lua -o doc/tabby.txt

check-typo:
	@typos lua/**/*.lua README.md
