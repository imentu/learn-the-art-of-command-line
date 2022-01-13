#!/bin/bash

# Init option 
Color_off='\033[0m' # Text Reset

# Regular Colors
Black='\033[0;30m'  # Black
Red='\033[0;31m'    # Red
Green='\033[0;32m'  # Green
Yellow='\033[0;33m' # Yellow
Blue='\033[0;34m'   # Blue
Purple='\033[0;35m' # Purple
Cyan='\033[0;36m'   # Cyan
White='\033[0;37m'  # White

# success/info/error/warn 
msg() {
	printf '%b\n' "$1" >&2
}

info() {
	msg "${Blue}[➭]${Color_off} ${1}${2}"
}

warn() {
	msg "${Red}[►]${Color_off} ${1}${2}"
}

error() {
	msg "${Red}[✘]${Color_off} ${1}${2}"
	exit 1
}

success() {
	msg "${Green}[✔]${Color_off} ${1}${2}"
}

changeSourceToTsingHuaTuna() {
	CONTENT=$(cat <<- EOF
		# 默认注释了源码镜像以提高 apt update 速度，如有需要可自行取消注释\n
		deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ focal main restricted universe multiverse\n
		# deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ focal main restricted universe multiverse\n
		deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ focal-updates main restricted universe multiverse\n
		# deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ focal-updates main restricted universe multiverse\n
		deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ focal-backports main restricted universe multiverse\n
		# deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ focal-backports main restricted universe multiverse\n
		deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ focal-security main restricted universe multiverse\n
		# deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ focal-security main restricted universe multiverse\n
		# 预发布软件源，不建议启用\n
		# deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ focal-proposed main restricted universe multiverse\n
		# deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ focal-proposed main restricted universe multiverse\n
		EOF
	)	
	SOURCES_PATH="/etc/apt/sources.list";
	SOURCES_BKP_PATH=$SOURCES_PATH".bkp";
	O_MSG=$MSG;
	MSG="back up $SOURCES_PATH to $SOURCES_BKP_PATH";

	if sudo cp $SOURCES_PATH $SOURCES_BKP_PATH; then
		success "$MSG";
	else
		error "$MSG failed";
	fi
	
	echo -e $CONTENT | sudo tee $SOURCES_PATH > /dev/null;
	sudo apt-get -y update;
	success "apt-get update";
	sudo apt-get -y upgrade;
	success "apt-get upgrade";

	MSG="change source from http to https protocal";
	if sudo sed -i "s/http:/https:/g" $SOURCES_PATH; then
		success "$MSG";
	else
		error "$MSG failed"
	fi

	MSG=$O_MSG;

	sudo apt-get -y update;
	success "apt-get update";
	sudo apt-get -y upgrade;
	success "apt-get upgrade";

	sudo apt-get -y autoremove;
	success "apt-get autoremove";
}

main() {
	MSG="change source to TsingHua Tuna";
	if changeSourceToTsingHuaTuna; then
		success "$MSG";
	else
		warn "$MSG failed"；
	fi
}

main $@;
