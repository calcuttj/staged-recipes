#!/bin/bash
# nuevdb: NuSoftHEP event-display base + IF conditions-DB interface (cetmodules,
# ROOT dict via build_dictionary). _CheckClassVersion off is the standard ROOT-dict
# guard (PyROOT can't init in the rattler-build sandbox; see pot_impr #8).
set -euo pipefail

# find_package(nusimdata) -> find_dependency(dk2nudata) -> nufinder Finddk2nudata
# fallback needs $DK2NUDATA_INC at the include root.
export DK2NUDATA_INC="$PREFIX/include"

# IFDatabase find_package(libwda): cetmodules' Findlibwda falls back to locating
# wda.h via $LIBWDA_INC, then derives lib/ and builds the wda::wda imported target.
export LIBWDA_INC="$PREFIX/include"

mkdir -p build
cd build

cmake \
  -DCMAKE_INSTALL_PREFIX="$PREFIX" \
  -DCMAKE_PREFIX_PATH="$PREFIX" \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_CXX_STANDARD=20 \
  -DCMAKE_CXX_STANDARD_REQUIRED=ON \
  -DBUILD_TESTING=OFF \
  -DWANT_UPS:BOOL=OFF \
  -D_CheckClassVersion_ENABLED:BOOL=FALSE \
  "$SRC_DIR"

make -j"${CPU_COUNT:-1}" install

# Strip stray prefix-root doc FILES only (guard [ -f ]; never ROOT's README dir).
for f in INSTALL LICENSE README; do
  if [ -f "$PREFIX/$f" ]; then rm -f "$PREFIX/$f"; fi
done
