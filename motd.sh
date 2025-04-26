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
SYS_LOADS=$(cut -d' ' -f1 /proc/loadavg) # Используем cut вместо awk для простоты
MEMORY_USED=$(free -b | awk '/^Mem:/ {printf "%.2f", $3/$2 * 100.0}')
SWAP_USED=$(free -b | awk '/^Swap:/ {if ($2 > 0) printf "%.2f", $3/$2 * 100.0; else printf "0.00";}') # Проверка деления на ноль
NUM_PROCS=$(ps -e --no-headers | wc -l) # -e --no-headers надежнее чем ps aux | wc -l

# IP-адрес и hostname
IPADDRESS=$(hostname -I | cut -d' ' -f1)
[ -z "$IPADDRESS" ] && IPADDRESS="N/A"

HOSTNAME_FQDN=$(hostname -f)
LSB_RELEASE=$(lsb_release -s -d)
KERNEL_INFO=$(uname -s) # Kernel name
KERNEL_RELEASE=$(uname -r) # Kernel release
KERNEL_ARCH=$(uname -m) # Kernel architecture
CURRENT_USERS=$(who | wc -l) # who надежнее, чем users | wc -w для подсчета сессий
CURRENT_DATE=$(date)

# Создание нового MOTD
MOTD_CONTENT="
${tcDkG}=================================================================${tcRESET}
${tcLtG}Привет тебе этим ${TIME} !${tcRESET}
${tcLtP}  ____    _  _     _____     _____              _______ ${tcRESET}
${tcLtP} |  _ \\  | || |   |  __ \\   / ____|     /\\     |__   __|${tcRESET}
${tcLtP} | |_) | | || |_  | |  | | | |         /  \\       | |   ${tcRESET}
${tcLtP} |  _ <  |__   _| | |  | | | |        / /\\ \\      | |   ${tcRESET}
${tcLtP} | |_) |    | |   | |__| | | |____   / ____ \\     | |   ${tcRESET}
${tcLtP} |____/     |_|   |_____/   \\_____| /_/    \\_\\    |_|   ${tcRESET}
${tcDkG}=================================================================${tcRESET}
${tcLtG} - Hostname      : ${tcW}${HOSTNAME_FQDN}${tcRESET}
${tcLtG} - IP Address    : ${tcW}${IPADDRESS}${tcRESET}
${tcLtG} - Release       : ${tcW}${LSB_RELEASE}${tcRESET}
${tcLtG} - Kernel        : ${tcW}${KERNEL_INFO} ${KERNEL_RELEASE} ${KERNEL_ARCH}${tcRESET}
${tcLtG} - Users         : ${tcW}Currently ${CURRENT_USERS} user(s) logged on${tcRESET}
${tcLtG} - Server Time   : ${tcW}${CURRENT_DATE}${tcRESET}
${tcLtG} - System load   : ${tcW}${SYS_LOADS}${tcRESET} / ${tcW}${NUM_PROCS}${tcRESET} processes running
${tcLtG} - Memory used % : ${tcW}${MEMORY_USED}%${tcRESET}
${tcLtG} - Swap used %   : ${tcW}${SWAP_USED}%${tcRESET}
${tcLtG} - System uptime : ${tcW}${upDays} days ${upHours} hours ${upMins} minutes${tcRESET}
${tcW} Нужно добавить инструкцию ${tcLtGRN}./инструкция.sh${tcRESET}
${tcDkG}=================================================================${tcRESET}
"

# Удаляем права на выполнение у всех файлов в /etc/update-motd.d/
sudo chmod -x /etc/update-motd.d/*

# Записываем в файл MOTD
echo -e "$MOTD_CONTENT" | sudo tee /etc/update-motd.d/01-custom > /dev/null

# Даем права на выполнение для нового MOTD
sudo chmod +x /etc/update-motd.d/01-custom

# Отображаем на экране
echo -e "$MOTD_CONTENT"
