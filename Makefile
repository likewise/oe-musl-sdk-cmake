# Bitbake MUSL CMake Clang combo broken because -mmusl leaks into toolchain.cmake, we patch it
all: ./myapp-cmake/build_bitbake/myapp ./myapp-cmake/build_bitbake_clang/myapp ./myapp-cmake/build_sdk/myapp ./myapp-cmake/build_sdk_clang/myapp
	echo
	file myapp-cmake/build_bitbake/myapp
	echo
	file myapp-cmake/build_bitbake_clang/myapp
	echo
	file myapp-cmake/build_sdk/myapp
	echo
	file myapp-cmake/build_sdk_clang/myapp

qemu:
	# CTRL-A, X to quit.   (Alternatively CTRL-A, C, then quit<enter> to exit)
	(source ./openembedded-core/oe-init-build-env && runqemu qemux86-64 core-image-minimal-dev nographic)

# Clean both application builds, the installed SDK and SDK installer
clean: clean_app clean_sdk

clean_app: clean_app_bitbake clean_app_bitbake_clang clean_app_sdk clean_app_sdk_clang

# Clean the application that was built with BitBake
clean_app_bitbake: openembedded
	(source ./openembedded-core/oe-init-build-env && bitbake myapp-cmake -c cleanall)
	# EXTERNALSRC cleanall does not clean build directory?
	rm -rf myapp-cmake/build_bitbake

# Clean the application that was built with BitBake Clang
clean_app_bitbake_clang: openembedded
	(source ./openembedded-core/oe-init-build-env && bitbake myapp-cmake-clang -c cleanall)
	# EXTERNALSRC cleanall does not clean build directory?
	rm -rf myapp-cmake/build_bitbake_clang

# Clean the application built with SDK
clean_app_sdk:
	rm -rf ./myapp-cmake/build_sdk

# Clean the application built with SDK Clang
clean_app_sdk_clang:
	rm -rf ./myapp-cmake/build_sdk_clang

# Clean the installed SDK and SDK installer
clean_sdk:
	rm -rf /tmp/oe-sdk-cmake
	rm -rf ./build/tmp-musl/deploy/sdk
	(source ./openembedded-core/oe-init-build-env && bitbake core-image-minimal-dev -c cleanall)

# Tell make these targets are phony; i.e. not real files
.PHONY: clean clean_sdk clean_app clean_app_bitbake clean_app_bitbake_clang clean_app_sdk clean_app_sdk_clang

# SDK Installer Build
./build/tmp-musl/deploy/sdk/oecore-x86_64-core2-64-toolchain-nodistro.0.sh: openembedded
	(source ./openembedded-core/oe-init-build-env && bitbake core-image-minimal-dev -c populate_sdk)

# SDK Installation
/tmp/oe-sdk-cmake/environment-setup-core2-64-oe-linux-musl: ./build/tmp-musl/deploy/sdk/oecore-x86_64-core2-64-toolchain-nodistro.0.sh
	./build/tmp-musl/deploy/sdk/oecore-x86_64-core2-64-toolchain-nodistro.0.sh -d /tmp/oe-sdk-cmake -y

# Application Build using OE Bitbake:
./myapp-cmake/build_bitbake/myapp: openembedded
	(source ./openembedded-core/oe-init-build-env && bitbake myapp-cmake)

# Application Build using OE Bitbake w/ Clang:
./myapp-cmake/build_bitbake_clang/myapp: openembedded
	cd meta-clang && patch -N -p1 -i ../meta-clang-musl-cmake-fix.patch || true
	(source ./openembedded-core/oe-init-build-env && bitbake myapp-cmake-clang)

# Application Build using Installed SDK
./myapp-cmake/build_sdk/myapp: /tmp/oe-sdk-cmake/environment-setup-core2-64-oe-linux-musl
	(source /tmp/oe-sdk-cmake/environment-setup-core2-64-oe-linux-musl && \
	cd myapp-cmake && \
	mkdir -p build_sdk && \
	cd build_sdk && \
	cmake -DCMAKE_TOOLCHAIN_FILE=$$OECORE_NATIVE_SYSROOT/usr/share/cmake/OEToolchainConfig.cmake -DCMAKE_VERBOSE_MAKEFILE=1 . .. && \
	make)

# Application Build using Installed SDK Clang (note that we patch meta-clang for now!)
./myapp-cmake/build_sdk_clang/myapp: /tmp/oe-sdk-cmake/environment-setup-core2-64-oe-linux-musl
	cd meta-clang && patch -N -p1 -i ../meta-clang-musl-cmake-fix.patch || true
	(source /tmp/oe-sdk-cmake/environment-setup-core2-64-oe-linux-musl && \
	export CC=$$CLANGCC && \
	export CPP=$$CLANGCPP && \
	export CXX=$$CLANGCXX && \
	cd myapp-cmake && \
	mkdir -p build_sdk_clang && \
	cd build_sdk_clang && \
	cmake -DCMAKE_TOOLCHAIN_FILE=$$OECORE_NATIVE_SYSROOT/usr/share/cmake/OEToolchainConfig.cmake -DCMAKE_VERBOSE_MAKEFILE=1 . .. && \
	make)

.PHONY: openembedded
openembedded: openembedded-core/oe-init-build-env bitbake/bin/bitbake meta-clang/README.md

openembedded-core/oe-init-build-env:
	git submodule update --init --recursive

bitbake/bin/bitbake:
	git submodule update --init --recursive

meta-clang/README.md:
	git submodule update --init --recursive
