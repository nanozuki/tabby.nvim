test-nvim:
	mkdir -p testenv/cache/nvim
	-rm -rf ./testenv/data/nvim/site/pack/tabby/start/tabby
	mkdir -p testenv/data/nvim/site/pack/tabby/start/tabby
	mkdir -p testenv/config/nvim/plugin
	cp -r ./{lua,plugin} ./testenv/data/nvim/site/pack/tabby/start/tabby
	-cp -n ./testdata/mini-config.lua ./testenv/config/nvim/init.lua
	XDG_DATA_HOME=./testenv/data/ XDG_CONFIG_HOME=./testenv/config/ XDG_CACHE_HOME=./testenv/cache/ nvim

clear-test-nvim:
	-rm -rf ./testenv
