# Ovaltine [![Build Status](https://travis-ci.org/kattrali/ovaltine.svg?branch=master)](https://travis-ci.org/kattrali/ovaltine)

The chocolatey treat which makes your code clean! Yum!

`Ovaltine` scans your `storyboard` files and generates constant files for view controller, segue, and reuse identifiers. For instance, if you have a storyboard called `Main` and a view controller with the Storyboard ID `authenticationViewController`, then you can instantiate that controller with something like `[ABCMainStoryboard instantiateAuthenticationViewController]`. No mistyping, plenty of chocolately goodness.

## Installation

```
gem install ovaltine
```

## Example Usage

```
ovaltine --prefix ABC --auto-replace --auto-add --project path/to/project.xcodeproj path/to/project/files
```

Run from the command line or as a build step (if you are brave!)

## Additional Documentation

```
ovaltine --help
```
