ROOTDIR=$(realpath $(dir $(firstword $(MAKEFILE_LIST))))
PACKAGES_FILE=${ROOTDIR}/packages.txt


ASDF_DIR= $(HOME)/.asdf
PYTHON=python
PIP=pip
ASDF_BIN := $(ASDF_DIR)/bin/asdf
.PHONY: all clean

all: install


install: install_packages
	@echo "Installing packages from ${PACKAGES_FILE}"

git_cfg:
	git config --global core.editor "vim"
	git config --global credential.helper store
	git config --global user.email "pawel.trajdos@pwr.edu.pl"
	git config --global user.name "ptrajdos"

install_packages:
	sudo pkg update
	sudo pkg upgrade -y
	sudo  pkg install -y $$(grep -Ev '^\s*(#|$$)' $(PACKAGES_FILE))


zerotier:
	sudo pkg install -y zerotier
	sudo sysrc zerotier_enable="YES"
	sudo service zerotier start



$(ASDF_DIR): install_packages git_cfg
	@if [ ! -d "$(ASDF_DIR)" ]; then \
		echo "Cloning asdf..."; \
		git clone https://github.com/asdf-vm/asdf.git ${ASDF_DIR} --branch v0.14.1;\
		echo '. "$$HOME/.asdf/asdf.sh"' >>${HOME}/.bashrc;\
		echo '. "$$HOME/.asdf/completions/asdf.bash"' >>${HOME}/.bashrc; \
	else \
			echo "asdf already installed at $(ASDF_DIR)"; \
	fi

asdf_plugins: $(ASDF_DIR)
	bash -c '. $(ASDF_DIR)/asdf.sh && $(ASDF_BIN) plugin add python || true'
	bash -c '. $(ASDF_DIR)/asdf.sh && $(ASDF_BIN) plugin add java || true'

asdf_install_python: asdf_plugins
	bash -c '. $(ASDF_DIR)/asdf.sh && $(ASDF_BIN)  install python 3.11.9 || true'
	bash -c '. $(ASDF_DIR)/asdf.sh && $(ASDF_BIN)  install python 3.9.18 || true'
	bash -c '. $(ASDF_DIR)/asdf.sh && $(ASDF_BIN)  global python 3.11.9 || true'

	
