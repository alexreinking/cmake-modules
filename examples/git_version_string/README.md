This example shows the usage of `cmrk_git_version_string` and `cmrk_option`.

---

To build without needing to install cmrk, use the following command (on Linux):

```
$ cmake -G Ninja -S . -B build -DCMAKE_MODULE_PATH=$PWD/..
$ cmake --build build
$ ./build/example
version 1.24.3
```

The parent directory contains a shim `Findcmrk.cmake` script that redirects to
`add_subdirectory`.
