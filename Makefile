SDK="iphonesimulator"
DESTINATION="platform=iOS Simulator,name=iPhone 6"
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

