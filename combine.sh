#!/bin/bash
set -e

for lib in libavcodec libavdevice libavfilter libavformat libavutil libswresample libswscale; do
	xcodebuild -create-xcframework \
		-framework arm64-iphoneos/framework/${lib}.framework \
		-framework arm64-iphonesimulator/framework/${lib}.framework \
		-output xcframework/${lib}.xcframework
done