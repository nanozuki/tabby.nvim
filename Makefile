test-nvim:
	mkdir -p testenv/cache/nvim
	mkdir -p testenv/data/nvim
	mkdir -p testenv/config/nvim/plugin
	mkdir -p testenv/config/nvim/lua
	-rm -rf ./testenv/config/nvim/lua/tabby
	cp -r ./lua/tabby ./testenv/config/nvim/lua/
	-rm ./testenv/config/nvim/plugin/tabby.vim
	cp ./plugin/tabby.vim  ./testenv/config/nvim/plugin/
	-cp -n ./testdata/mini-config.lua ./testenv/config/nvim/init.lua
	-cp -n ./testdata/setup.lua ./testenv/config/nvim/lua/setup.lua
	-cp -n ./testdata/use_theme.lua ./testenv/config/nvim/lua/use_theme.lua
	XDG_DATA_HOME=./testenv/data XDG_CONFIG_HOME=./testenv/config XDG_CACHE_HOME=./testenv/cache \
		nvim --headless -u ./testdata/plugin.lua -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
	XDG_DATA_HOME=./testenv/data XDG_CONFIG_HOME=./testenv/config XDG_CACHE_HOME=./testenv/cache \
		nvim -S ./testdata/Session.vim

clear-test-nvim:
	-rm -rf ./testenv

gendoc:
	@if [ ! -d "panvimdoc" ]; then git clone https://github.com/kdheepak/panvimdoc.git; fi
	@pandoc --metadata=project:tabby --metadata=vimversion:0.5.0 \
		--lua-filter panvimdoc/scripts/skip-blocks.lua --lua-filter panvimdoc/scripts/include-files.lua \
		-t panvimdoc/scripts/panvimdoc.lua README.md -o doc/tabby.txt

