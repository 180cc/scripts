#!/bin/bash

while :
 do
    clear
    echo "-------------------------------------"
    echo " Main Menu "
    echo "-------------------------------------"
    echo "[1] SSH Key Authentication"
    echo "[2] Update CentOS "
    echo "[3] Install Docker"
    echo "[4] Install VESTA"
    echo "[5] Reverse Proxy"
    echo "[6] Admin Home Folder Back-Up"
    echo "[7] OPEN-AS on CentOS 6"
    echo "[9] Exit/Stop"
    echo "======================="
    echo -n "Enter your menu choice: "
    read yourch
    case $yourch in
      1) #SSH KEY AUTHENTICATION
	 mkdir ~/.ssh & touch ~/.ssh/authorized_keys && touch ~/.ssh/authorized_keys && 

	 echo -e "Paste Public Key: "
	 read pubkey && 
	 (
	 echo $pubkey) > ~/.ssh/authorized_keys &&

	 (
	 echo "Port 22001"
	 echo "Protocol 2"
	 echo "SyslogFacility AUTHPRIV"
	 echo "#PermitRootLogin yes"
	 echo "PubkeyAuthentication yes"
	 echo "PasswordAuthentication no"
	 echo "ChallengeResponseAuthentication no"
	 echo "GSSAPIAuthentication yes"
	 echo "GSSAPICleanupCredentials yes"
	 echo "UsePAM yes"
	 echo "AcceptEnv LANG LC_CTYPE LC_NUMERIC LC_TIME LC_COLLATE LC_MONETARY LC_MESSAGES"
	 echo "AcceptEnv LC_PAPER LC_NAME LC_ADDRESS LC_TELEPHONE LC_MEASUREMENT"
	 echo "AcceptEnv LC_IDENTIFICATION LC_ALL LANGUAGE"
	 echo "AcceptEnv XMODIFIERS"
	 echo "X11Forwarding yes"
	 echo "Subsystem	sftp	/usr/libexec/openssh/sftp-server") > /etc/ssh/sshd_config && 
	 chmod 700 ~/.ssh && chmod 600 ~/.ssh/authorized_keys && service sshd restart && echo "Key uploaded and sshd_config updated ..."; 
	 echo "Press a key. . ." ; read ;;

      2) #UPGRADE CENTOS SYSTEM
	 yum update -y && yum upgrade -y ; echo "Press a key. . ." ; read ;;

      3) # INSTALL DOCKER

echo "Installing Docker on CentOS 7" ; yum install -y yum-utils && sudo yum-config-manager \ --add-repo \ https://download.docker.com/linux/centos/docker-ce.repo && yum makecache fast -y && yum install docker-ce -y && systemctl start docker && sudo docker run hello-world ; echo "Press a key. . ." ; read ;;

      4) # INSTALL VESTA
	curl -O http://vestacp.com/pub/vst-install.sh && bash vst-install.sh --force ; echo "Press a key. . ." ; read ;;

      5) # NGINX REVERSE PROXY
	 yum update -y && yum install fail2ban epel-release -y && yum install nginx nano -y && 
	 mkdir /etc/nginx/sites-available && mkdir /etc/nginx/sites-enabled && 

	 echo -e "Enter Backend IP and Frontend IP: "
	 read ip1 ip2
	 echo "Here is your input: \"$ip1\" \"$ip2\""
	 echo -e "Writing config file"
	 # NGINX SITES-ENABLED CONF
	 (
	   echo " ## Basic reverse proxy server ##"
	   echo " ## Apache (vm02) backend for www.example.com ##"
	   echo " upstream apachephp  {"
	   echo "       server $ip1:80; #Apache1"
	   echo " }"
	   echo " "
	   echo " ## Start www.example.com ##"
	   echo " server {"
	   echo "     listen       $ip2:80;"
	   echo "     server_name  www.example.com;"
	   echo "  "
	   echo "     root   /usr/share/nginx/html;"
	   echo "     index  index.html index.htm;"
	   echo "  "
	   echo "     ## send request back to apache1 ##"
	   echo "     location / {"
	   echo "      proxy_pass  http://apachephp;"
	   echo "      proxy_next_upstream error timeout invalid_header http_500 http_502 http_503 http_504;"
	   echo "      proxy_redirect off;"
	   echo "      proxy_buffering off;"
	   echo '      proxy_set_header        Host            $host;'
	   echo '      proxy_set_header        X-Real-IP       $remote_addr;'
	   echo '      proxy_set_header        X-Forwarded-For $proxy_add_x_forwarded_for;'
	   echo "    }"
	   echo " }"
	   echo " ###### END example.com  ########" ) > /etc/nginx/sites-available/reverse-proxy.conf && 
	   ln -s /etc/nginx/sites-available/reverse-proxy.conf /etc/nginx/sites-enabled/reverse-proxy.conf && 

	 # NGINX CONF ECHO
	 (
	 echo "# For more information on configuration, see:"
	 echo "#   * Official English Documentation: http://nginx.org/en/docs/"
	 echo "#   * Official Russian Documentation: http://nginx.org/ru/docs/"
	 echo " "
	 echo "user nginx;"
	 echo "worker_processes auto;"
 	 echo "error_log /var/log/nginx/error.log;"
	 echo "pid /var/run/nginx.pid;"
	 echo " "
	 echo "# Load dynamic modules. See /usr/share/nginx/README.dynamic."
	 echo "include /usr/share/nginx/modules/*.conf;"
	 echo " "
	 echo "events {"
	 echo "    worker_connections  1024;"
	 echo "}"
	 echo " "
	 echo " "
	 echo "http {"
	 echo -e "    log_format  main  '\$remote_addr - \$remote_user [\$time_local] \"\$request\" '"
	 echo -e "                      '\$status \$body_bytes_sent \"\$http_referer\" '"
	 echo -e "                      '\"\$http_user_agent\" \"\$http_x_forwarded_for\"';"
	 echo " "
	 echo "    access_log  /var/log/nginx/access.log  main;"
	 echo " "
	 echo "    sendfile            on;"
	 echo "    tcp_nopush          on;"
	 echo "    tcp_nodelay         on;"
	 echo "    keepalive_timeout   65;"
	 echo "    types_hash_max_size 2048;"
	 echo " "
	 echo "    include             /etc/nginx/mime.types;"
	 echo "    default_type        application/octet-stream;"
	 echo " "
	 echo "    # Load modular configuration files from the /etc/nginx/conf.d directory."
	 echo "    # See http://nginx.org/en/docs/ngx_core_module.html#include"
	 echo "    # for more information."
	 echo "    include /etc/nginx/conf.d/*.conf;"
 	 echo "    include /etc/nginx/sites-enabled/*;"
	 echo "}" ) > /etc/nginx/nginx.conf && service nginx configtest && service nginx restart && echo "Reverse proxy installed. . ."; 
	 echo "Press a key. . ." ; read ;;

      6) #ADMIN HOME FOLDER BACKUP
	 HOMEDATE=admin_backup_$(date +%Y%m%d).tar.gz
	 tar -czf $HOMEDATE /home/admin/ ; echo "Press a key. . ." ; read ;;

      7) # INSTALL OPENVPN-AS ON CENTOS 6
	 cd ~ && curl -O http://swupdate.openvpn.org/as/openvpn-as-2.1.4-CentOS6.x86_64.rpm && 
	 rpm -i openvpn-as-2.1.4-CentOS6.x86_64.rpm && passwd openvpn; echo "Press a key. . ." ; read ;;

      9) exit 0 ;;
      *) echo "Opps!!! Wrong choice";
         echo "Press a key. . ." ; read ;;
 esac
done

