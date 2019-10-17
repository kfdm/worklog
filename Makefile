
.PHONY: format
format:
	synx worklog.xcodeproj
	swiftlint autocorrect

build:
	worklog new build
