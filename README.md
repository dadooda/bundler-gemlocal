bundler-gemlocal
================

Local Gemfile solution that works

Overview
--------

By using `bundler-gemlocal` developers can have their own custom Gemfile (called `Gemlocal` by default). The solution is easy to use and ensures no issues with team-wide `Gemfile.lock`.

Setup
-----

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

Usage
-----

* `b` is a Gemlocal-aware alias to `bundle`.
* `bx` is a Gemlocal-aware alias to `bundle exec`.

Examples:

```sh
$ b install --path vendor/bundle
$ b check
$ bx gem list -l
$ bx rails console
etc.
```

Project setup example
---------------------

1. Edit `.gitignore`:

  ```
  /Gemlocal
  /Gemlocal.lock 
  ```
  
2. Edit `config/boot.rb` or the file which initializes Bundler in your project:

  ```
  ENV["BUNDLE_GEMFILE"] ||= File.exists?(fn = File.expand_path("../../Gemlocal", __FILE__)) ? fn : File.expand_path("../../Gemfile", __FILE__)
  ```

3. Edit `Gemlocal`:

  ```
  # Source the main Gemfile.
  eval_gemfile File.expand_path("../Gemfile", __FILE__)

  group :development do
    # Console enhancements etc.
    gem "irb_hacks"
    gem "ori"
    gem "rdoc"
    gem "wirb"
    # etc.
  end
  ```

4. Install the local bundle for the first time:

  ```sh
  $ cp Gemfile.lock Gemlocal.lock
  $ b install
  ```

5. **All done!** From now on, keep editing both `Gemfile` and `Gemlocal` as you like. Then do a `b install` and it'll sort everything out for you.

Why not `Gemfile.local`?
------------------------

1. Because I like this:

  ```
  $ ls -1 Gem*
  Gemfile           # o
  Gemfile.lock      # o
  Gemlocal          # -
  Gemlocal.lock     # -
  ```

  more than this:

  ```
  $ ls -1 Gem*
  Gemfile               # o
  Gemfile.local         # -
  Gemfile.local.lock    # -
  Gemfile.lock          # o
  ```

  > Legend: (`o`: in the repo, `-`: not in the repo).

2. Because "Gemlocal" is **both** a term and a filename, just like "Gemfile". It's more documentation-friendly.
3. Because the blogs are full of half-working `Gemfile.local` recipes which will cause you nothing but pain. Find this page by the word "Gemlocal" and stay trouble-free!

Cheers!
-------

Feedback of any kind is highly appreciated.

&mdash; Alex Fortuna, &copy; 2015
