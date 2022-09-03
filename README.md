# cmrk 

Useful CMake modules that are reusable enough for a variety of builds.

CMRK = CMake ReinKing modules. I am an egomaniac (but also open to better names).

Requires CMake 3.22+. Subject to rapid updates and changes while on [major version 0](https://semver.org/#spec-item-4).

## Setup

### Find package

```
cmake_minimum_required(VERSION 3.22)
project(example)

find_package(cmrk REQUIRED)

# ... include() cmrk modules here ...
```

### FetchContent

```
cmake_minimum_required(VERSION 3.22)
project(example)

include(FetchContent)

FetchContent_Declare(
  cmrk
  GIT_REPOSITORY https://github.com/alexreinking/cmrk.git
  GIT_TAG        some_git_sha_here
)

FetchContent_MakeAvailable(cmrk)

# ... include() cmrk modules here ...
```

## API documentation

### `cmrk_git_version_string`

```
cmrk_git_version_string(
  OUTPUT_VARIABLE <var-name>
  [REQUIRED]
  [TEMPLATE <string>]
)
```

This function computes a version string for your project from the CMake
`PROJECT_VERSION` variable and the results of `git describe --tags`.

The overall operation is as follows:

1. Check if the current project's source directory has a `.git` folder. If not, bail.
2. Find the git executable via `find_package(Git)`. If it cannot be found, bail.
3. Run `git describe --tags` in the project's source directory. If it returns an error status, bail.
4. Store the result from the previous step in a variable named `GIT_VERSION`.
5. If `GIT_VERSION` is identical to `PROJECT_VERSION`, write `${PROJECT_VERSION}` to `<var-name>` and return normally.
6. Otherwise, interpret `TEMPLATE` as an `@ONLY` configuration string and write the result to `<var-name>`.

The default `TEMPLATE` is `@PROJECT_VERSION@ (git~@GIT_VERSION@)`

The meaning of "bail" is determined by the `REQUIRED` argument. If it is set,
then a fatal error is issued and configuration stops. Otherwise, `<var-name>`
is set to `${PROJECT_VERSION}`.

For an example, see [examples/git_version_string](./examples/git_version_string)
