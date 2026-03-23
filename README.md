# FFMpeg_XCFramework

編譯FFMpeg原始碼，打包成XCFramework給iOS使用…

![](image/result.png)

- 安裝yasm
```bash
brew install yasm
mkdir FFMpeg_XCFramework
cd FFMpeg_XCFramework
```

- 下載原始檔
```bash
export Source_Dir="src"
git clone --branch n7.1 https://git.ffmpeg.org/ffmpeg.git ${Source_Dir}
```

- 設定環境變數 (實機)
```bash
export Source_Dir="src"
export Arch="arm64"
export Target="arm64-apple-ios"
export SDK="iphoneos"
export Type="iphoneos"
export SupportedPlatform="iPhoneOS"
export MinVersion="16.0"
export Framework_Path=${Arch}-${SDK}
export SYSROOT=$(xcrun --sdk ${SDK} --show-sdk-path)
export CC="xcrun -sdk ${SDK} clang -target ${Target}"
export CXX="xcrun -sdk ${SDK} clang++ -target ${Target}" 
export CFLAGS="-arch ${Arch} -isysroot ${SYSROOT} -m${Type}-version-min=${MinVersion}"
export LDFLAGS="-arch ${Arch} -isysroot ${SYSROOT} -m${Type}-version-min=${MinVersion} -headerpad_max_install_names"
```

- 設定環境變數 (模擬器)
```bash
export Source_Dir="src"
export Arch="arm64"
export Target="arm64-apple-ios-simulator"
export SDK="iphonesimulator"
export Type="ios-simulator"
export MinVersion="16.0"
export SupportedPlatform="iPhoneSimulator"
export Framework_Path=${Arch}-${SDK}
export SYSROOT=$(xcrun --sdk ${SDK} --show-sdk-path)
export CC="xcrun -sdk ${SDK} clang -target ${Target}"
export CXX="xcrun -sdk ${SDK} clang++ -target ${Target}" 
export CFLAGS="-arch ${Arch} -isysroot ${SYSROOT} -m${Type}-version-min=${MinVersion}"
export LDFLAGS="-arch ${Arch} -isysroot ${SYSROOT} -m${Type}-version-min=${MinVersion} -headerpad_max_install_names"
```

- 建立安裝資料夾
```bash
mkdir installed
mkdir build
mkdir build/${Framework_Path}
cd build/${Framework_Path}
```

- 編譯原始碼
```bash
make -j$(sysctl -n hw.ncpu) 
make install
cd ../..
```

- 建立framework
```bash
chmod +x create.sh
./create.sh
```

- 合併framework
```bash
cd installed
chmod +x combine.sh
./combine.sh
```
