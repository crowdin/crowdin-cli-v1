# Crowdin-CLI

A Command-Line Interface to sync files between your computer/server and [Crowdin](crowdin.net).

It is cross-platform and runs in a terminal (Linux, MacOS X) or in cmd.exe (Windows).

> **WARNING**: This is a development version: It contains the latest changes, but may also have severe known issues, including crashes and data loss situations. In fact, it may not work at all.

## Installation

Add this line to your application's Gemfile:

```
gem 'crowdin-cli'
```

And then execute:
```
$ bundle
```

Or install it yourself as:
```
$ gem install crowdin-cli
```

## Configuration

Now that the tool in installed, you'll have to configure your project. Basically, `crowdin-cli` is to be run on a project directory, and looks for a `crowdin.yaml` file containing your project information.

Create a `crowdin.yaml` YAML file in your root project directory with the following structure:

```
---
project_idenfier: test
api_key: KeepTheAPIkeySecret
base_url: http://api.crowdin.net
base_path: /path/to/your/project

files:
  -
    source: /locale/en/LC_MESSAGES/messages.po
    translation: /locale/%two_letters_code%/LC_MESSAGES/%original_file_name%
```

* `api_key` - Crowdin Project API key
* `project_identifier` - Crowdin project name
* `base_url` - (default: http://api.crowdin.net)
* `base_path` - defines what directory we have to scan(default: current directory)
* `files`
  * `source` - defines only files we will upload as sources
  * `translation` - attribute defines where translations should be placed after downloading (also we have to check those path to detect and upload existing translations)

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

         Example for Android projects:
          ```
          /values-%android_code%/%original_file_name%
          ```
         Example for Gettext projects:
          ```
          /locale/%two_letters_code%/LC_MESSAGES/%original_file_name%
          ```

Also you can add and upload all directories mathing the pattern including all nested files and localizable files.

Create a `crowdin.yaml` YAML file in your root project directory with the following structure:
```
---
project_identifier: test
api_key: KeepTheAPIkeySecret
base_url: http://api.crowdin.net
base_path: /path/to/your/project

files:
  -
    source: /locale/en/**/*.po
    translation: /locale/%two_letters_code%/**/%original_file_name%
```

Languages mapping.

```
---
project_identifier: test
api_key: KeepTheAPIkeySecret
base_url: http://api.crowdin.net
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

## Usage

When the configuration file is created you are ready to start using `crowdin-cli` to manage your localization resources and automate files synchronization. 

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

- MRI 1.9.3
- JRuby 1.7.0

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License

This library is distributed under the MIT license.  Please see the LICENSE file.