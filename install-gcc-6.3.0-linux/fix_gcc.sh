# fix_gcc.sh: apply fixes in https://stackoverflow.com/a/48647715

# process arguments
SRCDIR=${1}  # first argument to this script

# edit files in place
sed -i '61s/struct\sucontext/ucontext_t/' ${SRCDIR}/libgcc/config/i386/linux-unwind.h
sed -i '141s/struct\sucontext/ucontext_t/' ${SRCDIR}/libgcc/config/i386/linux-unwind.h
sed -i '549s/struct\ssigaltstack/void/' ${SRCDIR}/libsanitizer/sanitizer_common/sanitizer_linux.cc
sed -i '550s/struct\ssigaltstack/void/' ${SRCDIR}/libsanitizer/sanitizer_common/sanitizer_linux.cc
sed -i '22d' ${SRCDIR}/libsanitizer/sanitizer_common/sanitizer_linux.h
sed -i '30s/struct\ssigaltstack/void/' ${SRCDIR}/libsanitizer/sanitizer_common/sanitizer_linux.h
sed -i '31s/struct\ssigaltstack/void/' ${SRCDIR}/libsanitizer/sanitizer_common/sanitizer_linux.h
sed -i '270s/struct\ssigaltstack/stack_t/' ${SRCDIR}/libsanitizer/sanitizer_common/sanitizer_stoptheworld_linux_libcdep.cc
sed -i '294s/__res_state/struct\ __res_state/g' ${SRCDIR}/libsanitizer/tsan/tsan_platform_linux.cc
