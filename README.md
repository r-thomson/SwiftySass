# SwiftySass

A [LibSass](https://github.com/sass/libsass) wrapper for Swift.

[![](https://img.shields.io/static/v1?label=Platforms&message=macOS&color=lightgrey&style=for-the-badge "Officially supported platforms")](https://github.com/r-thomson/SwiftySass)
[![](https://img.shields.io/github/v/tag/r-thomson/SwiftySass?sort=semver&label=Latest&style=for-the-badge  "Latest release version")](https://github.com/r-thomson/SwiftySass/releases)
[![](https://img.shields.io/github/workflow/status/r-thomson/SwiftySass/Swift?label=Tests&style=for-the-badge  "Build & test status (master)")](https://github.com/r-thomson/SwiftySass/actions)

This project is not yet finished, so some features are not yet supported:

- All configuration options
- Linux support
- Custom Sass functions
- Custom Sass importers

## Installation

First, you also need to have LibSass installed on your system. SwifySass expects the installation to be located at `/usr/local/include/`. Using [Homebrew](https://brew.sh) is suggested:

```sh
brew install libsass
```

SwiftySass can be installed using [Swift Package Manager](https://swift.org/package-manager/). To use SwiftySass in a project, add it to the `dependencies` section in your project’s `Package.swift`:

```swift
.package(url: "https://github.com/r-thomson/SwiftySass", from: "0.1.0")
```

## Usage

```swift
import SwiftySass

let scss = """
$primary-color: #222;
body {
  color: $primary-color;
}
"""

let css = try? compileSass(source: scss)
```
