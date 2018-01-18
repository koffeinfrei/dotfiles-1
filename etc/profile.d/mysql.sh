# Check for interactive bash and MySQL
[ -n "$BASH_INTERACTIVE" ] && has mysql || return

function mysql-ps {
  uptime
  mysqladmin -u root status || return 1
  echo

  command="mysql -e 'SHOW FULL PROCESSLIST' -B | sort -k 5"
  if [ -n "$1" ]; then
    eval $command | egrep "$1"
  else
    eval $command | egrep -v "\sSleep\s"
  fi
}

function mysql-kill {
  mysql -u root -e "KILL $1"
}

function mysql-top {
  while true; do
    clear
    mysql-ps
    read -n 1 -t 1
  done
}
