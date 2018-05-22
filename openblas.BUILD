# TODO: Disable nancheck in lapacke
# TODO: Enable various SSE optimizations and such
# TODO: make sure the ASM kernels are built and used
# TODO: try out building fortran without -fPIC since
#       we link everything statically anyway. If any remains.
# TODO: Try out building with multithreaded support (omp?)
#       By defining SMP, and possibly THREADED_LEVEL3.
# TODO: Look for other standard copts in Makefile.system
# TODO: Investigate NO_WARMUP define
#
# TODO: Rerun config creation on:
#       ARM
#       My Mac
#       The Dell

load("@fortran_rules//:fortran.bzl", "fortran_library")
load("@fortran_rules//:blas.bzl", "blas_library")

#fortran_library(
#    name = "blas",
#    srcs = glob([
#        "lapack-netlib/BLAS/SRC/*.f"
#    ]),
#)

#fortran_library(
#    name = "lapack",
#    srcs = [
#        "lapack-netlib/INSTALL/dlamch.f",
#        "lapack-netlib/SRC/iparam2stage.F",
#    ] + glob([
#        "lapack-netlib/SRC/*.f"
#    ]),
#    deps = [
#        ":blas",
#    ]
#)

# TODO(armin): Config should be select()ed based on platform.
# Create for other platforms by running "make config.h" on those platforms.
genrule(
    name = "config",
    outs = ["config.h"],
    cmd = """
        echo '#define OS_LINUX    1' >> $@
        echo '#define ARCH_X86_64 1' >> $@
        echo '#define C_GCC   1' >> $@
        echo '#define __64BIT__   1' >> $@
        echo '#define PTHREAD_CREATE_FUNC pthread_create' >> $@
        echo '#define BUNDERSCORE _' >> $@
        echo '#define NEEDBUNDERSCORE 1' >> $@
        echo '#define HASWELL' >> $@
        echo '#define L1_CODE_SIZE 16384' >> $@
        echo '#define L1_CODE_ASSOCIATIVE 4' >> $@
        echo '#define L1_CODE_LINESIZE 64' >> $@
        echo '#define L1_DATA_SIZE 8192' >> $@
        echo '#define L1_DATA_ASSOCIATIVE 4' >> $@
        echo '#define L1_DATA_LINESIZE 64' >> $@
        echo '#define L2_SIZE 262144' >> $@
        echo '#define L2_ASSOCIATIVE 8' >> $@
        echo '#define L2_LINESIZE 64' >> $@
        echo '#define ITB_SIZE 2097152' >> $@
        echo '#define ITB_ASSOCIATIVE 0' >> $@
        echo '#define ITB_ENTRIES 8' >> $@
        echo '#define DTB_SIZE 4096' >> $@
        echo '#define DTB_ASSOCIATIVE 4' >> $@
        echo '#define DTB_DEFAULT_ENTRIES 64' >> $@
        echo '#define HAVE_CMOV' >> $@
        echo '#define HAVE_MMX' >> $@
        echo '#define HAVE_SSE' >> $@
        echo '#define HAVE_SSE2' >> $@
        echo '#define HAVE_SSE3' >> $@
        echo '#define HAVE_SSSE3' >> $@
        echo '#define HAVE_SSE4_1' >> $@
        echo '#define HAVE_SSE4_2' >> $@
        echo '#define HAVE_AVX' >> $@
        echo '#define HAVE_FMA3' >> $@
        echo '#define HAVE_CFLUSH' >> $@
        echo '#define NUM_SHAREDCACHE 1' >> $@
        echo '#define NUM_CORES 1' >> $@
        echo '#define CORE_HASWELL' >> $@
        echo '#define CHAR_CORENAME "HASWELL"' >> $@
        echo '#define SLOCAL_BUFFER_SIZE  24576' >> $@
        echo '#define DLOCAL_BUFFER_SIZE  32768' >> $@
        echo '#define CLOCAL_BUFFER_SIZE  12288' >> $@
        echo '#define ZLOCAL_BUFFER_SIZE  8192' >> $@
        echo '#define GEMM_MULTITHREAD_THRESHOLD  4' >> $@
    """
)

