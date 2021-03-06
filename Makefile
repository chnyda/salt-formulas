help:
	@echo "submodules    Get submodules"
	@echo "update        Checkout master, get submodules and pull all formulas"
	@echo "release       Make new major release of all formulas"
	@echo "mrconfig      Re-generate .mrconfig with all formulas on Github"
	@echo "html          Build html documentation"
	@echo "pdf           Build pdf documentation"

pull:
	git pull --rebase

submodules: pull
	git submodule init
	git submodule update

update: submodules
	(for formula in formulas/*; do FORMULA=`basename $$formula` && cd $$formula && git remote set-url --push origin git@github.com:salt-formulas/salt-formula-$$FORMULA.git && cd ../..; done)
	mr --trust-all -j4 run git checkout master
	mr --trust-all -j4 update

release:
	mr --trust-all -j4 run make release-major

mrconfig:
	./scripts/update_mrconfig.py

html:
	make -C doc html

pdf:
	make -C doc latexpdf
