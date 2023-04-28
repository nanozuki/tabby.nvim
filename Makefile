test-nvim:
	mkdir -p testenv/cache/nvim
	mkdir -p testenv/data/nvim
	mkdir -p testenv/config/nvim/lua
	mkdir -p testenv/config/nvim/plugin
	-rm -rf ./testenv/config/nvim/lua/tabby
	cp -r ./lua/tabby ./testenv/config/nvim/lua/
	-rm ./testenv/config/nvim/plugin/tabby.vim
	cp ./plugin/tabby.vim  ./testenv/config/nvim/plugin/
	-cp -n ./testdata/config.lua ./testenv/config/nvim/init.lua
	-cp -n ./testdata/setup.lua ./testenv/config/nvim/lua/setup.lua
	XDG_DATA_HOME=./testenv/data XDG_CONFIG_HOME=./testenv/config XDG_CACHE_HOME=./testenv/cache \
		nvim -R -S ./testdata/Session.vim

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
