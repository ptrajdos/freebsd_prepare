ROOTDIR=$(realpath $(dir $(firstword $(MAKEFILE_LIST))))
PACKAGES_FILE=${ROOTDIR}/packages.txt

BASH_PROFILE := $(HOME)/.bash_profile
BASHRC := $(HOME)/.bashrc


ASDF_DIR= $(HOME)/.asdf
JENV_DIR := $(HOME)/.jenv
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

bash_default: install_packages
	chsh -s /usr/local/bin/bash

bash_profile:
	@echo "Creating ~/.bash_profile that sources ~/.bashrc..."
	@mkdir -p $(HOME)
	@echo '# ~/.bash_profile - automatically sources ~/.bashrc' > $(BASH_PROFILE)
	@echo 'if [ -f "$(BASHRC)" ]; then' >> $(BASH_PROFILE)
	@echo '    . "$(BASHRC)"' >> $(BASH_PROFILE)
	@echo 'fi' >> $(BASH_PROFILE)
	@echo "Done! ~/.bash_profile created."

bash_all: install_packages bash_default bash_profile

install_jenv:
	@echo "Installing jEnv..."
	@if [ ! -d "$(JENV_DIR)" ]; then \
		git clone https://github.com/jenv/jenv.git $(JENV_DIR); \
	else \
		echo "jEnv already installed in $(JENV_DIR)"; \
	fi
	@echo "Configuring shell profile to initialize jEnv..."
	@if ! grep -q 'export PATH="$HOME/.jenv/bin:$$PATH"' $(BASHRC); then \
		echo 'export PATH="$(JENV_DIR)/bin:$$PATH"' >> $(BASHRC); \
		echo 'eval "$$($(JENV_DIR)/bin/jenv init -)"' >> $(BASHRC); \
		echo "Added jEnv initialization to $(BASHRC)"; \
	else \
		echo "jEnv already configured in $(BASHRC)"; \
	fi
	@echo "Installation complete. Reload your shell or run 'source $(BASHRC)' to activate jEnv."
