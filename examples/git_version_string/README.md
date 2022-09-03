This example shows the usage of `cmrk_git_version_string` and `cmrk_option`.

---

To build without needing to install cmrk, use the following command (on Linux):

```
$ cmake -G Ninja -S . -B build -DCMAKE_MODULE_PATH=$PWD/..
$ cmake --build build
$ ./build/example
version 1.42.3
```

The parent directory contains a shim `Findcmrk.cmake` script that redirects to
`add_subdirectory`.

---

To test the behavior of `cmrk_git_version_string`, start by initializing a git
repo in this directory:

```
$ git init
$ git add .
$ git commit -m "initial commit"
```

Now let's tag this commit:

```
$ git tag foobar
```

And we'll re-configure and re-build anew:

```
$ cmake -G Ninja -S . -B build -DCMAKE_MODULE_PATH=$PWD/.. -UEXAMPLE_VERSION_STRING
$ cmake --build build
$ ./build/example
version 1.42.3 (git~foobar)
```

Then add a few dummy commits:

```
$ git commit --allow-empty -m "poke"
$ git commit --allow-empty -m "poke"
$ git commit --allow-empty -m "poke"
```

Repeat the above steps and then see:

```
$ ./build/example
version 1.42.3 (git~foobar-3-ge60020f)
```

Finally, let's tag this commit with the exact version number:

```
$ git tag 1.42.3
```

Now reconfigure and rebuild (don't forget to delete the cache variable with
`-U` as above)

```
$ ./build/example
version 1.42.3
```

Now that the tag exactly matches the version, the string does not contain
`(git~1.42.3)` redundantly. Finally, delete the git repository we used to test:

```
$ rm -rf .git
```
