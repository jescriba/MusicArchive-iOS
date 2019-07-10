build: carthage
	@xcodegen

test: build
	@set -o pipefail && xcodebuild -workspace MusicArchive.xcworkspace -scheme MusicArchiveTests -destination "platform=iOS Simulator,name=iPhone Xs" build test | xcpretty

ci_bootstrap:
	@bin/brew_install.sh xcodegen carthage
	@bundle install --quiet
	@$(MAKE) build

bootstrap:
	@bin/brew_install.sh mint carthage rbenv
	@rbenv install -s
	@yes | mint install yonaskolb/xcodegen
	@yes | mint install nicklockwood/SwiftFormat
	@gem install -v 2.0.2 bundler --minimal-deps --conservative
	@bundle install --quiet
	@bin/githooks/install.sh
	@$(MAKE) build

carthage:
	@carthage update --new-resolver --platform iOS --cache-builds --no-use-binaries

.PHONY: bootstrap \
				ci_bootstrap \
				build \
				carthage \
				test

