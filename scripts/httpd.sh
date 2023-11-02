#!/bin/bash
yum install httpd -y
echo "<h2>Hello JHC </h2>" > /var/www/html/index.html
systemctl enable httpd
systemctl start httpd

