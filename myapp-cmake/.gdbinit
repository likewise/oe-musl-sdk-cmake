# in 1st terminal: make qemu
# in 2nd terminal: /tmp/oe-sdk-cmake/sysroots/x86_64-oesdk-linux/usr/bin/x86_64-oe-linux-musl/x86_64-oe-linux-musl-gdb
#

target extended-remote 192.168.7.2:1234
handle SIGILL pass nostop noprint
file build/myapp
symbol-file build/myapp
#add-auto-load-safe-path /opt//arm-buildroot-linux-uclibcgnueabihf/sysroot/usr/lib/libstdc++.so.6.0.22-gdb.py
set verbose on
set solib-search-path /tmp/
set remote exec-file /tmp/myapp
set sysroot /tmp/oe-sdk-cmake/sysroots/core2-64-oe-linux-musl/
set substitute-path /usr/src/debug /tmp/oe-sdk-cmake/sysroots/core2-64-oe-linux-musl/usr/src/debug
show sysroot
show substitute-path
set follow-exec-mode same
#-enable-pretty-printing
break 13
display $pc
run
stepi 10
