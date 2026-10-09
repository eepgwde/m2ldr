d_echo () {
  echo $DEF0
}

d_demo () {
  echo my-log-message >& 7
}

e_sort () {
  sort -k1,2h
}

d_sort-test () {
  local tfile
  local tfile1
  e_tpush1 tfile
  e_tpush1 tfile1

  echo {1..20} | xargs -n1 | tac > $tfile
  echo {1..20} | xargs -n1 > $tfile1
  if [ -n "$VERBOSE" ]
  then
    echo -- source
    paste $tfile $tfile1
    echo -- results
  fi
  paste $tfile $tfile1 | e_sort
}

h_ls1 () {
  cat >&2 <<EOF

  $prog [options] ${FUNCNAME#h_} <command> [parameters]

The function is numerically versioned at "1", because there are other functions:
"ls" and "ls0". The function "m_ ls" has been loaded and is used as a fall-through.

Provides some listing commands:

  $prog [-d $PWD] ${FUNCNAME#h_} inode-idx

This lists the files in the directory specified with =-d= prefixed by their inode.

  $prog [-d $PWD] ${FUNCNAME#h_} undot

Given a file listing on the standard input where the files are prefixed by a
=./=, it removes the =./=. For example

  find . -type f | $prog [-d $PWD] ${FUNCNAME#h_} undot

The fall-through is to pass the command to "m_ ls".

EOF

}


d_ls1 () {
  local e_cmd=$1
  shift

  # pre-load a function from another library
  d_resolve1 d_ls m_

  case $e_cmd in
    inode-idx)
      find ${d_dir:-$PWD} -type f -printf "%i %p\n"
      ;;

    undot)
      d_ls undot $*
      ;;
    *)
      d_ls $e_cmd $*
      ;;
  esac
}

d_xoptions () {
  test -n "$d_options" || return 1

  echo "$d_options"
  echo "${d_exec:-}"

  echo this : \"$this\"
}

d_exec0 () {
  : ${d_exec:=cat}

  echo "$d_exec"

  echo {1..5} | xargs -n1 | $d_exec
}

d_evlr0 () {
  test -n "${d_file:-}" || { d_ERRMSG='\"-f file\" option needed'; return 1; }

  local x_vars
  read x_vars < <(cat $d_file | tr '\n' ',' | sed -E -e 's/,$//g')
  echo -- extra vars: $x_vars

  d_evlr x_vars
  set | grep -E '^y_\S+='
}

d_resolve1 f_orchestrate m2_
d_resolve1 e_orchestrate m2_

e_fragments0=""

d_fragments0 () {
  local cmd="${1:-}"

  case $cmd in
  header0)
    e_fragments0="${cmd}-$RANDOM"
    ;;
  body0)
    e_fragments0=" $e_fragments0 ${cmd}-$RANDOM"
    ;;
  footer0)
    e_fragments0=" $e_fragments0 ${cmd}-$RANDOM"
    ;;
  print0)
    echo $e_fragments0
    ;;
  esac

}

d_example1 () {
  e_orchestrate d_fragments0
}


readonly _SNTL='<cmds>'
declare -a _cmds=(_SNTL)

d_fsm1 () {
  # Simple sequence: construct, action, destruct
  # It uses a command stack: _cmds
  # Limits itself to 20 operations

  local cmd0=${1:-work}
  shift

  if (( d_count <= 0 )); then
    d_count=20
  fi

  # Use a command stack - _ctr first, the user command, then _dtr
  e_stk_push0 _cmds "_dtr" _SNTL
  e_stk_push0 _cmds "${cmd0}" _SNTL
  e_stk_push0 _cmds "_ctr" _SNTL

  # Poor Man's Go-To with a loop guard popping the command stack
  local -i loop0=${d_count}

  while (( loop0-- > 0 )); do
    e_stk_show0 _cmds
    e_stk_pop0 _cmds cmd _SNTL || return 1
    echo "# $FUNCNAME:$cmd : loop0 $loop0" >& 7

    case $cmd in
      _ctr)
        hours=8
        wage=10
        earnings=0
        ;;
      _dtr)
        echo hours : $hours : wage : $wage : earnings : $earnings
        break
        ;;

      ## user actions

      work) # make sure we have the necessary directories and files
        earnings=$(( earnings + hours*wage ))
        ;;

      overtime)
        wage=$((2*wage))
        hours=2
        ;;

      hard-work)
        e_stk_push0 _cmds "work" _SNTL
        e_stk_push0 _cmds "overtime" _SNTL
        e_stk_push0 _cmds "work" _SNTL
        ;;

    esac
  done

}

