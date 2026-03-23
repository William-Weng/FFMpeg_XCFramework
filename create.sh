#!/bin/bash
set -e

create_plist() {
    local framework_name="$1"
    local file_path="$2"
    local info_plist="<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">
<plist version=\"1.0\">
<dict>
    <key>CFBundleDevelopmentRegion</key>
    <string>en</string>
    <key>CFBundleExecutable</key>
    <string>${framework_name}</string>
    <key>CFBundleIdentifier</key>
    <string>org.ffmpeg.${framework_name}</string>
    <key>CFBundleInfoDictionaryVersion</key>
    <string>6.0</string>
    <key>CFBundleName</key>
    <string>${framework_name}</string>
    <key>CFBundlePackageType</key>
    <string>FMWK</string>
    <key>CFBundleShortVersionString</key>
    <string>7.1</string>
    <key>CFBundleVersion</key>
    <string>7.1</string>
    <key>CFBundleSignature</key>
    <string>????</string>
    <key>MinimumOSVersion</key>
    <string>${MinVersion}</string>
    <key>CFBundleSupportedPlatforms</key>
    <array>
        <string>${SupportedPlatform}</string>
    </array>
    <key>NSPrincipalClass</key>
    <string></string>
</dict>
</plist>"

echo "$info_plist" > "$file_path"
}

create_framework() {
    local framework_name="$1"
    local ffmpeg_library_path="./installed"
    local framework_dir="${ffmpeg_library_path}/${Framework_Path}/framework/${framework_name}.framework"
    local dylib_src="${ffmpeg_library_path}/${Framework_Path}/lib/${framework_name}.dylib"
    local dylib_dst="${framework_dir}/${framework_name}"

    mkdir -p "$framework_dir"
    cp "$dylib_src" "$dylib_dst"

    create_plist "$framework_name" "${framework_dir}/Info.plist"

    # Update the framework's own ID
    install_name_tool -id "@rpath/${framework_name}.framework/${framework_name}" "$dylib_dst"

    # Update all dependencies to use framework paths
    otool -L "$dylib_dst" | grep "@rpath/.*\.dylib" | awk '{print $1}' | while read -r dependency; do
        local dep_name=$(basename "$dependency" | sed 's/\..*//' | sed 's/^lib//') 
        local new_path="@rpath/lib${dep_name}.framework/lib${dep_name}"
        install_name_tool -change "$dependency" "$new_path" "$dylib_dst"
    done
}

# Create frameworks
for lib in libavcodec libavdevice libavfilter libavformat libavutil libswresample libswscale; do
    create_framework "$lib"
done

for lib in libavcodec libavdevice libavfilter libavformat libavutil libswresample libswscale; do
    mkdir -p installed/${Framework_Path}/framework/${lib}.framework/Headers
    cp -r installed/${Framework_Path}/include/${lib}/* installed/${Framework_Path}/framework/${lib}.framework/Headers/
done