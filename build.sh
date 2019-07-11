#!/bin/sh

# Remove the old objects
rm *.o *.so

# Compile the code
xcrun -sdk iphoneos gcc -arch armv7 -arch armv7s -arch arm64 -miphoneos-version-min=8.0 -O3 -std=c99 -I~/.theos/include/ -c -o common.o common.m

# Link to a extension library
xcrun -sdk iphoneos gcc -arch armv7 -arch armv7s -arch arm64 -miphoneos-version-min=8.0 -O3 -Wl,-segalign,4000 -framework Foundation -framework UIKit -bundle -undefined dynamic_lookup -o common.so common.o

# Sign the library
ldid -S common.so