# oe-musl-sdk-cmake
OpenEmbedded SDK w/ CMake support, MUSL library

This repo shows how to build an application using CMake with OpenEmbedded (OE) core.
OE is configured to use MUSL as the C library.

It demonstrates both the BitBake approach, as well as the (standard) SDK approach.

# bug #13459

https://bugzilla.yoctoproject.org/show_bug.cgi?id=13459

Proposed patch: toolchain-scripts-musl.patch

During SDK build, OVERRIDES contains libc-glibc, so in toolchain-script.bbclass, this

TARGET_CC_ARCH_append-libc-musl = " -mmusl" 

will not work. This will:

TARGET_CC_ARCH_append-linux-musl = " -mmusl" 
