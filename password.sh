#!/usr/bin/bash

set -Eeuo pipefail
trap cleanup SIGINT SIGTERM ERR EXIT

script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P)

help() {
  cat<<EOF
$(basename "${BASH_SOURCE[0]}") [--help] [--version] [--length n] [--lower n] [--upper n] [--digit n] [--special n] [--chars '$chars']

A very simple and flexible password generator

--length   Password length, maximum 100
--lower    Minimum number of lowercase letters
--upper    Minimum number of uppercase letters
--digit    Minimum number of digits
--special  Minimum number of special characters
--chars    Allowable special characters

--lower, --upper, --digit and --special must specify an integer >= 0 (0 meaning 'not allowed').

Defaults are equivalent to:

$(basename "${BASH_SOURCE[0]}") --length $length --lower $lower --upper $upper --digit $digit --special $special --chars '$chars'
EOF
  exit
}

version() {
  echo password.sh v1.4.1 2024-10-20 JMS
  exit
}

cleanup() {
  trap - SIGINT SIGTERM ERR EXIT
  # script cleanup here
}

err() {
  printf "%s\\n" "${1-}" 1>&2
}

die() {
  err "$1"
  exit "${2-1}"
}

# $valid is set in body, not good programming style but haven't found a good way to deal with chars including ' ', which messes up the parameter parsing
choose_n() {
  cc=""
  #err "valid \"$valid\""
  for ((i=1; i<=$1; i++))
  do
    #c="${valid:RANDOM%${#valid}:1}"
    c="${valid:$(( RANDOM % ${#valid} )):1}"
    cc="$cc$c"
  done
  echo "$cc"
}

defaults() {
  length=12
  lower=1
  upper=1
  digit=1
  special=1
  chars="-_"
}

parse_parameters() {
  while :; do
    case "${1-}" in
    --help)
      defaults
      help
      ;;
    --version)
      version
      ;;
    --length | --lower | --upper | --special | --digit)
      var=${1:2}
      [[ -z "${2-}" ]] && die "$1 not specified"
      # Check it's an integer >= 0
      if [[ $2 =~ ^[0-9]*$ && $2 -ge 0 ]]; then
        eval $var=$2
      else
        die "invalid $1"
      fi
      shift
      ;;
    --chars)
      [[ -z "${2-}" ]] && die "$1 not specified"
      chars="$2"
      shift
      ;;
    -?*) die "Unknown option: $1" ;;
    *) break ;;
    esac
    shift
  done
  return 0
}

shuffle() {
  echo "$(echo "$1" | fold -w1 | shuf | tr -d '\n')"
}

defaults
parse_parameters "$@"

# No specific reason why 100, it seems there should be an upper limit, 100 seems emore than enough
[[ $(($length)) -gt 100 ]] && die "Length must be less than or equal to 100"
[[ $(($lower+$upper+$digit+$special)) -lt 1 ]] && die "At least one character class must be specified"
[[ $(($length)) -lt $(($lower+$upper+$digit+$special)) ]] && die "Length must be greater than or equal to $(($lower+$upper+$digit+$special))"

password=""
all_valid=""

# Omit lower and upper i, L, o
[[ (("$lower" > 0)) ]] && valid="abcdefghjkmnpqrstuvwxyz" && all_valid="${all_valid}${valid}" && password="${password}$(choose_n $lower)"
[[ (("$upper" > 0)) ]] && valid="ABCDEFGHJKMNPQRSTUVWXYZ" && all_valid="${all_valid}${valid}" && password="${password}$(choose_n $upper)"
[[ (("$digit" > 0)) ]] && valid="0123456789" && all_valid="${all_valid}${valid}" && password="${password}$(choose_n $digit)"
[[ (("$special" > 0)) ]] && valid="${chars}" && all_valid="${all_valid}${valid}" && password="${password}$(choose_n $special)"
remaining=$(($length-$lower-$upper-$digit-$special))
[[ (("$remaining" > 0)) ]] && valid=$all_valid && password="${password}$(choose_n $remaining)"

password=$(shuffle "$password")

echo "$password"
echo sdf
