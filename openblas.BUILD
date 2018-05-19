# TODO: Disable nancheck
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
        "dgemv": { "srcs": ["interface/gemv.c"] },
        "dgemm": { "srcs": ["interface/gemm.c"] },
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
        "idamax_k": {
            "srcs": ["kernel/x86_64/iamax_sse2.S"],
            "copts": ["-DDOUBLE"],
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
    }
)

# The fortran parts of lapack reference implementation which are
# not available otherwise in lapack/ in C.
fortran_library(
    name = "lapack",
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
    ],
    deps = [
        ":blas",
    ]
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
