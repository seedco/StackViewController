SDK="iphonesimulator"
DESTINATION="platform=iOS Simulator,name=iPhone 6"
PROJECT="StackViewController"
SCHEME="StackViewController"

.PHONY: all build test

build:
	set -o pipefail && \
	xcodebuild \
	-sdk $(SDK) \
	-derivedDataPath build \
	-project $(PROJECT).xcodeproj \
	-scheme $(SCHEME) \
	-configuration Debug \
	-destination $(DESTINATION) \
	build | xcpretty

test:
	set -o pipefail && \
	xcodebuild \
	-sdk $(SDK) \
	-derivedDataPath build \
	-project $(PROJECT).xcodeproj \
	-scheme $(SCHEME) \
	-configuration Debug \
	-destination $(DESTINATION) \
	test | xcpretty

ci:
	$(MAKE) SCHEME=StackViewController test
	$(MAKE) SCHEME=Example build


clean:
	rm -rf build