cc_library(
    name = "blas_core",
    srcs = [
        "config.h",
        "common_x86_64.h", # TODO(armin): select this
        "common_linux.h", # TODO(armin): select this
        "common.h",
        "common_param.h",
        "common_interface.h",
        "common_macro.h",
        "common_s.h",
        "common_d.h",
        "common_q.h",
        "common_c.h",
        "common_z.h",
        "common_x.h",
        "common_level1.h",
        "common_level2.h",
        "common_level3.h",
        "common_lapack.h",
        "common_stackalloc.h",
        "param.h",
        "l1param.h",
        "driver/others/memory.c",
        "driver/others/parameter.c",
        "driver/others/openblas_env.c",
        "driver/others/xerbla.c",
    ],
)

blas_library(
    name = 'blas',
    srcs = [],
    hdrs = [],
    deps = [":blas_core"],
    modules = {
        "dlamch": { "srcs": ["driver/others/lamch.c"] },
        "lsame": { "srcs": ["driver/others/lsame.c"] },
        "idamax": {
            "srcs": ["interface/imax.c"],
            "copts": ["-DUSE_ABS", "-DDOUBLE"],
        },
        "dcopy": { "srcs": ["interface/copy.c"] },
        "dasum": { "srcs": ["interface/asum.c"] },
        "dscal": { "srcs": ["interface/scal.c"] },
        "ddot": { "srcs": ["interface/dot.c"] },
        "daxpy": { "srcs": ["interface/axpy.c"] },
        "dtrsv": { "srcs": ["interface/trsv.c"] },
        "dgemv": { "srcs": ["interface/gemv.c"] },
        "dgemm": { "srcs": ["interface/gemm.c"] },
        "dger": { "srcs": ["interface/ger.c"] },
        "dnrm2": { "srcs": ["interface/nrm2.c"] },
        "dtrmv": { "srcs": ["interface/trmv.c"] },
        "dtrsm": { "srcs": ["interface/trsm.c"] },
        "dtrmm": {
            "srcs": ["interface/trsm.c"],
            "copts": ["-DTRMM"],
        },
        "dtrsv_NUU": {
            "srcs": ["driver/level2/trsv_U.c"],
            "hdrs": [],
            "copts": ["-DUNIT", "-UTRANSA"]
        },
        "dtrsv_NUN": {
            "srcs": ["driver/level2/trsv_U.c"],
            "hdrs": [],
            "copts": ["-UUNIT", "-UTRANSA"]
        },
        "dtrsv_NLU": {
            "srcs": ["driver/level2/trsv_L.c"],
            "hdrs": [],
            "copts": ["-DUNIT", "-UTRANSA"]
        },
        "dtrsv_TUN": {
            "srcs": ["driver/level2/trsv_L.c"],
            "hdrs": [],
            "copts": ["-UUNIT", "-DTRANSA"]
        },
        "dtrsv_TLN": {
            "srcs": ["driver/level2/trsv_U.c"],
            "hdrs": [],
            "copts": ["-UUNIT", "-DTRANSA"]
        },
        "dtrsv_NLN": {
            "srcs": ["driver/level2/trsv_L.c"],
            "hdrs": [],
            "copts": ["-UUNIT", "-UTRANSA"]
        },
        "dtrsv_TUU": {
            "srcs": ["driver/level2/trsv_L.c"],
            "hdrs": [],
            "copts": ["-DUNIT", "-DTRANSA"]
        },
        "dtrsv_TLU": {
            "srcs": ["driver/level2/trsv_U.c"],
            "hdrs": [],
            "copts": ["-DUNIT", "-DTRANSA"]
        },
        "dtrmv_TLN": {
            "srcs": ["driver/level2/trmv_U.c"],
            "hdrs": [],
            "copts": ["-UUNIT", "-DTRANSA"]
        },
        "dtrmv_TLU": {
            "srcs": ["driver/level2/trmv_U.c"],
            "hdrs": [],
            "copts": ["-DUNIT", "-DTRANSA"]
        },
        "dtrmv_NUN": {
            "srcs": ["driver/level2/trmv_U.c"],
            "hdrs": [],
            "copts": ["-UUNIT", "-UTRANSA"]
        },
        "dtrmv_NUU": {
            "srcs": ["driver/level2/trmv_U.c"],
            "hdrs": [],
            "copts": ["-DUNIT", "-UTRANSA"]
        },
        "dtrmv_TUN": {
            "srcs": ["driver/level2/trmv_L.c"],
            "hdrs": [],
            "copts": ["-UUNIT", "-DTRANSA"]
        },
        "dtrmv_TUU": {
            "srcs": ["driver/level2/trmv_L.c"],
            "hdrs": [],
            "copts": ["-DUNIT", "-DTRANSA"]
        },
        "dtrmv_NLN": {
            "srcs": ["driver/level2/trmv_L.c"],
            "hdrs": [],
            "copts": ["-UUNIT", "-UTRANSA"]
        },
        "dtrmv_NLU": {
            "srcs": ["driver/level2/trmv_L.c"],
            "hdrs": [],
            "copts": ["-DUNIT", "-UTRANSA"]
        },
        "dgemm_nn": {
            "srcs": ["driver/level3/gemm.c"],
            "hdrs": ["driver/level3/level3.c"],
            "copts": ["-DNN"],
        },
        "dgemm_tn": {
            "srcs": ["driver/level3/gemm.c"],
            "hdrs": ["driver/level3/level3.c"],
            "copts": ["-DTN"],
        },
        "dgemm_nt": {
            "srcs": ["driver/level3/gemm.c"],
            "hdrs": ["driver/level3/level3.c"],
            "copts": ["-DNT"],
        },
        "dgemm_tt": {
            "srcs": ["driver/level3/gemm.c"],
            "hdrs": ["driver/level3/level3.c"],
            "copts": ["-DTT"],
        },
        "dtrsm_LTLN": {
            "srcs": ["driver/level3/trsm_L.c"],
            "hdrs": ["driver/level3/level3.c"],
            "copts": ["-DTRANSA", "-UUPPER", "-UUNIT"],
        },
        "dtrsm_LTLU": {
            "srcs": ["driver/level3/trsm_L.c"],
            "hdrs": ["driver/level3/level3.c"],
            "copts": ["-DTRANSA", "-UUPPER", "-DUNIT"],
        },
        "dtrsm_LTUN": {
            "srcs": ["driver/level3/trsm_L.c"],
            "hdrs": ["driver/level3/level3.c"],
            "copts": ["-DTRANSA", "-DUPPER", "-UUNIT"],
        },
        "dtrsm_LTUU": {
            "srcs": ["driver/level3/trsm_L.c"],
            "hdrs": ["driver/level3/level3.c"],
            "copts": ["-DTRANSA", "-DUPPER", "-DUNIT"],
        },
        "dtrsm_LNLN": {
            "srcs": ["driver/level3/trsm_L.c"],
            "hdrs": ["driver/level3/level3.c"],
            "copts": ["-UTRANSA", "-UUPPER", "-UUNIT"],
        },
        "dtrsm_LNLU": {
            "srcs": ["driver/level3/trsm_L.c"],
            "hdrs": ["driver/level3/level3.c"],
            "copts": ["-UTRANSA", "-UUPPER", "-DUNIT"],
        },
        "dtrsm_LNUN": {
            "srcs": ["driver/level3/trsm_L.c"],
            "hdrs": ["driver/level3/level3.c"],
            "copts": ["-UTRANSA", "-DUPPER", "-UUNIT"],
        },
        "dtrsm_LNUU": {
            "srcs": ["driver/level3/trsm_L.c"],
            "hdrs": ["driver/level3/level3.c"],
            "copts": ["-UTRANSA", "-DUPPER", "-DUNIT"],
        },
        "dtrsm_RTLN": {
            "srcs": ["driver/level3/trsm_R.c"],
            "hdrs": ["driver/level3/level3.c"],
            "copts": ["-DTRANSA", "-UUPPER", "-UUNIT"],
        },
        "dtrsm_RTLU": {
            "srcs": ["driver/level3/trsm_R.c"],
            "hdrs": ["driver/level3/level3.c"],
            "copts": ["-DTRANSA", "-UUPPER", "-DUNIT"],
        },
        "dtrsm_RTUN": {
            "srcs": ["driver/level3/trsm_R.c"],
            "hdrs": ["driver/level3/level3.c"],
            "copts": ["-DTRANSA", "-DUPPER", "-UUNIT"],
        },
        "dtrsm_RTUU": {
            "srcs": ["driver/level3/trsm_R.c"],
            "hdrs": ["driver/level3/level3.c"],
            "copts": ["-DTRANSA", "-DUPPER", "-DUNIT"],
        },
        "dtrsm_RNLN": {
            "srcs": ["driver/level3/trsm_R.c"],
            "hdrs": ["driver/level3/level3.c"],
            "copts": ["-UTRANSA", "-UUPPER", "-UUNIT"],
        },
        "dtrsm_RNLU": {
            "srcs": ["driver/level3/trsm_R.c"],
            "hdrs": ["driver/level3/level3.c"],
            "copts": ["-UTRANSA", "-UUPPER", "-DUNIT"],
        },
        "dtrsm_RNUN": {
            "srcs": ["driver/level3/trsm_R.c"],
            "hdrs": ["driver/level3/level3.c"],
            "copts": ["-UTRANSA", "-DUPPER", "-UUNIT"],
        },
        "dtrsm_RNUU": {
            "srcs": ["driver/level3/trsm_R.c"],
            "hdrs": ["driver/level3/level3.c"],
            "copts": ["-UTRANSA", "-DUPPER", "-DUNIT"],
        },
        "dtrmm_LNUU": {
            "srcs": ["driver/level3/trmm_L.c"],
            "hdrs": ["driver/level3/level3.c"],
            "copts": ["-UTRANSA", "-DUPPER", "-DUNIT"],
        },
        "dtrmm_LNUN": {
            "srcs": ["driver/level3/trmm_L.c"],
            "hdrs": ["driver/level3/level3.c"],
            "copts": ["-UTRANSA", "-DUPPER", "-UUNIT"],
        },
        "dtrmm_LTUU": {
            "srcs": ["driver/level3/trmm_L.c"],
            "hdrs": ["driver/level3/level3.c"],
            "copts": ["-DTRANSA", "-DUPPER", "-DUNIT"],
        },
        "dtrmm_LTUN": {
            "srcs": ["driver/level3/trmm_L.c"],
            "hdrs": ["driver/level3/level3.c"],
            "copts": ["-DTRANSA", "-DUPPER", "-UUNIT"],
        },
        "dtrmm_LNLU": {
            "srcs": ["driver/level3/trmm_L.c"],
            "hdrs": ["driver/level3/level3.c"],
            "copts": ["-UTRANSA", "-UUPPER", "-DUNIT"],
        },
        "dtrmm_LNLN": {
            "srcs": ["driver/level3/trmm_L.c"],
            "hdrs": ["driver/level3/level3.c"],
            "copts": ["-UTRANSA", "-UUPPER", "-UUNIT"],
        },
        "dtrmm_LTLU": {
            "srcs": ["driver/level3/trmm_L.c"],
            "hdrs": ["driver/level3/level3.c"],
            "copts": ["-DTRANSA", "-UUPPER", "-DUNIT"],
        },
        "dtrmm_LTLN": {
            "srcs": ["driver/level3/trmm_L.c"],
            "hdrs": ["driver/level3/level3.c"],
            "copts": ["-DTRANSA", "-UUPPER", "-UUNIT"],
        },
        "dtrmm_RNUU": {
            "srcs": ["driver/level3/trmm_R.c"],
            "hdrs": ["driver/level3/level3.c"],
            "copts": ["-UTRANSA", "-DUPPER", "-DUNIT"],
        },
        "dtrmm_RNUN": {
            "srcs": ["driver/level3/trmm_R.c"],
            "hdrs": ["driver/level3/level3.c"],
            "copts": ["-UTRANSA", "-DUPPER", "-UUNIT"],
        },
        "dtrmm_RNLU": {
            "srcs": ["driver/level3/trmm_R.c"],
            "hdrs": ["driver/level3/level3.c"],
            "copts": ["-UTRANSA", "-UUPPER", "-DUNIT"],
        },
        "dtrmm_RNLN": {
            "srcs": ["driver/level3/trmm_R.c"],
            "hdrs": ["driver/level3/level3.c"],
            "copts": ["-UTRANSA", "-UUPPER", "-UUNIT"],
        },
        "dtrmm_RTUU": {
            "srcs": ["driver/level3/trmm_R.c"],
            "hdrs": ["driver/level3/level3.c"],
            "copts": ["-DTRANSA", "-DUPPER", "-DUNIT"],
        },
        "dtrmm_RTUN": {
            "srcs": ["driver/level3/trmm_R.c"],
            "hdrs": ["driver/level3/level3.c"],
            "copts": ["-DTRANSA", "-DUPPER", "-UUNIT"],
        },
        "dtrmm_RTLU": {
            "srcs": ["driver/level3/trmm_R.c"],
            "hdrs": ["driver/level3/level3.c"],
            "copts": ["-DTRANSA", "-UUPPER", "-DUNIT"],
        },
        "dtrmm_RTLN": {
            "srcs": ["driver/level3/trmm_R.c"],
            "hdrs": ["driver/level3/level3.c"],
            "copts": ["-DTRANSA", "-UUPPER", "-UUNIT"],
        },
        "idamax_k": {
            "srcs": ["kernel/x86_64/iamax_sse2.S"],
            "copts": ["-DDOUBLE"],
        },
        "dger_k": {
            "srcs": ["kernel/generic/ger.c"],
        },
        "dcopy_k": {
            "srcs": ["kernel/x86_64/copy_sse2.S"],
        },
        "dasum_k": {
            "srcs": ["kernel/x86_64/asum_sse2.S"],
        },
        "dscal_k": { # TODO: ...
            "srcs": ["kernel/x86_64/dscal.c"],
            "hdrs": ["kernel/x86_64/dscal_microk_haswell-2.c"],
        },
        "ddot_k": {
            "srcs": ["kernel/x86_64/ddot.c"],
            "hdrs": ["kernel/x86_64/ddot_microk_haswell-2.c"],
        },
        "daxpy_k": {
            "srcs": ["kernel/x86_64/daxpy.c"],
            "hdrs": ["kernel/x86_64/daxpy_microk_haswell-2.c"],
        },
        "dgemv_n": { # TODO: this will have to become a select for other architectures
            "srcs": ["kernel/x86_64/dgemv_n_4.c"],
            "hdrs": ["kernel/x86_64/dgemv_n_microk_haswell-4.c"],
        },
        "dgemv_t": { # TODO: this will have to become a select for other architectures
            "srcs": ["kernel/x86_64/dgemv_t_4.c"],
            "hdrs": ["kernel/x86_64/dgemv_t_microk_haswell-4.c"],
        },
        "dgemm_kernel": {
            "srcs": ["kernel/x86_64/dgemm_kernel_4x8_haswell.S"],
        },
        "dgemm_beta": {
            "srcs": ["kernel/x86_64/gemm_beta.S"],
        },
        "dgemm_itcopy": {
            "srcs": ["kernel/generic/gemm_tcopy_4.c"],
        },
        "dgemm_incopy": {
            "srcs": ["kernel/generic/gemm_ncopy_4.c"],
        },
        "dgemm_otcopy": {
            "srcs": ["kernel/generic/gemm_tcopy_8.c"],
        },
        "dgemm_oncopy": {
            "srcs": ["kernel/generic/gemm_ncopy_8.c"],
        },
        "dswap_k": {
            "srcs": ["kernel/x86_64/swap_sse2.S"],
        },
        "dnrm2_k": {
            "srcs": ["kernel/x86_64/nrm2.S"],
        },
        "dtrsm_iltucopy": {
            "srcs": ["kernel/generic/trsm_ltcopy_4.c"],
            "copts": ["-UOUTER", "-ULOWER", "-DUNIT"],
        },
        "dtrsm_iltncopy": {
            "srcs": ["kernel/generic/trsm_ltcopy_4.c"],
            "copts": ["-UOUTER", "-ULOWER", "-UUNIT"],
        },
        "dtrsm_iunucopy": {
            "srcs": ["kernel/generic/trsm_uncopy_4.c"],
            "copts": ["-UOUTER", "-ULOWER", "-DUNIT"],
        },
        "dtrsm_iunncopy": {
            "srcs": ["kernel/generic/trsm_uncopy_4.c"],
            "copts": ["-UOUTER", "-ULOWER", "-UUNIT"],
        },
        "dtrsm_ilnucopy": {
            "srcs": ["kernel/generic/trsm_lncopy_4.c"],
            "copts": ["-UOUTER", "-DLOWER", "-DUNIT"],
        },
        "dtrsm_ilnncopy": {
            "srcs": ["kernel/generic/trsm_lncopy_4.c"],
            "copts": ["-UOUTER", "-DLOWER", "-UUNIT"],
        },
        "dtrsm_iutncopy": {
            "srcs": ["kernel/generic/trsm_utcopy_4.c"],
            "copts": ["-UOUTER", "-ULOWER", "-UUNIT"],
        },
        "dtrsm_iutucopy": {
            "srcs": ["kernel/generic/trsm_utcopy_4.c"],
            "copts": ["-UOUTER", "-ULOWER", "-DUNIT"],
        },
        "dtrsm_ounucopy": {
            "srcs": ["kernel/generic/trsm_uncopy_8.c"],
            "copts": ["-DOUTER", "-ULOWER", "-DUNIT"],
        },
        "dtrsm_ounncopy": {
            "srcs": ["kernel/generic/trsm_uncopy_8.c"],
            "copts": ["-DOUTER", "-ULOWER", "-UUNIT"],
        },
        "dtrsm_olnucopy": {
            "srcs": ["kernel/generic/trsm_lncopy_8.c"],
            "copts": ["-DOUTER", "-DLOWER", "-DUNIT"],
        },
        "dtrsm_olnncopy": {
            "srcs": ["kernel/generic/trsm_lncopy_8.c"],
            "copts": ["-DOUTER", "-DLOWER", "-UUNIT"],
        },
        "dtrsm_oltncopy": {
            "srcs": ["kernel/generic/trsm_ltcopy_8.c"],
            "copts": ["-DOUTER", "-DLOWER", "-UUNIT"],
        },
        "dtrsm_oltucopy": {
            "srcs": ["kernel/generic/trsm_ltcopy_8.c"],
            "copts": ["-DOUTER", "-DLOWER", "-DUNIT"],
        },
        "dtrsm_outncopy": {
            "srcs": ["kernel/generic/trsm_utcopy_8.c"],
            "copts": ["-DOUTER", "-ULOWER", "-UUNIT"],
        },
        "dtrsm_outucopy": {
            "srcs": ["kernel/generic/trsm_utcopy_8.c"],
            "copts": ["-DOUTER", "-ULOWER", "-DUNIT"],
        },
        "dtrsm_kernel_LT": {
            "srcs": ["kernel/generic/trsm_kernel_LT.c"],
            "copts": ["-DTRSMKERNEL", "-UUPPER", "-DLT", "-UCONJ"],
        },
        "dtrsm_kernel_LN": {
            "srcs": ["kernel/generic/trsm_kernel_LN.c"],
            "copts": ["-DTRSMKERNEL", "-DUPPER", "-DLN", "-UCONJ"],
        },
        "dtrsm_kernel_RT": {
            "srcs": ["kernel/generic/trsm_kernel_RT.c"],
            "copts": ["-DTRSMKERNEL", "-UUPPER", "-DRT", "-UCONJ"],
        },
        "dtrsm_kernel_RN": {
            "srcs": ["kernel/x86_64/dtrsm_kernel_RN_haswell.c"],
            "copts": ["-DTRSMKERNEL", "-DUPPER", "-DRN", "-UCONJ"],
        },
        "dtrmm_iutncopy": {
            "srcs": ["kernel/generic/trmm_utcopy_4.c"],
            "copts": ["-UOUTER", "-ULOWER", "-UUNIT"],
        },
        "dtrmm_iutucopy": {
            "srcs": ["kernel/generic/trmm_utcopy_4.c"],
            "copts": ["-UOUTER", "-ULOWER", "-DUNIT"],
        },
        "dtrmm_iunncopy": {
            "srcs": ["kernel/generic/trmm_uncopy_4.c"],
            "copts": ["-UOUTER", "-ULOWER", "-UUNIT"],
        },
        "dtrmm_iunucopy": {
            "srcs": ["kernel/generic/trmm_uncopy_4.c"],
            "copts": ["-UOUTER", "-ULOWER", "-DUNIT"],
        },
        "dtrmm_iltncopy": {
            "srcs": ["kernel/generic/trmm_ltcopy_4.c"],
            "copts": ["-UOUTER", "-DLOWER", "-UUNIT"],
        },
        "dtrmm_iltucopy": {
            "srcs": ["kernel/generic/trmm_ltcopy_4.c"],
            "copts": ["-UOUTER", "-DLOWER", "-DUNIT"],
        },
        "dtrmm_ilnucopy": {
            "srcs": ["kernel/generic/trmm_lncopy_4.c"],
            "copts": ["-UOUTER", "-DLOWER", "-DUNIT"],
        },
        "dtrmm_ilnncopy": {
            "srcs": ["kernel/generic/trmm_lncopy_4.c"],
            "copts": ["-UOUTER", "-DLOWER", "-UUNIT"],
        },
        "dtrmm_outncopy": {
            "srcs": ["kernel/generic/trmm_utcopy_8.c"],
            "copts": ["-DOUTER", "-ULOWER", "-UUNIT"],
        },
        "dtrmm_outucopy": {
            "srcs": ["kernel/generic/trmm_utcopy_8.c"],
            "copts": ["-DOUTER", "-ULOWER", "-DUNIT"],
        },
        "dtrmm_ounncopy": {
            "srcs": ["kernel/generic/trmm_uncopy_8.c"],
            "copts": ["-DOUTER", "-ULOWER", "-UUNIT"],
        },
        "dtrmm_ounucopy": {
            "srcs": ["kernel/generic/trmm_uncopy_8.c"],
            "copts": ["-DOUTER", "-ULOWER", "-DUNIT"],
        },
        "dtrmm_oltncopy": {
            "srcs": ["kernel/generic/trmm_ltcopy_8.c"],
            "copts": ["-DOUTER", "-DLOWER", "-UUNIT"],
        },
        "dtrmm_oltucopy": {
            "srcs": ["kernel/generic/trmm_ltcopy_8.c"],
            "copts": ["-DOUTER", "-DLOWER", "-DUNIT"],
        },
        "dtrmm_olnncopy": {
            "srcs": ["kernel/generic/trmm_lncopy_8.c"],
            "copts": ["-DOUTER", "-DLOWER", "-UUNIT"],
        },
        "dtrmm_olnucopy": {
            "srcs": ["kernel/generic/trmm_lncopy_8.c"],
            "copts": ["-DOUTER", "-DLOWER", "-DUNIT"],
        },
        "dtrmm_kernel_LN": {
            "srcs": ["kernel/x86_64/dtrmm_kernel_4x8_haswell.c"],
            "copts": ["-DTRMMKERNEL", "-DLEFT", "-UTRANSA"],
        },
        "dtrmm_kernel_LT": {
            "srcs": ["kernel/x86_64/dtrmm_kernel_4x8_haswell.c"],
            "copts": ["-DTRMMKERNEL", "-DLEFT", "-DTRANSA"],
        },
        "dtrmm_kernel_RN": {
            "srcs": ["kernel/x86_64/dtrmm_kernel_4x8_haswell.c"],
            "copts": ["-DTRMMKERNEL", "-ULEFT", "-UTRANSA"],
        },
        "dtrmm_kernel_RT": {
            "srcs": ["kernel/x86_64/dtrmm_kernel_4x8_haswell.c"],
            "copts": ["-DTRMMKERNEL", "-ULEFT", "-DTRANSA"],
        },
    }
)

