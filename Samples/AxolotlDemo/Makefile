.PHONY: all pck project project-openswiftui build-macos build-macos-openswiftui build-ios-simulator clean

all: pck project

pck:
	./Scripts/build-pck.sh

project:
	xcodegen generate

project-openswiftui:
	xcodegen generate --spec project-openswiftui.yml

build-macos: all
	xcodebuild -project AxolotlDemo.xcodeproj -scheme AxolotlDemo-macOS -destination 'platform=macOS' CODE_SIGNING_ALLOWED=NO build

build-macos-openswiftui: project-openswiftui
	xcodebuild -project AxolotlDemo-OpenSwiftUI.xcodeproj -scheme AxolotlDemo-macOS -destination 'platform=macOS' CODE_SIGNING_ALLOWED=NO build

build-ios-simulator: all
	xcodebuild -project AxolotlDemo.xcodeproj -scheme AxolotlDemo-iOS -destination 'generic/platform=iOS Simulator' CODE_SIGNING_ALLOWED=NO build

clean:
	xcodebuild -project AxolotlDemo.xcodeproj -alltargets clean
