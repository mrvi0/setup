#!/bin/bash

# Удаляем права на выполнение у всех файлов внутри /etc/update-motd.d/
sudo chmod -x /etc/update-motd.d/*

# Скачиваем файл motd.sh с GitHub
curl -sSL "https://raw.githubusercontent.com/mrvi0/setup/refs/heads/main/f/01-custom" -o /etc/update-motd.d/01-custom

# Даем права на исполнение для нового файла
sudo chmod +x /etc/update-motd.d/01-custom
