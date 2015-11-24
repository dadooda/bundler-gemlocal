
#
# bundler-gemlocal
#
# See https:/github.com/dadooda/bundler-gemlocal for details.
#

# Search for '# CONFIG' if you want to configure/customize this script.

# A Gemlocal-aware alias to `bundle`.
# CONFIG: You can rename this.
b() {
  # The filename for a Gemlocal.
  # CONFIG: You can rename this.
  local C_GEMLOCAL="Gemlocal"

  # If `BUNDLE_GEMFILE` is set, just run Bundler.
  if [ -n "$BUNDLE_GEMFILE" ]; then
    bundle "$@"
    return $?
  fi

  # Search for a Gemlocal up the tree.
  local D="$PWD"
  while [ -n "$D" ]; do
    if [ -e "$D/$C_GEMLOCAL" ]; then
      local FOUND_GEMLOCAL="$D/$C_GEMLOCAL"
      break;
    fi

    if [ -e "$D/Gemfile" ]; then
      # Do nothing, just stop searching.
      break;
    fi

    D=${D%/*}
  done

  # NOTE: This is the final command which sets the shell return result.
  if [ -n "$FOUND_GEMLOCAL" ]; then
    # Is it an install request?
    # NOTE: Bundler supports abbreviated commands. Match a few here.
    if [ "$1" = "" -o "$1" == "ins" -o "$1" == "inst" -o "$1" == "install" ]; then
      # Run Bundler for both Gemlocal and Gemfile.
      BUNDLE_GEMFILE="$FOUND_GEMLOCAL" bundle "$@" && bundle "$@"
    else
      # Run Bundler for Gemlocal only.
      BUNDLE_GEMFILE="$FOUND_GEMLOCAL" bundle "$@"
    fi
  else
    # No Gemlocal, just run Bundler.
    bundle "$@"
  fi
}

# A Gemlocal-aware alias to `bundle exec`.
# CONFIG: You can rename this.
alias bx="b exec"
