SUMMARY = "My App"
DESCRIPTION = "Example application (taken from Yocto QA tests)."

SECTION = "testing"

LICENSE = "CLOSED"

# example library dependency, this will also be present in the SDK, if this
# recipe is inlcluded
#DEPENDS = "libpng"

inherit cmake toolchain-scripts

OECMAKE_GENERATOR = "Unix Makefiles"

# Configuration where myapp.c and CMakeLists.txt are inside the meta "files/" folder
#
#FILESEXTRAPATHS_prepend := "${THISDIR}/files/${PN}:"
#
#SRC_URI = "file://myapp.c"
#SRC_URI += "file://CMakeLists.txt"
#S = "${WORKDIR}"

# Configuration for external GIT
#SRC_URI = "git://git.server/myapp.git;protocol=ssh"
#SRCREV = "5d2a9d60ca277aaa52b250a74e1668955405bede"
#S = "${WORKDIR}/git"

# Configuration for external directory
inherit externalsrc
EXTERNALSRC = "${COREBASE}/../myapp-cmake"
EXTERNALSRC_BUILD = "${EXTERNALSRC}/build"
#WORKDIR = "${EXTERNALSRC}/build_using_bitbake"

# This populates a SDK/toolchain for this specific recipe, usuable by other IDE's.
# To allow quickly rebuilding a modified app.
do_populate_ide_support () {
  toolchain_create_tree_env_script
  cp -a ${WORKDIR}/toolchain.cmake ${TMPDIR}
}
#addtask populate_ide_support before do_build after do_install

