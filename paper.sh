#!/bin/bash
clear

#Take name of server
read -p "Enter server folder name: " servername
read -p "Enter amount of RAM (MB>500) to assign to your server: " ram
read -p "Enter server port: " port

#Check if directory with that name exists
if [[ -d  projects/minecraft/$servername ]]; then
    echo "[ERROR] server with that name already exists"
    echo "[ERROR] aborting script, choose a different name"
    exit

else

    #Create directory and enter if doesn't exist
    echo "Creating server directory..."
    mkdir projects/minecraft/$servername
    echo "Server directory created..."
    cd projects/minecraft/$servername
    echo "Going into server directory..."
    
    #Download server and rename to "server.jar"
    echo "Downloading minecraft server..."
    wget https://papermc.io/api/v2/projects/paper/versions/1.18.1/builds/145/downloads/paper-1.18.1-145.jar
    mv paper-1.18.1-145.jar server.jar

    #Create ./start.sh file
    cat <<END >./start.sh
#start file generated by bash script
screen -S $servername java -Xmx$ram -Xms$ram -jar server.jar
END
    echo "Startup script created..."

    #Ask for permission to execute chmod +x
    read -p "The script requires execution permission, would you like to let it make changes? (y/n): " scriptyn
    if [ $scriptyn == "y" ]; then
        chmod +x ./start.sh
        echo "File ./start.sh has been given chmod +x permission..."
    else
        echo "[ERROR] File ./start.sh cannot launch because it does not have the chmod +x permission"
        exit
    fi

    #Create EULA and ask if accepted
    echo "Creating EULA.TXT file..."
    read -p "Do you agree to the Mojang EULA? (y/n): " eulayn
    
    if [ $eulayn == "y" ]; then
        cat <<END >eula.txt
#By changing the setting below to TRUE you are indicating your agreement to our EULA (https://account.mojang.com/documents/minecraft_eula).
#You also agree that tacos are tasty, and the best food in the world.
#Mon Jan 10 03:18:07 UTC 2022
eula=true
END
       echo "Eula has been set to true..."
    else
        echo "[ERROR] You cannot create a server if you don't accept the EULA"
    fi

    #Set server port by creating server.properties file before starting the server
    echo "Setting server port to $port"
    
    cat <<END >server.properties
#Minecraft server properties
#Mon Jan 10 16:07:26 UTC 2022
enable-jmx-monitoring=false
rcon.port=25575
gamemode=survival
enable-command-block=false
enable-query=false
level-name=world
motd=A Minecraft Server
query.port=25565
pvp=true
difficulty=easy
network-compression-threshold=256
require-resource-pack=false
max-tick-time=60000
use-native-transport=true
max-players=20
online-mode=true
enable-status=true
allow-flight=false
broadcast-rcon-to-ops=true
view-distance=10
server-ip=
resource-pack-prompt=
allow-nether=true
server-port=$port
enable-rcon=false
sync-chunk-writes=true
op-permission-level=4
prevent-proxy-connections=false
hide-online-players=false
resource-pack=
entity-broadcast-range-percentage=100
simulation-distance=10
rcon.password=
player-idle-timeout=0
debug=false
force-gamemode=false
rate-limit=0
hardcore=false
white-list=false
broadcast-console-to-ops=true
spawn-npcs=true
spawn-animals=true
function-permission-level=2
text-filtering-config=
spawn-monsters=true
enforce-whitelist=false
resource-pack-sha1=
spawn-protection=16
max-world-size=29999984
END
    echo "Server port has been set to $port..."

    #Launch server
    echo "Starting Minecraft server on $servername screen..."
    ./start.sh
fi