# The fortran parts of lapack reference implementation which are
# not available otherwise in lapack/ in C.
fortran_library(
    name = "lapack_f",
    srcs = [
        "lapack-netlib/SRC/dgecon.f",
        "lapack-netlib/SRC/dlange.f",
        "lapack-netlib/SRC/dlacn2.f",
        "lapack-netlib/SRC/disnan.f",
        "lapack-netlib/SRC/dlaisnan.f",
        "lapack-netlib/SRC/dlassq.f",
        "lapack-netlib/SRC/drscl.f",
        "lapack-netlib/SRC/dlabad.f",
        "lapack-netlib/SRC/dlatrs.f",
        "lapack-netlib/SRC/dgels.f",
        "lapack-netlib/SRC/dtrtrs.f",
        "lapack-netlib/SRC/dormlq.f",
        "lapack-netlib/SRC/dormqr.f",
        "lapack-netlib/SRC/dorml2.f",
        "lapack-netlib/SRC/dgelqf.f",
        "lapack-netlib/SRC/dgelq2.f",
        "lapack-netlib/SRC/dgeqrf.f",
        "lapack-netlib/SRC/dlascl.f",
        "lapack-netlib/SRC/dlaset.f",
        "lapack-netlib/SRC/ilaenv.f",
        "lapack-netlib/SRC/dlarf.f",
        "lapack-netlib/SRC/iladlr.f",
        "lapack-netlib/SRC/iladlc.f",
        "lapack-netlib/SRC/dlarfg.f",
        "lapack-netlib/SRC/dlapy2.f",
        "lapack-netlib/SRC/dlarfb.f",
        "lapack-netlib/SRC/dgeqr2.f",
        "lapack-netlib/SRC/dlarft.f",
        "lapack-netlib/SRC/iparam2stage.F",
        "lapack-netlib/SRC/iparmq.f",
        "lapack-netlib/SRC/dorm2r.f",
        "lapack-netlib/SRC/ieeeck.f",
    ],
    deps = [
        ":blas",
    ]
)

