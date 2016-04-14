#!/bin/bash
#
# Author: Zoltan Kuscsik <zoltan.kuscsik@linaro.org>
#

CURRENT_BUILD_PATH=$(dirname $(realpath $0))
COMPILER_PATH=$CURRENT_BUILD_PATH/gcc-linaro-4.9-2015.05-x86_64_aarch64-linux-gnu/bin

NUMBER_OF_CPU_CORES=`grep -c ^processor /proc/cpuinfo`
OPTEE_OS_DIR="optee_os"

export PATH=$COMPILER_PATH:$PATH

set_optee_os_hikey_vars() {
  export PLATFORM=hikey
  export CROSS_COMPILE=aarch64-linux-gnu-
  ARM64_core=y
  TA_TARGETS=ta_arm64
  OPTEE_OS_DEV_KIT_PATH="out/arm-plat-hikey/export-ta_arm64"
}

if [ -z "$ANDROID_BUILD_TOP" ]; then
   echo "Error: Before running this script you should call in the main Android directory"
   echo
   echo "  $ source build/envsetup.sh "
   echo "  $ lunch <whatever> "
   exit 1
fi

###########################################################
# Select target platform
###########################################################
if [ "$1" == "hikey" ]; then
  set_optee_os_hikey_vars
else
  echo "#"
  echo "# ERROR: Missing platform argument from ./$(basename $0) <platform> <ta_project_list_file>"
  echo "#"
  echo "#       Valid platforms:"
  echo "#"
  echo "#           * hikey "
  echo "#"
  echo "#        Example : "
  echo "#"
  echo "#        $ ./build_ta.sh hikey optee/android_optee_examples.cfg "
  echo "#"
  exit 1
fi

if  [ -z "$2" ]; then
  echo "Missing TA list from ./$(basename $0) <platform> <ta_project_list_file> "
  exit 1
fi

TA_PROJECT_LIST_SOURCE="$2"

if [ -f $TA_PROJECT_LIST_SOURCE ]; then
  source $TA_PROJECT_LIST_SOURCE
else
  echo "ERROR: File $TA_PROJECT_LIST_SOURCE does not exists"
  exit 1
fi


if [ -z "$ANDROID_OPTEE_PROJECT_LIST" ]; then
  echo "TA projects list file must define the ANDROID_OPTEE_PROJECT_LIST variable."
  exit 1
fi

##########################################################
# Build OPTEE OS
##########################################################
make  -C $CURRENT_BUILD_PATH/$OPTEE_OS_DIR -j$NUMBER_OF_CPU_CORES \
      ta-targets=$TA_TARGETS \
      CFG_ARM64_core=$ARM64_core

##########################################################
# Build trusted applications
##########################################################

export TA_DEV_KIT_DIR=$CURRENT_BUILD_PATH/$OPTEE_OS_DIR/$OPTEE_OS_DEV_KIT_PATH

for ta_target in $ANDROID_OPTEE_PROJECT_LIST
do
    make  -C $ANDROID_BUILD_TOP/$ta_target O=$ANDROID_BUILD_TOP/$ta_target
    android_mk="$ANDROID_BUILD_TOP/$ta_target/Android.mk"
    if [ ! -f "$android_mk" ]; then
      echo "ERROR: Android.mk does not exists in $ANDROID_BUILD_TOP/$ta_target"
      echo "       TA is built but it wont be included in the system.img"
      exit 1
    fi
done

