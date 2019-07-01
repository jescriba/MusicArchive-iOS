build: carthage
	@xcodegen

bootstrap:
	@bin/brew_install.sh rbenv mint carthage
	@rbenv install -s
	@yes | mint install yonaskolb/xcodegen
	@yes | mint install nicklockwood/SwiftFormat
	@gem install -v 2.0.2 bundler --minimal-deps --conservative
	@bundle install
	@bin/githooks/install.sh
	@$(MAKE) build
	
carthage:
	@carthage update --new-resolver --platform iOS --cache-builds --no-use-binaries

ruby:
	@rubocop -a --except Metrics,Naming/PredicateName fastlane Gemfile

.PHONY: bootstrap \
				build \
				carthage \
				ruby \
				strings
