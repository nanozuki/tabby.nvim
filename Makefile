test-nvim:
	@echo "> create test environment..."
	@mkdir -p testenv/config/nvim/lua
	@mkdir -p testenv/config/nvim/plugin
	@-cp -n ./testdata/config.lua ./testenv/config/nvim/init.lua
	@ln -sf $(PWD)/testdata/setup.lua  $(PWD)/testenv/config/nvim/lua/setup.lua
	@ln -sf $(PWD)/lua/tabby           $(PWD)/testenv/config/nvim/lua
	@ln -sf $(PWD)/plugin/tabby.vim    $(PWD)/testenv/config/nvim/plugin/tabby.vim
	@echo "> sync plugins..."
	@nvim -u ./testenv/config/nvim/init.lua --headless "+Lazy! sync" +qa
	@echo "> run tests nvim..."
	@nvim -u ./testenv/config/nvim/init.lua -R -p lua/tabby/feature/tabwins.lua lua/tabby/feature/lines.lua \
		"+0tabnew" "+terminal" "+tabnext $$" "+vs README.md"

clear-test-nvim:
	@echo "> remove test environment..."
	@-rm -rf ./testenv

gendoc:
	@echo "> install and update panvimdoc..."
	@if [ ! -d "panvimdoc" ]; then git clone https://github.com/nanozuki/panvimdoc.git; fi
	@cd panvimdoc && git pull && cd ..
	@echo "> generate documents..."
	@panvimdoc/panvimdoc.sh \
		--project-name tabby \
		--input-file README.md \
		--vim-version 0.5 \
		--toc 'true' \
		--description 'A declarative, highly configurable tabline plugin' \
		--dedup-subheadings 'true' \
		--demojify 'false' \
		--treesitter 'true' \
		--ignore-rawblocks 'true' \
		--doc-mapping 'false' \
		--doc-mapping-project-name 'true' \
		--shift-heading-level-by -1 \
		--increment-heading-level-by 0

check-typo:
	@typos lua/**/*.lua README.md
