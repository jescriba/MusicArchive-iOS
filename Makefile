build: carthage
	@xcodegen

bootstrap:
	@bin/brew_install.sh mint carthage
	@yes | mint install yonaskolb/xcodegen
	@yes | mint install nicklockwood/SwiftFormat
	@bin/githooks/install.sh
	@$(MAKE) build

carthage:
	@carthage update --new-resolver --platform iOS --cache-builds --no-use-binaries

.PHONY: bootstrap \
				build \
				carthage \
				strings
