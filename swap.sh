#!/bin/bash
# ایجاد فایل سواپ 8 گیگابایتی (با fallocate)
sudo fallocate -l 8G /swapfile
# اگر fallocate در سیستم جواب نداد، از dd استفاده کنید:
# sudo dd if=/dev/zero of=/swapfile bs=1M count=8192
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
# نمایش اطلاعات حافظه
free -h
# اضافه کردن سواپ به fstab (در صورت نبود)
grep -qF '/swapfile none swap sw 0 0' /etc/fstab || echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
# تنظیم swappiness
sudo sysctl vm.swappiness=40
echo 'vm.swappiness=40' | sudo tee -a /etc/sysctl.conf
cat /proc/sys/vm/swappiness
# اضافه کردن کرون‌جاب ریبوت هر 24 ساعت ساعت 3 صبح (در صورت نبود)
(crontab -l 2>/dev/null | grep -Fxq "0 3 * * * /sbin/reboot") || (crontab -l 2>/dev/null; echo "0 3 * * * /sbin/reboot") | crontab -

# ریبوت فوری
sudo reboot
