export LOGICAL_PROCESSORS=$(nproc 2>/dev/null || sysctl -n hw.ncpu)
export CMAKE_BUILD_PARALLEL_LEVEL=${LOGICAL_PROCESSORS}

test -f qemu-11.0.1.tar.xz || curl -fSLo qemu-11.0.1.tar.xz https://download.qemu.org/qemu-11.0.1.tar.xz
test -d qemu-11.0.1 && rm -rf qemu-11.0.1
tar xvJf qemu-11.0.1.tar.xz
cd qemu-11.0.1
./configure
make -j ${LOGICAL_PROCESSORS}
