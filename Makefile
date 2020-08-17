all: ./myapp-cmake/build/myapp ./myapp-cmake/build_sdk/myapp
	diff myapp-cmake/build*/CMakeFiles/myapp.dir/flags.make

# Clean both application builds
clean: clean_app_bitbake clean_app_sdk

# Clean the application that was built with BitBake
clean_app_bitbake:
	(source ./openembedded-core/oe-init-build-env && bitbake myapp-cmake -c cleanall)

# Clean the application built with SDK
clean_app_sdk:
	rm -rf ./myapp-cmake/build_sdk

# Tell make these targets are phony; i.e. not real files
.PHONY: clean clean_app_bitbake clean_app_sdk

# SDK Installer Build
./build/tmp-musl/deploy/sdk/oecore-x86_64-core2-64-toolchain-nodistro.0.sh:
	(source ./openembedded-core/oe-init-build-env && bitbake core-image-minimal -c populate_sdk)

# SDK Installation
/tmp/oe-sdk-cmake/environment-setup-core2-64-oe-linux-musl: ./build/tmp-musl/deploy/sdk/oecore-x86_64-core2-64-toolchain-nodistro.0.sh
	./build/tmp-musl/deploy/sdk/oecore-x86_64-core2-64-toolchain-nodistro.0.sh -d /tmp/oe-sdk-cmake -y

# Application Build using OE Bitbake:
./myapp-cmake/build/myapp:
	(source ./openembedded-core/oe-init-build-env && bitbake myapp-cmake)

# Application Build using Installed SDK
./myapp-cmake/build_sdk/myapp: /tmp/oe-sdk-cmake/environment-setup-core2-64-oe-linux-musl
	(source /tmp/oe-sdk-cmake/environment-setup-core2-64-oe-linux-musl && \
	cd myapp-cmake && \
	mkdir -p build_sdk && \
	cd build_sdk && \
	cmake -DCMAKE_TOOLCHAIN_FILE=$$OECORE_NATIVE_SYSROOT/usr/share/cmake/OEToolchainConfig.cmake . .. && \
	make)

#
#	(rm -rf build_sdk; mkdir -p build_sdk) && \
#
