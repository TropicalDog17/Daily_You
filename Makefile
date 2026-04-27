SHELL := /bin/zsh

FLUTTER ?= flutter
IPHONE_DEVICE_ID ?= 00008120-00080C362162601E

.PHONY: help run-dev-iphone run-release-iphone

help:
	@printf "Available targets:\n"
	@printf "  run-dev-iphone      Run a debug build on the real iPhone\n"
	@printf "  run-release-iphone  Run a release build on the real iPhone\n"
	@printf "\nOverride the device with IPHONE_DEVICE_ID=<device-id>.\n"

run-dev-iphone:
	$(FLUTTER) run -d $(IPHONE_DEVICE_ID)

run-release-iphone:
	$(FLUTTER) run --release -d $(IPHONE_DEVICE_ID)
