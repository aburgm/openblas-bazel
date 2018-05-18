local_repository(
    name = "fortran_rules",
    path = "tools/fortran_rules",
)

new_http_archive(
	name = "openblas",
	url = "http://github.com/xianyi/OpenBLAS/archive/v0.2.20.zip",
	sha256 = "bb5499049cf60b07274740a4ddd756daa0fe2c817d981d7fe7e5898dcf411fdc",
	strip_prefix = "OpenBLAS-0.2.20",
	build_file = "openblas.BUILD"
)
