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

function require_non_empty {
	if [ -z "$2" ]
	then
		log "$1";
		kill -s TERM $TOP_PID;
	fi
}

function export_home {
	log "Exporting home script directory";
	# begin
	SOURCE_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd );
	export HOME_DIR=`pwd`;
	echo "export DR_HOME=$HOME_DIR #dr--home">>~/.bashrc
	# end
	log "Home script directory exported";
}

function export_engine {
	log "Selecting script execution tool";
	# begin
	read -e -p "Enter name for symlink for dr-go:" -i "python3.5" DR_ENGINE;
	require_non_empty "Script execution tool cannot be empty" DR_ENGINE;
	echo "export DR_ENGINE=$DR_ENGINE #dr--engine">>~/.bashrc
	# end
	log "Script execution tool exported";
}

function install_go {
	log "Installation of GO script";
	# begin
	chmod +x $HOME_DIR/bin/dr-go.sh;
	read -e -p "Enter name for symlink for dr-go:" -i "go" GO_LINK;
	require_non_empty "Symlink name cannot be empty" GO_LINK;
	ln -s $HOME_DIR/bin/deb/dr-go.sh /usr/bin/$GO_LINK-dr;
	echo "alias $GO_LINK=\". $GO_LINK-dr\" #dr--go">>~/.bashrc
	# end
	log "GO script ready";
}

function install_tag {
	log "Installation of TAG script";
	# begin
	chmod +x $HOME_DIR/bin/dr-tag.sh;
	read -e -p "Enter symlink for dr-tag:" -i "tag" TAG_LINK;
	require_non_empty "Symlink name cannot be empty" TAG_LINK;
	ln -s $HOME_DIR/bin/deb/dr-tag.sh /usr/bin/$TAG_LINK-dr;
	echo "alias $TAG_LINK=\". $TAG_LINK-dr\" #dr--tag">>~/.bashrc
	# end
	log "TAG script ready";
}

function install_list {
	log "Installation of LIST script";
	# begin
	chmod +x $HOME_DIR/bin/dr-list.sh;
	read -e -p "Enter symlink for dr-list:" -i "tagl" LIST_LINK;
	require_non_empty "Symlink name cannot be empty" LIST_LINK;
	ln -s $HOME_DIR/bin/deb/dr-list.sh /usr/bin/$LIST_LINK-dr;
	echo "alias $LIST_LINK=\". $LIST_LINK-dr\" #dr--list">>~/.bashrc
	# end
	log "LIST script ready";
}

function pre_installation {
	log "Preparing installation";
	# begin
	export_engine;
	export_home;
	# end
	log "All installation resources are prepared.";
}

function installation {
	log "Installation starting";
	# begin
	install_go;
	install_tag;
	install_list;
	# end
	log "Installation complete";
}

function past_installation {
	log "Post installation configuration";
	# begin
	chmod +x $HOME_DIR/repository;
	cd ~ && . ./.profile;
	# end
	log "Configuration complete";
}

require_sudo;
pre_installation;
installation;
past_installation;