blas_library(
    name = "lapack",
    srcs = [],
    hdrs = [],
    deps = [":lapack_f"],
    modules = {
        "dgetrf": { "srcs": ["interface/lapack/getrf.c"] },
        "dgesv": { "srcs": ["interface/lapack/gesv.c"] },
        "dgetrf_single": {
            "srcs": ["lapack/getrf/getrf_single.c"],
            "copts": ["-DUNIT"],
        },
        "dgetrs_N_single": {
            "srcs": ["lapack/getrs/getrs_single.c"],
            "copts": ["-UTRANS"],
        },
        "dgetf2_k": {
            "srcs": ["lapack/getf2/getf2_k.c"],
        },
        "dlaswp_plus": {
            "srcs": ["lapack/laswp/generic/laswp_k.c"],
            "hdrs": ["lapack/laswp/generic/laswp_k_8.c"],
            "copts": ["-UMINUS"],
        },
    }
)

genrule(
    name = "cblas_mangling",
    srcs = [],
    outs = ["cblas_mangling.h"],
    cmd = """
        echo '#pragma once' >> $@
        echo '#define F77_GLOBAL(lcname,UCNAME)  lcname##_' >> $@
    """
)

cc_library(
    name = "cblas",
    srcs = [
        "cblas_mangling.h",
        "lapack-netlib/CBLAS/include/cblas.h",
        "lapack-netlib/CBLAS/include/cblas_f77.h",
        "lapack-netlib/CBLAS/src/cblas_globals.c",
        "lapack-netlib/CBLAS/src/cblas_xerbla.c",
        "lapack-netlib/CBLAS/src/xerbla.c",
    ] + glob([
        # only build double precision routines for now
        "lapack-netlib/CBLAS/src/cblas_d*.c",
    ]),
    includes = [
        "lapack-netlib/CBLAS/include",
    ],
    deps = [
        ":blas"
    ],
    visibility = ["//visibility:public"],
)

