
.PHONY: format
format:
	synx worklog.xcodeproj
	swiftlint autocorrect

.PHONY:	test
test:
	rm -rf clean
	worklog new test

.PHONY:	xcode
xcode:
	open worklog.xcodeproj
