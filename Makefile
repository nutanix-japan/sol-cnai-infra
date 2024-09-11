UNAME := $(shell uname)
.DEFAULT_GOAL := install-linux-dependencies

.PHONY: install-macos-dependencies install-linux-dependencies
all: install-macos-dependencies install-linux-dependencies

# Install go-task on MacOS and print taskfile summary for next steps
ifeq ($(UNAME), Darwin)
install-macos-dependencies:
	@[ -z "command -v task" ] || brew install go-task
	@task --summary
endif

# Install go-task on Linux and print taskfile summary for next steps
ifeq ($(UNAME), Linux)
install-linux-dependencies:
	@[ -n "$$(command -v task)" ] || sudo sh -c "$$(curl --location https://taskfile.dev/install.sh)" -- -d -b /usr/local/bin
	@task --summary
endif
