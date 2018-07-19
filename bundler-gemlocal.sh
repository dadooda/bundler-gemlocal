
#
# bundler-gemlocal
#
# See https:/github.com/dadooda/bundler-gemlocal for details.
#

# Customizable points are marked '# CONFIG'.

# Gemlocal-aware alias to `bundle`.
# CONFIG: You can rename this.
b()
{
  # Save `set` state. `eval "$SS"` restores it to original.
  local SS=`shopt -op xtrace`; set +x; local RES

  # The filename for a Gemlocal.
  # CONFIG: You can rename this.
  local C_GEMLOCAL="Gemlocal"

  # If `BUNDLE_GEMFILE` is set, just run Bundler.
  if [ -n "$BUNDLE_GEMFILE" ]; then
    bundle "$@"; RES=$?
    eval "$SS"
    return $RES
  fi

  # Search for a Gemlocal and/or a Gemfile up the tree.
  local D="$PWD"
  while [ -n "$D" ]; do
    if [ -e "$D/$C_GEMLOCAL" ]; then
      local FOUND_GEMLOCAL="$D/$C_GEMLOCAL"
    fi

    if [ -e "$D/Gemfile" ]; then
      local FOUND_GEMFILE="$D/Gemfile"
    fi

    [ -n "$FOUND_GEMLOCAL$FOUND_GEMFILE" ] && break

    D=${D%/*}
  done

  if [ -n "$FOUND_GEMLOCAL" -a -z "$FOUND_GEMFILE" ]; then
    echo "Error: No 'Gemfile' found next to '$FOUND_GEMLOCAL'" >&2
    eval "$SS"
    return 1
  fi

  # NOTE: This is the final command which sets the shell return result.
  if [ -n "$FOUND_GEMLOCAL" ]; then
    # Is it an install request?
    # NOTE: Bundler supports abbreviated commands. Match a few here.
    if [ "$1" = "" -o "$1" == "ins" -o "$1" == "inst" -o "$1" == "install" ]; then
      # Run Bundler for Gemfile, then for Gemlocal.
      bundle "$@" && {
        # Create initial `Gemlocal.lock`.
        if [ ! -e "${FOUND_GEMLOCAL}.lock" ]; then
          cp -f "${FOUND_GEMFILE}.lock" "${FOUND_GEMLOCAL}.lock"
        fi

        BUNDLE_GEMFILE="$FOUND_GEMLOCAL" bundle "$@"
      }
    else
      # Run Bundler for Gemlocal only.
      BUNDLE_GEMFILE="$FOUND_GEMLOCAL" bundle "$@"
    fi
  else
    # No Gemlocal, just run Bundler.
    bundle "$@"
  fi

  RES=$?; eval "$SS"; return $RES
}

# Gemlocal-aware alias to `bundle exec`.
# CONFIG: You can rename this.
bx()
{
  local SS=`shopt -op xtrace`; set +x; local RES

  b exec "$@"; RES=$?

  eval "$SS"; return $RES
}

# Export commands to subshells and scripts. Bash-specific.
export -f b bx
