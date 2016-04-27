
SDK="iphonesimulator9.3"
DESTINATION="platform=iOS Simulator,name=iPhone 6,OS=9.3"
PROJECT="StackViewController"

.PHONY: all

build:
	set -o pipefail && \
	xcodebuild \
	-sdk $(SDK) \
	-derivedDataPath build \
	-project $(PROJECT).xcodeproj \
	-scheme $(PROJECT) \
	-configuration Debug \
	-destination $(DESTINATION) \
	build | xcpretty

test:
	set -o pipefail && \
	xcodebuild \
	-sdk $(SDK) \
	-derivedDataPath build \
	-project $(PROJECT).xcodeproj \
	-scheme $(PROJECT) \
	-configuration Debug \
	-destination $(DESTINATION) \
	test | xcpretty


clean:
	rm -rf build

