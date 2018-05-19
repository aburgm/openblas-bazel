# Build the given modules of the OpenBLAS library.
# srcs are common headers to make visible to all modules.
# TODO(armin): with a custom rule we could probably prevent
# having to create one library for every module.
def blas_library(name, srcs, hdrs, deps, modules):
    all_libraries = []

    DTYPE_MAP = {
        'd': ['-DDOUBLE'],
        's': ['-DSINGLE'],
    }

    for module in modules:
        native.cc_library(
            name = name + "_" + module,
            srcs = hdrs + modules[module]['srcs'],
            hdrs = modules[module].get('hdrs', []),
            deps = deps,
            copts = modules[module].get('copts', []) + DTYPE_MAP.get(module[0], []) + [
                "-DASMNAME=" + module,
                "-DASMFNAME=" + module + "_",
                "-DNAME=" + module + "_",
                "-DCNAME=" + module,
                "-DCHAR_NAME=\\\"" + module + "_\\\"",
                "-DCHAR_CNAME=\\\"" + module + "\\\"",
            ],
        )

        all_libraries.append(":" + name + "_" + module)

    native.cc_library(
        name = name,
        srcs = srcs,
        deps = all_libraries
    )
