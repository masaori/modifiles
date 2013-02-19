# Modifiles

Check and detect modified files using `git diff`.

## Installation

Add this line to your application's Gemfile:

    gem 'modifiles'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install modifiles

## Usage

Stamp first:

	Modifiles::Checker.stamp_file_path = '/your/stamp/file_path'
	Modifiles::Checker.stamp # Record latest git commit SHA

Collect modified files after some commits:

	Modifiles::Checker.modified_files # => ['/GIT_ROOT/files_modified', '/GIT_ROOT/since', '/GIT_ROOT/latest_commit_stamp']
