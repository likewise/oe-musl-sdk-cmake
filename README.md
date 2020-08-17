# oe-musl-sdk-cmake
OpenEmbedded SDK w/ CMake support, MUSL library

This repo shows how to build an application using CMake with OpenEmbedded (OE) core.
OE is configured to use MUSL as the C library.

It demonstrates both the BitBake approach, as well as the (standard) SDK approach.

In the current release, however, the SDK/CMake approach does not seem to pass the -mmusl
flag to the cross-compiler and linker, resulting in using (amongst other) the ld for GLIBC.

Still under investigation is why, it is set here:

TARGET_CC_ARCH_append-libc-musl = " -mmusl" 

Reproduce:

make
