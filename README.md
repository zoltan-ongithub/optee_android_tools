# OPTEE Android Tool

Unoficial helper tools for building Trusted Applications for Android using OP TEE. 
This script should not be used as a standalone tool. It requres the OP TEE toolchain
and OP TEE OS stored in the script directory.

# Example usage

Assuming that the script is checked out in the optee/ folder of your AOSP root

```
$ source build/envsetup.sh
$ lunch hikey-userdebug
$  $ ./optee/build_ta.sh hikey optee/android_optee_examples.cfg
```


