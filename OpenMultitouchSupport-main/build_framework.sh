#!/bin/sh -
# xcodebuild -version

xcodebuild build \
  -project "Framework/OpenMultitouchSupportXCF.xcodeproj" \
  -scheme "OpenMultitouchSupportXCF" \
  -destination "generic/platform=macOS" \
  -configuration Release \
  -derivedDataPath "Framework/build"

FRAMEWORK_PATH="Framework/build/Build/Products/Release/OpenMultitouchSupportXCF.framework"
lipo -archs ${FRAMEWORK_PATH}/OpenMultitouchSupportXCF

XC_FRAMEWORK_PATH="Framework/Product/OpenMultitouchSupportXCF.xcframework"
if [ -e $XC_FRAMEWORK_PATH ]; then
  rm -rf $XC_FRAMEWORK_PATH
fi
xcodebuild -create-xcframework \
  -framework $FRAMEWORK_PATH \
  -output $XC_FRAMEWORK_PATH