cc_library(
    # TODO: Only build the double routines and the routines we actually use?
    name = "lapacke",
    srcs = [
        "lapack-netlib/LAPACKE/include/lapacke.h",
        "lapack-netlib/LAPACKE/include/lapacke_utils.h",
        "lapack-netlib/LAPACKE/include/lapacke_mangling.h",
        "lapack-netlib/LAPACKE/src/lapacke_dgels.c",
        "lapack-netlib/LAPACKE/src/lapacke_dgels_work.c",
        "lapack-netlib/LAPACKE/src/lapacke_dgesv.c",
        "lapack-netlib/LAPACKE/src/lapacke_dgesv_work.c",
    ] + glob([
        "lapack-netlib/LAPACKE/src/lapacke_dgecon*.c",
        "lapack-netlib/LAPACKE/src/lapacke_dgetrf*.c",
        "lapack-netlib/LAPACKE/src/lapacke_dlange*.c",
        "lapack-netlib/LAPACKE/utils/lapacke_*.c",
    ]),
    includes = [
        "lapack-netlib/LAPACKE/include",
    ],
    deps = [
        ":lapack"
    ],
)

cc_binary(
    name = "lapacke_example_user",
    srcs = [
        "lapack-netlib/LAPACKE/example/example_user.c",
    ],
    deps = [
        ":lapacke"
    ]
)

