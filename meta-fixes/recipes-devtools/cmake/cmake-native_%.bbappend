# if a too old zstd library is installed on a supported distro like
# Ubuntu 16.04, cmake fails to build its archive support.
# Use cmake-provided zstd library instead

# Upstream solution is still being discussed, might be that libzstd
# is added to openembedded-core

CMAKE_EXTRACONF += "-DCMAKE_USE_SYSTEM_LIBRARY_ZSTD=0"
