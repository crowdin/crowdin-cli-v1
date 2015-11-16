# Crowdin-CLI

[Crowdin Integration Utility Homepage](http://crowdin.com/page/cli-tool)
 | [Support](http://crowdin.com/contacts)
 | [crowdin.com Homepage](http://crowdin.com)
 | [crowdin-api RubyDoc](http://rubydoc.info/github/crowdin/crowdin-api/)

A Command-Line Interface to sync files between local computer/server and [Crowdin](crowdin.com).

It is cross-platform and can be run in a terminal (Linux, MacOS X) or in cmd.exe (Windows).

![ScreenShot](https://raw.github.com/crowdin/crowdin-cli/master/screenshot.png)

> **WARNING**: This is a development version: It contains the latest changes, but may also have several known issues, including crashes and data loss situations. In fact, it may not work at all.

## Installation

Add this line to your application's Gemfile:

```
gem 'crowdin-cli'
```

And then execute:
```
$ bundle
```

Or install it manually as:
```
$ gem install crowdin-cli
```

## Configuration

When the tool is installed, you would have to configure your project. Basically, `crowdin-cli` go through project directory, and looks for `crowdin.yaml` file that contains project information.

Create `crowdin.yaml` YAML file in your root project directory with the following structure:

```
project_identifier: test
api_key: KeepTheAPIkeySecret
base_url: https://api.crowdin.com
base_path: /path/to/your/project

files:
  -
    source: /locale/en/LC_MESSAGES/messages.po
    translation: /locale/%two_letters_code%/LC_MESSAGES/%original_file_name%
```

* `api_key` - Crowdin Project API key
* `project_identifier` - Crowdin project name
* `base_url` - (default: https://api.crowdin.com)
* `base_path` - defines what directory have to be scanned (default: current directory)
* `files`
  * `source` - defines only files that should be uploaded as sources
  * `translation` - defines where translations should be placed after downloading (also the path have to be checked to detect and upload existing translations)

        Use the following placeholders to put appropriate variables into the resulting file name:
      * `%language%` - Language name (i.e. Ukrainian)
      * `%two_letters_code%` - Language code ISO 639-1 (i.e. uk)
      * `%three_letters_code%` - Language code ISO 639-2/T (i.e. ukr)
      * `%locale%` - Locale (like uk-UA)
      * `%locale_with_underscore%` - Locale (i.e. uk_UA)
      * `%original_file_name%` - Original file name
      * `%android_code%` - Android Locale identifier used to name "values-" directories
      * `%original_path%` - Take parent folders names in Crowdin project to build file path in resulted bundle
      * `%file_extension%` - Original file extension
      * `%file_name%` - File name without extension
      * `%osx_code%` - OS X Locale identifier used to name ".lproj" directories
      * `%osx_xliff%` - OS X Locale used to name xliff files (i.e. uk.xliff)

         Example for Android projects:
          ```
          /values-%android_code%/%original_file_name%
          ```
         Example for Gettext projects:
          ```
          /locale/%two_letters_code%/LC_MESSAGES/%original_file_name%
          ```

You can also add and upload all directories matching the pattern, including all nested files and localizable files.

Configuration example provided above has 'source' and 'translation' attributes containing standard wildcards (also known as globbing patterns) to make it easier to work with multiple files.

Here are the patterns you can use:

* `*` (asterisk)

 Match zero or more characters in file name. A glob consisting of only the asterisk and no other characters will match all files in the directory. If you specified a `*.json` it will include all files like `messages.json`, `about_us.json` and anything that ends with `.json`.c* will match all files beginning with c; `*c` will match all files ending with c; and `*c*` will match all files that have c in them (including at the beginning or end). Equivalent to `/ .* /x` in regexp.

* `**` (doubled asterisk)

 Match all the directories recursively. Note that you can use `**` in `source` and in `translation` pattern. When using `**` in `translation` pattern it will always contain sub-path from `source` for certain file. The mask `**` can be used only once in the pattern and must be surrounded by backslashes `/`.

* `?` (question mark)

 Matches any one character.

* `[set]`

 Matches any one character in set. Behaves exactly like character sets in `Regexp`, including set negation (`[^a-z]`).

* `\` (backslash)

 Escapes the next metacharacter.

 Say, you can have source: `/en/**/*.po` to upload all `*.po` files to Crowdin recursively. `translation` pattern will be `/translations/%two_letters_code%/**/%original_file_name%'`.

See sample configuration below:
```
---
project_identifier: test
api_key: KeepTheAPIkeySecret
base_url: https://api.crowdin.com
base_path: /path/to/your/project

files:
  -
    source: /locale/en/**/*.po
    translation: /locale/%two_letters_code%/**/%original_file_name%
```

### API Credentials from environment variables

You could load the API Credentials from an environment variable, e.g.

```
api_key_env: CROWDIN_API_KEY
project_identifier_env: CROWDIN_PROJECT_ID
base_path_env: CROWDIN_BASE_PATH

```

If mixed, `api_key` and `project_identifier` have priority:

```
api_key_env: CROWDIN_API_KEY            # Low priority
project_identifier_env: CROWDIN_PROJECT # Low priority
base_path_env: CROWDIN_BASE_PATH        # Low priority
api_key: xxx                            # High priority
project_identifier: yyy                 # High priority
base_path: zzz                          # High priority
```

### Split project configuration and user credentials

The `crowdin.yaml` file contains project-specific configuration and user credentials(`api_key`, `project_identifier`, `base_path`).
This means that you can't commit this file in the code repository, because the API key would leak to other users. `crowdin-cli` allow 2 configuration files:

* a project-specific, residing in the project directory (required)
* a user-specific, probably residing in `$HOME/.crowdin.yaml` (optional)

**NOTE**: user credentials in user-specific configuration file is higher priority than project-specific.

### Languages mapping

Often software projects have custom names for locale directories. `crowdin-cli` allows you to map your own languages to understandable by Crowdin.

Let's say your locale directories named 'en', 'uk', 'fr', 'de'. All of them can be represented by `%two_letters_code%` placeholder. Still, you have one directory named 'zh_CH'. In order to make it work with `crowdin-cli` without changes in your project you can add `languages_mapping` section to your files set. See sample configuration below:

```
---
project_identifier: test
api_key: KeepTheAPIkeySecret
base_url: https://api.crowdin.com
base_path: /path/to/your/project

files:
  -
    source: /locale/en/**/*.po
    translation: /locale/%two_letters_code%/**/%original_file_name%
    languages_mapping:
      two_letters_code:
        # crowdin_language_code: local_name
        ru: ros
        uk: ukr
```
Mapping format is the following: `crowdin_language_code : code_use_use`.

Check [complete list of Crowdin language codes](http://crowdin.com/page/api/language-codes) that can be used for mapping.

You can also override language codes for other placeholders like `%android_code%`, `%locale%` etc...

### Ignoring directories

From time to time there are files and directories you don't want translate on Crowdin.
Local per-file rules can be added to the config file in your project.

```
files:
  -
    source: /locale/en/**/*.po
    translation: /locale/%two_letters_code%/**/%original_file_name%
    ignore:
      - /locale/en/templates
      - /locale/en/**/test-*.po
      - /locale/en/**/[^abc]*.po

```

### Preserving directories hierarchy

By default CLI tool tries to optimize your Crowdin project hierarchy and do not repeats complete path of local files online.
In case you need to keep directories structure same at Crowdin and locally you can add `preserve_hierarchy: true` option in main section of the configuration file.

Configuration sample is below:

```
---
project_identifier: test
api_key: KeepTheAPIkeySecret
base_url: https://api.crowdin.com
base_path: /path/to/your/project
preserve_hierarchy: true
```

### Uploading files to specified path with specified type

This add support for 2 optional parameters in the yaml file section: `dest` and `type`.
This is useful typically for some projects, where the uploaded name must be different so Crowdin can detect the type correctly.
`dest` allows you to specify a file name on Crowdin.
**NOTE**: `dest` only works for single files. Don't try to use it with patterns (multiple files).

Configuration sample is below:

```
files
  -
    source: '/conf/messages'
    dest: '/messages.properties'
    translation: '/conf/messages.%two_letters_code%'
    type: 'properties'


```

### Escape quotes for `.properties` file format

Defines whether single quote should be escaped by another single quote or backslash in exported translations.
You can add `escape_quote: <value>` per-file option.
Acceptable values are: 0, 1, 2, 3. Default is 3.

* 0 — Do not escape single quote;
* 1 — Escape single quote by another single quote;
* 2 — Escape single quote by backslash;
* 3 — Escape single quote by another single quote only in strings containing variables ( {0} )

```
---
project_identifier: test
api_key: KeepTheAPIkeySecret
base_url: https://api.crowdin.com
base_path: /path/to/your/project

files:
  -
   source: '/en/strings.properties'
   translation: '/%two_letters_code%/%original_file_name%'
   escape_quotes: 1
```

### Uploading CSV files via API

```
---
project_identifier: test
api_key: KeepTheAPIkeySecret
base_url: https://api.crowdin.com
base_path: /path/to/your/project

files:
  -
   source: '/*.csv'
   translation: '%two_letters_code%/%original_file_name%'
   # Defines whether first line should be imported or it contains columns headers
   first_line_contains_header: true
   # Used only when uploading CSV file to define data columns mapping.
   scheme: "identifier,source_phrase,translation,context,max_length"
```

#### Multicolumn CSV

In case CSV file contains translations to all target languages you can use per-file option `multilingual_spreadsheet`.

CSV file example:
```
identifier,source_phrase,context,Ukrainian,Russian,French
ident1,Source 1,Context 1,,,
ident2,Source 2,Context 2,,,
ident3,Source 3,Context 3,,,
```

Configuration file example:
```
files:
  -
    source: multicolumn.csv
    translation: multicolumn.csv
    first_line_contains_header: true
    scheme: "identifier,source_phrase,context,uk,ru,fr"
    multilingual_spreadsheet: true

```

### Versions Management

In version `0.5.0` we added support for versions management feature in Crowdin. Read more in our [blog](http://blog.crowdin.com/post/130133108120/new-feature-versions-management).

This is how Crowdin CLI command looks like if you upload source texts from the branch: 

```
crowdin-cli upload sources -b {branch_name}
```

Upload translations texts from the branch:

```
crowdin-cli upload translations -b {branch_name}
```

Download translations from the branch:

```
crowdin-cli download -b {branch_name}

```

## Configurations Examples

### GetText Project

```
---
project_identifier: test
api_key: KeepTheAPIkeySecret
base_url: https://api.crowdin.com
base_path: /path/to/your/project

files:
  -
    source: '/locale/en/**/*.po'
    translation: '/locale/%two_letters_code%/LC_MESSAGES/%original_file_name%'
    languages_mapping:
      two_letters_code:
        'zh-CN': 'zh_CH'
        'fr-QC': 'fr'
```

### Android Project

```
---
project_identifier: test
api_key: KeepTheAPIkeySecret
base_url: https://api.crowdin.com
base_path: /path/to/your/project

files:
  -
   source: '/res/values/*.xml'
   translation: '/res/values-%android_code%/%original_file_name%'
   languages_mapping:
     android_code:
       # we need this mapping since Crowdin expects directories
       # to be named like "values-uk-rUA"
       # acording to specification instead of just "uk"
       de: de
       ru: ru
```

## Usage

When the configuration file is created, you are ready to start using `crowdin-cli` to manage your localization resources and automate files synchronization.

We listed most typical commands that crowdin-cli is used for:

Upload your source files to Crowdin:
```
$ crowdin-cli upload sources
```

Upload existing translations to Crowdin project (translations will be synchronized):
```
$ crowdin-cli upload translations
```

Download latest translations from Crowdin:
```
$ crowdin-cli download
```

List information about the files that already exists in current project:
```
$ crowdin-cli list project
```

List information about the sources files in current project that match the wild-card pattern:
```
$ crowdin-cli list sources
```

List information about the translations files in current project that match the wild-card pattern:
```
$ crowdin-cli list translations
```

By default, `list` command print a list of all the files
Also, `list` accept `-tree` optional argument to list contents in a tree-like format.


Get help on `upload` command:
```
$ crowdin-cli help upload
```

Get help on `upload sources` command:
```
$ crowdin-cli help upload sources
```

Use help provided with an application to get more information about available commands and options:


## Supported Rubies

Tested with the following Ruby versions:

- MRI 2.2.1
- JRuby 9.0.0.0

## Creating a JAR file

Installation/SystemRequirements:

- Linux
- Java
- rvm

Install JRuby `>=9.0.0.0` and Warbler gem `>=2.0.0`:

```
$ rvm install jruby
$ gem install warbler --pre
```

Create a new file called `Gemfile` in new project directory, an specify `crowdin-cli` version:

```ruby
source 'https://rubygems.org'
gem 'crowdin-api', '=0.4.0'
gem 'crowdin-cli', '=0.5.1'
```

Create a new file called `bin/crowdin-cli`:

```ruby
#!/usr/bin/env ruby_noexec_wrapper

# The application 'crowdin-cli' is installed as part of a gem, and
# this file is here to facilitate running it.
#

require 'rubygems'

version = ">= 0"

if ARGV.first =~ /^_(.*)_$/ and Gem::Version.correct? $1 then
  version = $1
  ARGV.shift
end

gem 'crowdin-cli', version
load Gem.bin_path('crowdin-cli', 'crowdin-cli', version)
```

Install dependencies:

```
$ bundle
```

Compile/package with Warbler:

```
$ warble jar
```

and rename `warbler.jar` to whatever you want.

Run jar in any computer with installed Java:

```
java -jar <myapp>.jar
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License and Author

Author: Anton Maminov (anton.maminov@gmail.com)

Copyright: 2012-2015 [crowdin.com](http://crowdin.com/)

This project is licensed under the MIT license, a copy of which can be found in the LICENSE file.
