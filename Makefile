play:
	@echo "> create playground..."
	@mkdir -p playground/config/nvim/lua
	@mkdir -p playground/config/nvim/plugin
	@ln -sf $(PWD)/lua/tabby           $(PWD)/playground/config/nvim/lua
	@ln -sf $(PWD)/plugin/tabby.vim    $(PWD)/playground/config/nvim/plugin/tabby.vim
	@echo "> sync plugins..."
	@nvim -u ./playground/config.lua --headless "+Lazy! sync" +qa
	@echo "> run tests nvim..."
	@nvim -u ./playground/config.lua -R -p lua/tabby/feature/tabwins.lua lua/tabby/feature/lines.lua \
		"+0tabnew" "+terminal" "+tabnext $$" "+vs README.md"

clear-play:
	@echo "> remove test environment..."
	@-rm -rf ./playground/config ./playground/data ./playground/state ./playground/cache
	@git checkout -- playground/config.lua

gendoc:
	@echo "> generate documents..."
	@panvimdoc \
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
