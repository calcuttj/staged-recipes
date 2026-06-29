#!/bin/bash
# dk2nudata: legacy non-cetmodules ROOT build (tree/ half of NuSoftHEP/dk2nu).
set -euo pipefail

# dk2nu's CMake reads $ROOTSYS and pulls ROOT's cmake macros (ROOTUseFile,
# ROOT_GENERATE_DICTIONARY) from there; pin it to the host ROOT.
export ROOTSYS="$PREFIX"
export PATH="$PREFIX/bin:$PATH"

mkdir -p build
cd build

# CMAKE_POLICY_VERSION_MINIMUM=3.5: the source declares
# cmake_minimum_required(VERSION 2.6), which cmake >=3.31/4.x refuses outright.
# WITH_GENIE=OFF: build only the tree (dk2nudata); the genie flux driver
# (dk2nugenie) is a separate package needing GENIE.
# WITH_TBB=OFF: avoid its NO_DEFAULT_PATH env-based TBB probe (ROOT pulls tbb
# itself); COPY_AUX=OFF: don't install the etc/ + scripts/ aux trees.
cmake \
  -DCMAKE_INSTALL_PREFIX="$PREFIX" \
  -DCMAKE_PREFIX_PATH="$PREFIX" \
  -DCMAKE_POLICY_VERSION_MINIMUM=3.5 \
  -DWITH_GENIE=OFF \
  -DWITH_TBB=OFF \
  -DCOPY_AUX=OFF \
  -DCMAKE_CXX_STANDARD=20 \
  -DCMAKE_CXX_STANDARD_REQUIRED=ON \
  "$SRC_DIR"

make -j"${CPU_COUNT:-1}" install
