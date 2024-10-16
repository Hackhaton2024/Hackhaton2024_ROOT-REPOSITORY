#/usr/bin/bash
# Run APPLICATION
# T.NGUYEN 2024-17-10
#===================================================================================
readonly TITLE='Angular interface'
readonly BIN_PATH='./runAngularInterface.sh'
clear
echo "
  _    _            _         _   _                 ___   ___ ___  _  _   
 | |  | |          | |       | | | |               |__ \ / _ \__ \| || |  
 | |__| | __ _  ___| | ____ _| |_| |__   ___  _ __    ) | | | | ) | || |_ 
 |  __  |/ _\ |/ __| |/ / _\ | __| '_ \ / _ \| '_ \  / /| | | |/ /|__   _|
 | |  | | (_| | (__|   < (_| | |_| | | | (_) | | | |/ /_| |_| / /_   | |  
 |_|  |_|\__,_|\___|_|\_\__,_|\__|_| |_|\___/|_| |_|____|\___/____|  |_|  
                                                                          
 L'EQUIPE DE CHOC
 « Unissons nos forces pour créer des solutions innovantes et durables »                                                                         
==============================================================================
  LANCEMENT DE L'APPLICATION
  By T.NGUYEN
  2024
 ==============================================================================                                 
"
echo -e -n "\033[93m -- Run Angular interface...\033[0m"
gnome-terminal --title="$TITLE" --command "$BIN_PATH"
xdotool windowminimize $(xdotool search --name "$TITLE"|head -1)
echo -e -n "\033[93m -- \033[0m"
echo -e "\033[32mOK\033[0m"

echo -e -n "\033[93m -- Run Springboot REST API...\033[0m"
./runAPI.sh