budget=180

d_fsm2 () {
  # Simple sequence: construct, action, destruct
  # It uses a command stack: _cmds
  # Limits itself to 20 operations

  local cmd0=${1:-work}
  shift

  if (( d_count <= 0 )); then
    d_count=20
  fi

  # Use a command stack - _ctr first, the user command, then _dtr
  e_stk_push0 _cmds "_dtr" _SNTL
  e_stk_push0 _cmds "${cmd0}" _SNTL
  e_stk_push0 _cmds "_ctr" _SNTL

  # Poor Man's Go-To with a loop guard popping the command stack
  local -i loop0=${d_count}

  while (( loop0-- > 0 )); do
    e_stk_show0 _cmds
    e_stk_pop0 _cmds cmd _SNTL
    echo "# $FUNCNAME:$cmd : loop0 $loop0"

    case $cmd in
      _ctr)
        hours=8
        wage=10
        earnings=0
        ;;
      _dtr)
        echo hours : $hours : wage : $wage : earnings : $earnings
        break
        ;;

      ## user actions

      work) # make sure we have the necessary directories and files
        earnings=$(( earnings + hours*wage ))
        e_stk_push0 _cmds "hard-work" _SNTL
        if (( earnings > budget))
        then
          e_stk_push0 _cmds "over-budget" _SNTL
        else
          e_stk_push0 _cmds "work" _SNTL
          e_stk_push0 _cmds "overtime" _SNTL
        fi
        ;;

      overtime)
        wage=$((2*wage))
        hours=2
        ;;

      over-budget)
        e_stk_push0 _cmds "_dtr" _SNTL
        ;;

    esac
  done

}

# default: sensor_trigger, limit_open, timer_expired, limit_closed

# re-open-once: sensor_trigger, limit_open, timer_expired, sensor_trigger, limit_open, timer_expired, limit_closed

AGM_SQ0=( sensor_trigger limit_open timer_expired limit_closed )
AGM_SQ1=( sensor_trigger limit_open timer_expired sensor_trigger limit_open timer_expired limit_closed )

d_agm0 () {
  # Automatic Gate Example

  # use a local nameref to access the array
  local -n sq0=${1:-AGM_SQ0}
  shift

  if (( d_count <= 0 )); then
    d_count=20
  fi

  # Use a command stack - _ctr first, the user command sequence, then _dtr
  e_stk_push0 _cmds "_dtr" _SNTL

  local len="${#sq0[@]}"

  # Loop from the last index (len - 1) down to 0
  for (( i=len-1; i>=0; i-- )); do
    e_stk_push0 _cmds "${sq0[i]}" _SNTL
  done

  e_stk_push0 _cmds "_ctr" _SNTL

  # Poor Man's Go-To with a loop guard popping the command stack
  local -i loop0=${d_count}

  # current state and next state
  local CS="NULL"
  local NS="NULL"

  while (( loop0-- > 0 )); do
    e_stk_show0 _cmds
    e_stk_pop0 _cmds cmd _SNTL
    echo "# $FUNCNAME:$cmd : CS : $CS : NS : $NS : loop0 $loop0"

    case $cmd in
      _ctr)
        # powers up into CLOSED state
        CS="CLOSED"
        true
        ;;
      _dtr)
        # powers off into CLOSED state
        CS="CLOSED"
        break
        ;;

      ## user actions

      sensor_trigger)
        [[ $CS == CLOSED ]] || [[ $CS == CLOSING ]] || continue
        NS=OPENING
        echo $cmd : current: $CS : next: $NS : output: motor-open
        CS=$NS
        ;;
      limit_open)
        [[ $CS == OPENING ]] || continue
        NS=OPEN
        echo $cmd : current: $CS : next: $NS : output: motor-off
        CS=$NS
        ;;
      timer_expired)
        [[ $CS == OPEN ]] || continue
        NS=CLOSING
        echo $cmd : current: $CS : next: $NS : output: motor-close
        CS=$NS
        ;;
      limit_closed)
        [[ $CS == CLOSING ]] || continue
        NS=CLOSED
        echo $cmd : current: $CS : next: $NS : output: motor-off
        CS=$NS
        ;;

    esac
  done
}

d_log0 () {
  echo $FUNCNAME standard output >& 1
  echo $FUNCNAME standard error >& 2
  echo $FUNCNAME logger >& 7
}

d_path0 () {
  local -a path0=()
  e_path_parse "${1}" path0
  declare -p path0
}
