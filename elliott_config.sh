# /bin/sh -eu

./autogen.sh

# TODO
# -fsanitize=fuzzer-no-link,address,undefined

CC=clang-20 \
CFLAGS="-O1 -fno-omit-frame-pointer -g -DFUZZING_BUILD_MODE_UNSAFE_FOR_PRODUCTION -march=native -fsanitize=fuzzer-no-link,address -DNO_CHECK_MEMWIPE" \
./configure \
	--enable-imc-test \
	--enable-tnccs-20 \
	--enable-libipsec \
	--enable-eap-radius \
	--enable-fuzzing \
	--with-libfuzzer="$(clang-20 -print-resource-dir)/lib/linux/libclang_rt.fuzzer-x86_64.a" \
	--enable-monolithic \
	--disable-shared \
	--enable-static

bear -- make -j$(nproc)
bear --append -- make -j$(nproc) check
