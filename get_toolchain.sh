#! /bin/bash
#
# Copyright (C) 2016, Linaro Limited
#
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# 1. Redistributions of source code must retain the above copyright notice,
# this list of conditions and the following disclaimer.
#
# 2. Redistributions in binary form must reproduce the above copyright notice,
# this list of conditions and the following disclaimer in the documentation
# and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.

if [ -z "$ANDROID_BUILD_TOP" ]; then
  echo "Error: Before running this script, you should be configured to build Android"
  echo ""
  echo "  $ source build/envsetup.sh"
  echo "  $ lunch <target>"
  exit 1
fi

if [ ! -f optee/get_toolchain.sh ]; then
  echo "This script should be run from the top of the Android build tree."
  exit 1
fi

die() {
  echo "Failure: $1"
  exit 1
}

cd optee

if [ -f toolchain.stamp ]; then
  echo "Toolchain appears to have already been downloaded"
  exit 0
fi

wget http://releases.linaro.org/15.05/components/toolchain/binaries/aarch64-linux-gnu/gcc-linaro-4.9-2015.05-x86_64_aarch64-linux-gnu.tar.xz || die "Unable to download toolchain"
tar -xJf gcc-linaro-4.9-2015.05-x86_64_aarch64-linux-gnu.tar.xz || die "Unable to extract toolchain"

touch toolchain.stamp

echo "Toolchain downloaded and extracted"
exit 0
