#!/bin/bash

# Удаляем права на выполнение у всех файлов внутри /etc/update-motd.d/
sudo chmod -x /etc/update-motd.d/*

# Создаем файл 01-custom с необходимым содержимым
sudo bash -c 'cat > /etc/update-motd.d/01-custom << "EOF"
#!/bin/bash

# Цвета
tcLtG="\033[00;37m" # LIGHT GRAY
tcDkG="\033[01;30m" # DARK GRAY
tcLtR="\033[01;31m" # LIGHT RED
tcLtGRN="\033[01;32m" # LIGHT GREEN
tcLtBL="\033[01;34m" # LIGHT BLUE
tcLtP="\033[01;35m" # LIGHT PURPLE
tcLtC="\033[01;36m" # LIGHT CYAN
tcW="\033[01;37m" # WHITE
tcRESET="\033[0m"

# Время дня
HOUR=$(date +"%H")
if [ $HOUR -lt 12 -a $HOUR -ge 0 ]; then
    TIME="утром"
elif [ $HOUR -lt 17 -a $HOUR -ge 12 ]; then
    TIME="днем"
else
    TIME="вечером"
fi

# Время работы системы
uptime_secs=$(cut -d. -f1 /proc/uptime)
upDays=$((uptime_secs/60/60/24))
upHours=$((uptime_secs/60/60%24))
upMins=$((uptime_secs/60%60))

# Использование ресурсов
SYS_LOADS=$(cut -d' ' -f1 /proc/loadavg)
MEMORY_USED=$(free -b | awk '/^Mem:/ {printf "%.2f", $3/$2 * 100.0}')
SWAP_USED=$(free -b | awk '/^Swap:/ {if ($2 > 0) printf "%.2f", $3/$2 * 100.0; else printf "0.00";}')
NUM_PROCS=$(ps -e --no-headers | wc -l)

# IP-адрес и hostname
IPADDRESS=$(hostname -I | cut -d' ' -f1)
[ -z "$IPADDRESS" ] && IPADDRESS="N/A"

HOSTNAME_FQDN=$(hostname -f)
LSB_RELEASE=$(lsb_release -s -d)
KERNEL_INFO=$(uname -s)
KERNEL_RELEASE=$(uname -r)
KERNEL_ARCH=$(uname -m)
CURRENT_USERS=$(who | wc -l)
CURRENT_DATE=$(date)

# Вывод динамического MOTD
echo -e "${tcDkG}=================================================================${tcRESET}"
echo -e "${tcLtG}Привет тебе этим ${TIME} !${tcRESET}"
echo -e "${tcLtP}  ____    _  _     _____     _____              _______ ${tcRESET}"
echo -e "${tcLtP} |  _ \\  | || |   |  __ \\   / ____|     /\\     |__   __|${tcRESET}"
echo -e "${tcLtP} | |_) | | || |_  | |  | | | |         /  \\       | |   ${tcRESET}"
echo -e "${tcLtP} |  _ <  |__   _| | |  | | | |        / /\\ \\      | |   ${tcRESET}"
echo -e "${tcLtP} | |_) |    | |   | |__| | | |____   / ____ \\     | |   ${tcRESET}"
echo -e "${tcLtP} |____/     |_|   |_____/   \\_____| /_/    \\_\\    |_|   ${tcRESET}"
echo -e "${tcDkG}=================================================================${tcRESET}"
echo -e "${tcLtG} - Hostname      : ${tcW}${HOSTNAME_FQDN}${tcRESET}"
echo -e "${tcLtG} - IP Address    : ${tcW}${IPADDRESS}${tcRESET}"
echo -e "${tcLtG} - Release       : ${tcW}${LSB_RELEASE}${tcRESET}"
echo -e "${tcLtG} - Kernel        : ${tcW}${KERNEL_INFO} ${KERNEL_RELEASE} ${KERNEL_ARCH}${tcRESET}"
echo -e "${tcLtG} - Users         : ${tcW}Currently ${CURRENT_USERS} user(s) logged on${tcRESET}"
echo -e "${tcLtG} - Server Time   : ${tcW}${CURRENT_DATE}${tcRESET}"
echo -e "${tcLtG} - System load   : ${tcW}${SYS_LOADS}${tcRESET} / ${tcW}${NUM_PROCS}${tcRESET} processes running"
echo -e "${tcLtG} - Memory used % : ${tcW}${MEMORY_USED}%${tcRESET}"
echo -e "${tcLtG} - Swap used %   : ${tcW}${SWAP_USED}%${tcRESET}"
echo -e "${tcLtG} - System uptime : ${tcW}${upDays} days ${upHours} hours ${upMins} minutes${tcRESET}"
echo -e "${tcLtR} USE ./vps_info.sh${tcRESET}"
echo -e "${tcDkG}=================================================================${tcRESET}"
'

# Даем права на исполнение для нового файла
sudo chmod +x /etc/update-motd.d/01-custom
