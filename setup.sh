#!/bin/bash
# Color
RED='\033[0;31m'
NC='\033[0m'
GREEN='\033[0;32m'
ORANGE='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
LIGHT='\033[0;37m'
rm -rf .profile
echo -e "${GREEN}Starting the SETUP script..."
echo -e "${GREEN}Installing the setup packages..."
apt-get -y install net-tools &> /root/apt-log.txt
apt-get -y install curl &> /root/apt-log.txt
apt-get -y install neofetch &> /root/apt-log.txt
apt-get -y install mlocate &> /root/apt-log.txt
apt-get -y install ncdu &> /root/apt-log.txt
apt-get -y install vnstat &> /root/apt-log.txt
echo -e "${GREEN}Configuring profile..."
echo "alias ports='netstat -tulpn | grep LISTEN'" >> .profile
echo "neofetch" >> .profile	
echo "deb http://download.webmin.com/download/repository sarge contrib" >> /etc/apt/sources.list
wget -q -O- http://www.webmin.com/jcameron-key.asc | sudo apt-key add
apt update &> /root/apt-log.txt
apt-get -y install webmin &> /root/apt-log.txt
sed -i "s/ssl=1/ssl=0/g" /etc/webmin/miniserv.conf
service webmin restart
service vnstat restart
apt-get upgrade -y &> /root/apt-log.txt
clear
source .profile
# Installing xray
apt-get -y install socat &> /root/apt-log.txt
apt-get -y install ca-certificates &> /root/apt-log.txt
echo -e "\e[1;33m
░█▀▀▀█ ░█▀▀█ ░█▀▀█ ▀█▀ ░█▀▀█ ▀▀█▀▀ 　 ░█▀▀█ ░█──░█ 　 ░█▀▀▀ ▀█▀ ░█▀▀█ ─█▀▀█ ▀█▀ 
─▀▀▀▄▄ ░█─── ░█▄▄▀ ░█─ ░█▄▄█ ─░█── 　 ░█▀▀▄ ░█▄▄▄█ 　 ░█▀▀▀ ░█─ ░█─░█ ░█▄▄█ ░█─ 
░█▄▄▄█ ░█▄▄█ ░█─░█ ▄█▄ ░█─── ─░█── 　 ░█▄▄█ ──░█── 　 ░█─── ▄█▄ ─▀▀█▄ ░█─░█ ▄█▄\e[0m"
echo ""
echo "" 
echo -e "${GREEN}Enter your domain name(Ex:something.com)?"
echo "Domain name:" 
read domain
clear
wget -O acme.sh https://raw.githubusercontent.com/acmesh-official/acme.sh/master/acme.sh
bash acme.sh --install
rm acme.sh
cd .acme.sh
bash acme.sh --register-account -m kimochilol@gmail.com
bash acme.sh --issue --standalone -d $domain --force
bash acme.sh --installcert -d $domain --fullchainpath /root/xray.crt --keypath /root/xray.key
echo -e "${CYAN}||	SUCCESS !! 	||"
echo -e "${GREEN}Your key path is : /root/xray.key"
echo -e "${GREEN}Your cert path is : /root/xray.crt"
sleep 5
clear
echo -e "${GREEN}Checking for installed X-ray...."
sleep 2
clear
XRAY=/usr/local/etc/xray
if [ -f "$XRAY" ]; then
	echo -e "${LIGHT}!! Xray has been installed !!"
	echo ""
	echo -e "${RED}Uninstalling Xray...."
	sleep 3
	systemctl disable xray
	rm -rf /usr/local/etc/xray
	rm -rf /etc/systemd/system/xray.service
	rm -rf /etc/systemd/system/xray.service.d
	rm -rf /etc/systemd/system/xray@.service
	rm -rf /etc/systemd/system/xray@.service.d
	rm -rf /etc/systemd/system/multi-user.target.wants/xray.service
	rm -rf /etc/systemd/system/xray.service.d/10-donot_touch_single_conf.conf
	rm -rf /etc/systemd/system/xray@.service.d/10-donot_touch_single_conf.conf
	rm -rf /root/xray.crt
	rm -rf /root/xray.key
	rm -rf /usr/local/bin/xray
	rm -rf /usr/local/etc/xray
	rm -rf /usr/local/etc/xray/config.json
	rm -rf usr/local/share/xray
	rm -rf /usr/local/share/xray/geoip.dat
	rm -rf usr/local/share/xray/geosite.dat
	rm -rf /var/log/xray
	rm -rf /var/log/xray/access.log
	rm -rf /var/log/xray/error.log
	clear
	echo -e "${RED}Uninstalled Xray!"

else
	echo -e "${GREEN}Do you want to install Xray"
	echo -e "${GREEN}yes OR no(y/n)?"
	read ans
	if [ $ans == "y" ]; then
		echo -e "${GREEN}Installing Xray.."
		bash -c "$(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" @ install -u root
		rm -rf /usr/local/etc/xray/config.json
		wget https://raw.githubusercontent.com/crixsz/XrayInstaller/main/config.json  -P /usr/local/etc/xray/
    echo '
{ "log": 
	{ "loglevel": "warning"
    },
    "inbounds": [ { "port": 443, "protocol": 
            "trojan", "settings": {
                "clients": [ { 
                        "password":"trojanaku", 
                        "email": 
                        "love@example.com"
                    }
                ]
            },
            "streamSettings": { "network": 
                "tcp", "security": "tls", 
                "tlsSettings": {
                    "alpn": [ "http/1.1" ], 
                    "certificates": [
                        { "certificateFile": 
                            "/root/xray.crt", 
                            "keyFile": 
                            "/root/xray.key"
                        }
                    ]
                }
            }
        },
		{ "port": 8000, "protocol": 
            "trojan", "settings": {
                "clients": [ { 
                        "password":"trojanaku", 
                        "email": 
                        "love@example.com"
                    }
                ]
            },
            "streamSettings": { "network": 
                "gun", "security": "tls", 
                "tlsSettings": {
                    "alpn": [ "http/1.1" ], 
                    "certificates": [
                        { "certificateFile": 
                            "/root/xray.crt", 
                            "keyFile": 
                            "/root/xray.key"
                        }
                    ]
                },
				"grpcSettings": 
				{
                    "serviceName": 
                    "GunService"
                }
            }
        }
    ], "outbounds": [ { "protocol": 
      "freedom", "settings": {}
    },
    { "protocol": "blackhole", "settings": 
      {}, "tag": "blocked"
    }
  ], "routing": { "rules": [ { "type": 
        "field", "ip": [
          "0.0.0.0/8", "10.0.0.0/8", 
          "100.64.0.0/10", "169.254.0.0/16", 
          "172.16.0.0/12", "192.0.0.0/24", 
          "192.0.2.0/24", "192.168.0.0/16", 
          "198.18.0.0/15", "198.51.100.0/24", 
          "203.0.113.0/24", "::1/128", 
          "fc00::/7", "fe80::/10"
        ], "outboundTag": "blocked"
      },
      { "inboundTag": [ "api" ], 
        "outboundTag": "api", "type": "field"
      },
      { "type": "field", "outboundTag": 
        "blocked", "protocol": [
          "bittorrent" ]
      }
    ]
  },
  "stats": {}, "api": { "services": [ 
      "StatsService"
    ], "tag": "api"
  },
  "policy": { "levels": { "0": { 
        "statsUserDownlink": true, 
        "statsUserUplink": true
      }
    },
    "system": { "statsInboundUplink": true, 
      "statsInboundDownlink": true
    }
  }
}
' >> /usr/local/etc/xray/config.json
		systemctl restart xray
		clear
		myip=$(curl -s icanhazip.com);
    		echo " "| tee -a log-install.txt
		echo "============================================================================" | tee -a log-install.txt
		echo "                         INSTALLATION COMPLETED !!!                         " | tee -a log-install.txt
		echo "----------------------------------------------------------------------------" | tee -a log-install.txt
		echo "" | tee -a log-install.txt
		echo "   >>> V2ray Links and Port                                  " | tee -a log-install.txt
		echo "   - TrojanGRPC(8000):                                       " | tee -a log-install.txt
    		echo "" | tee -a log-install.txt
		echo "   trojan://trojanaku@$myip:8000?                       " | tee -a log-install.txt      
    		echo "   mode=gun&security=tls&type=grpc&serviceName=GunService    " | tee -a log-install.txt
    		echo "   &sni=ulist.com.my#TrojanGRPC                              " | tee -a log-install.txt
    		echo "" | tee -a log-install.txt
		echo "   - TrojanTCP(443)  :                                       " | tee -a log-install.txt
	        echo "" | tee -a log-install.txt
	    	echo "   trojan://trojanaku@$myip:443?                        " | tee -a log-install.txt
	    	echo "   security=tls&headerType=none&type=tcp                     " | tee -a log-install.txt          
	    	echo "   &sni=ulist.com.my#TrojanTCP                               " | tee -a log-install.txt
	    	echo "" | tee -a log-install.txt
		echo " THIS LOG FILE IS CREATED IN /root"
	else
		echo -e "${GREEN}Exiting script.."
		sleep 2
		clear
	fi
fi


