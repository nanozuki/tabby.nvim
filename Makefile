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
	XDG_DATA_HOME=./testenv/data XDG_CONFIG_HOME=./testenv/config XDG_CACHE_HOME=./testenv/cache nvim --headless -c 'lua Bootstrap()'
	XDG_DATA_HOME=./testenv/data XDG_CONFIG_HOME=./testenv/config XDG_CACHE_HOME=./testenv/cache nvim

clear-test-nvim:
	-rm -rf ./testenv
