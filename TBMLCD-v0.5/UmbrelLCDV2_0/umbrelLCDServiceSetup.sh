#!/bin/bash
#-------------------------------------------------------------------------------
#   Copyright (c) DOIDO Technologies
#   Version  : 1.0.3
#   Location : github
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
# This script is used to create Umbrel lcd service.
# It also enables the user to select screens and currency to be used.
#-------------------------------------------------------------------------------

echo "=================================================================================="
echo "                              SCREEN SELECTION MENU"
echo "=================================================================================="
echo
echo "Available screens to be displayed on the LCD:"
echo "                    Screen 1: Bitcoin price and sats/unit of currency."
echo "                    Screen 2: Next Bitcoin block information."
echo "                    Screen 3: Current Bitcoin block height."
echo "                    Screen 4: Current date and time."
echo "                    Screen 5: Bitcoin network information."
echo "                    Screen 6: Payment channels information."
echo "                    Screen 7: Disk storage information."
echo
echo "Please answer by typing yes or no then press the enter key."
echo

userScreenChoices=""

for i in {1..7}; do
    gettingUserChoice=true
    while $gettingUserChoice; do
        read -p "Would you like screen $i to be displayed on the LCD?  " userAnswer
        userAnswer=${userAnswer^^}
        if [ "$userAnswer" == "YES" ]; then
            echo -e "\e[1;32m Adding screen $i. \e[0m"
            if [ "$i" -eq 7 ]; then
                userScreenChoices="${userScreenChoices}Screen$i"
            else
                userScreenChoices="${userScreenChoices}Screen$i,"
            fi
            gettingUserChoice=false
        elif [ "$userAnswer" == "NO" ]; then
            echo "Not Adding screen $i."
            gettingUserChoice=false
        else
            echo -e "\e[1;31m Your answer is not valid. \e[0m"
        fi
    done
done

echo "User choices: ${userScreenChoices}"
echo

echo "=============================================================================================="
echo "                                      CURRENCY SELECTION"
echo "=============================================================================================="

gettingCurrency=true
while $gettingCurrency; do
    echo
    read -p "Please Enter Currency Code e.g. USD for US Dollar: " newCurrency
    newCurrency=${newCurrency^^}
    echo $newCurrency
    validationResult=$(python3 ./CurrencyData.py ${newCurrency})
    if [ "$validationResult" = "Valid" ]; then
        echo "Creating Umbrel ST7735 LCD Service."
        gettingCurrency=false
        cwd=$(pwd)

        sudo tee /lib/systemd/system/UmbrelST7735LCD.service > /dev/null <<EOF
[Unit]
Description=Umbrel LCD Service
After=multi-user.target

[Service]
Restart=on-failure
RestartSec=30s
Type=idle
ExecStart=/usr/bin/python3 $cwd/UmbrelLCD.py $newCurrency $userScreenChoices

[Install]
WantedBy=multi-user.target
EOF

        sudo chmod 644 /lib/systemd/system/UmbrelST7735LCD.service
        sudo systemctl daemon-reload
        sudo systemctl enable UmbrelST7735LCD.service
        sudo systemctl start UmbrelST7735LCD.service
        echo "Done Creating Umbrel ST7735 LCD Service."
    else
        echo -e "\e[1;31m Entered Currency code is not valid!!! \e[0m"
    fi
done
