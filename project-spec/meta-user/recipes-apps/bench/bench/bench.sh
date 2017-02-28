#!/bin/sh
start ()
{
	echo " Start Hello PetaLinux."
	modprobe xilinx_dma
	touch /home/root/me
}

stop ()
{
	echo " Stop Hello PetaLinux."
	modprobe -r malaperda
	modprobe -r xilinx_dma
}

restart()
{
	stop
	start
}

case "$1" in
	start)
		start; ;;
	stop)
		stop; ;;
	restart)
		restart; ;;
	*)
		echo "Usage: $0 {start|stop|restart}"
		exit 1
esac

exit $?

