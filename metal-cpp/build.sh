#!/bin/bash

workdir=$(cd $(dirname $0); pwd)
rootdir=$(cd $workdir/../../; pwd)

src_dir_inside=metal-cpp

rm -rf "$workdir/deploy" && rm -rf "$workdir/${src_dir_inside}" && \
mkdir -p "$workdir/deploy/include" && mkdir -p "$workdir/deploy/lib" && \
cd "$workdir" && tar -zxvf "$workdir/source/${src_dir_inside}.tar.gz" && \
cd "$workdir/${src_dir_inside}/"

sh build.sh

cp "$workdir/${src_dir_inside}/build/metal-cmake/libMETAL_CPP.a" "$workdir/deploy/lib/"
cp -r "$workdir/${src_dir_inside}/metal-cmake/" "$workdir/deploy/include/"

if [[ $? -ne 0 ]]; then
    echo "ERROR: Failed to build SDL"
    exit -1
fi

echo "success!"





# tar -zxvf 
# rm -rf build && mkdir -p build && cd build && \
# cmake .. && make -j12 