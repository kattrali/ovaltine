# Ovaltine [![Build Status](https://travis-ci.org/kattrali/ovaltine.svg?branch=master)](https://travis-ci.org/kattrali/ovaltine)

The chocolatey treat which makes your code clean! Yum!

`Ovaltine` scans your `storyboard` files and generates constant files for view controller, segue, and reuse identifiers. For instance, if you have a storyboard called `Main` and a view controller with the Storyboard ID `authenticationViewController`, then you can instantiate that controller with something like `[ABCMainStoryboard instantiateAuthenticationViewController]`. No mistyping, plenty of chocolatey goodness.

## Installation

```
gem install ovaltine
```

## Example Usage

```
ovaltine --prefix ABC --auto-replace --auto-add path/to/project/files
```

Run from the command line or as a build step (if you are brave!) [Here](https://gist.github.com/kattrali/bbe9e2464d02a8ca4cb1) are some example files generated using `ovaltine`.

## Additional Documentation

```
ovaltine --help
```

## Development

`Ovaltine` is tested using [bacon](https://github.com/chneukirchen/bacon). After running `bundle install`, the tests can be run using the command `rake spec`.