cc_binary(
    name = "example_DGELS_colmajor",
    srcs = [
        "lapack-netlib/LAPACKE/example/example_DGELS_colmajor.c",
        "lapack-netlib/LAPACKE/example/lapacke_example_aux.c",
        "lapack-netlib/LAPACKE/example/lapacke_example_aux.h",
    ],
    deps = [
        ":lapacke"
    ]
)

cc_binary(
    name = "example_DGELS_rowmajor",
    srcs = [
        "lapack-netlib/LAPACKE/example/example_DGELS_rowmajor.c",
        "lapack-netlib/LAPACKE/example/lapacke_example_aux.c",
        "lapack-netlib/LAPACKE/example/lapacke_example_aux.h",
    ],
    deps = [
        ":lapacke"
    ]
)

cc_binary(
    name = "example_DGESV_rowmajor",
    srcs = [
        "lapack-netlib/LAPACKE/example/example_DGESV_rowmajor.c",
        "lapack-netlib/LAPACKE/example/lapacke_example_aux.c",
        "lapack-netlib/LAPACKE/example/lapacke_example_aux.h",
    ],
    deps = [
        ":lapacke"
    ]
)

cc_binary(
    name = "example_DGESV_colmajor",
    srcs = [
        "lapack-netlib/LAPACKE/example/example_DGESV_colmajor.c",
        "lapack-netlib/LAPACKE/example/lapacke_example_aux.c",
        "lapack-netlib/LAPACKE/example/lapacke_example_aux.h",
    ],
    deps = [
        ":lapacke"
    ]
)

cc_binary(
    name = "cblas_example1",
    srcs = [
        "lapack-netlib/CBLAS/examples/cblas_example1.c",
    ],
    deps = [
        ":cblas"
    ]
)

cc_binary(
    name = "cblas_example2",
    srcs = [
        "lapack-netlib/CBLAS/examples/cblas_example2.c",
    ],
    deps = [
        ":cblas"
    ]
)
