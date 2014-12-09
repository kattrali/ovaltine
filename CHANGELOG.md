# 1.1.0

- [Breaking Change] Allow 'segue' as a segue identifier suffix. Segue names 
  ending with 'segue' will not have 'SegueIdentifier' appended to them.
- Hotfix for cached constant names generating duplicates
- Remove casting from view controller convenience selectors, instead returning 'id'

# 1.0.6

- Add option to write custom copyright text
- Sort identifiers alphabetically, reducing diffs

# 1.0.5

- Cache identifiers for navigation controllers
- Hotfix for writing duplicate identifiers

# 1.0.4

- Hotfix for failed error handling in Ruby 1.8.7
- Avoid writing xcode project files when no files added
- Add language argument for potentially generating templates in other languages
- Prefix identifier constants

# 1.0.3

- Experimental support for adding generated files to Xcode project

# 1.0.2

- Hotfix for Ruby 1.8.7

# 1.0.1

- Make error message more verbose

# 1.0.0

- Initial release!