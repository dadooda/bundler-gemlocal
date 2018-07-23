bundler-gemlocal
================

Local Gemfile solution that works

## Overview

By using `bundler-gemlocal` developers can have their own custom Gemfile, called `Gemlocal` by default, in addition to team-wide `Gemfile`. The solution is easy to use and ensures no issues with `Gemfile.lock`.

## Setup

1. Download `bundler-gemlocal.sh` into your home directory:

    ```sh
    $ cd
    $ curl https://raw.githubusercontent.com/dadooda/bundler-gemlocal/master/bundler-gemlocal.sh -O
    ```

2. Edit your user's shell startup files to source `bundler-gemlocal.sh`. I recommend `.bashrc`. If you don't have one, edit `.profile`:

    ```sh
    $ echo -e "\n. bundler-gemlocal.sh" >> .bashrc
    ```

3. Reload your shell (Mac users: open new Terminal window). Then check that `b` function is available:

    ```sh
    $ type -t b
    function
    ```

## Usage

* `b` is a Gemlocal-aware alias to `bundle`.
* `bx` is a Gemlocal-aware alias to `bundle exec`.

Examples:

```sh
$ b install --path vendor/bundle
$ b check
$ bx gem list -l
$ bx rails console
…
```

## Project setup example

1. Cd to your project directory:

    ```sh
    $ cd /path/to/project
    ```

2. Edit `.gitignore`:

    ```
    /Gemlocal
    /Gemlocal.lock
    ```

3. Edit `config/boot.rb` or the file which initializes Bundler in your project:

    ```ruby
    ENV["BUNDLE_GEMFILE"] ||= File.exists?(fn = File.expand_path("../../Gemlocal", __FILE__)) ? fn : File.expand_path("../../Gemfile", __FILE__)
    ```

    > Ruby 2.0+ users may prefer to use `File.expand_path("../Gemlocal", __dir__)` which looks a little less cryptic.

4. Edit `Gemlocal`:

    ```ruby
    # Source the main Gemfile.
    eval_gemfile File.expand_path("../Gemfile", __FILE__)

    group :development do
      # Console enhancements etc.
      gem "irb_hacks"
      gem "ori"
      gem "rdoc"
      gem "wirb"
      # …
    end
    ```

5. Install the local bundle for the first time:

    ```sh
    $ b install
    ```

6. Add `Gemlocal.example`:

    ```sh
    $ curl https://raw.githubusercontent.com/dadooda/bundler-gemlocal/master/Gemlocal.example -O
    ```

7. **All done!** From now on, keep editing both `Gemfile` and `Gemlocal` as you like. Then do a `b install` and it'll sort everything out for you.

## Why not `Gemfile.local`?

1. Because I like this:

    ```sh
    $ ls -1 Gem*
    Gemfile           # o
    Gemfile.lock      # o
    Gemlocal          # -
    Gemlocal.lock     # -
    ```

    more than this:

    ```sh
    $ ls -1 Gem*
    Gemfile               # o
    Gemfile.local         # -
    Gemfile.local.lock    # -
    Gemfile.lock          # o
    ```

    > Legend: (`o`: in the repo, `-`: not in the repo).

2. Because "Gemlocal" is **both** a term and a filename, just like "Gemfile". It's more documentation-friendly.
3. Because Internet is full of half-working `Gemfile.local` recipes that will cause you nothing but pain. Find this page by the word "Gemlocal" and stay trouble-free!

## Example `Gemlocal` guidelines for a Rails project team

1. Git should ignore `Gemlocal` and `Gemlocal.lock` in project root (see [Project setup example](#project-setup-example)).
2. A basic `Gemlocal.example` with comments on how to enable it should be in Git repository.
3. Team-wide `Gemfile` should contain no "developer comfort" gems (consoles, debuggers, profilers, &hellip;) or contain a bare, safe, time-proven, approved minimum set of 1-2 items. Adding more of such gems to `Gemfile` should be prohibited.
4. Rails initializers (`config/initializers/*`) for "developer comfort" gems should gracefully handle the case when a specific gem is missing.
   1. A simple yet effective way is to achieve it is via "example files". Say, `subsys.rb` should be ignored by Git, whereas `subsys.rb.example` should be in Git repository.
5. It's highly desirable that `Gemlocal.example` lists, in a commented form, all "developer comfort" gems which are known to be used by particular team members.
6. Project documentation should list Bundler commands in their canonical form: `bundle …`. Documentation sections covering developer tools should mention that the project is ready for `bundler-gemlocal` use.

## Cheers!

Feedback of any kind is highly appreciated.

&mdash; Alex Fortuna, &copy; 2015-2018
