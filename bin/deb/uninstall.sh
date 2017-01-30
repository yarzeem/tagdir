#!/bin/bash
# Required to kill process suring validation in inner functions
trap "exit 1" TERM;
export TOP_PID=$$;

function log {
	time=`date +%H:%M:%S`;
    echo "["$time"] $1";
}

function require_sudo {
	if [[ $UID != 0 ]]; then
	    echo "Please run this script with sudo:"
	    echo "sudo $0 $*"
	    kill -s TERM $TOP_PID;
	fi
}

require_sudo;
log "Uninstalling tag-dir..."
GO_LINE=`grep -F "dr--go" ~/.bashrc`
TAG_LINE=`grep -F "dr--tag" ~/.bashrc`
LIST_LINE=`grep -F "dr--list" ~/.bashrc`
GO_LINK=`echo $GO_LINE | sed -E  's/alias (.*)=(.*)/\1/'`;
TAG_LINK=`echo $TAG_LINE  | sed -E  's/alias (.*)=(.*)/\1/'`;
LIST_LINK=`echo $LIST_LINE  | sed -E  's/alias (.*)=(.*)/\1/'`;
log "Deleting symlinks..."
unlink /usr/bin/$GO_LINK-dr;
unlink /usr/bin/$TAG_LINK-dr;
unlink /usr/bin/$LIST_LINK-dr;
log "Clearing .bashrc ..."
sed --in-place '/#dr--home/d' ~/.bashrc;
sed --in-place '/#dr--engine/d' ~/.bashrc;
sed --in-place '/#dr--go/d' ~/.bashrc;
sed --in-place '/#dr--tag/d' ~/.bashrc;
sed --in-place '/#dr--list/d' ~/.bashrc;
cd ~ && . ./.profile;
log "Done. Byebye!"
