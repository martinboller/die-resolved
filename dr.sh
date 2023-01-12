#! /bin/bash

#############################################################################
#                                                                           #
# Author:       Martin Boller                                               #
#                                                                           #
# Email:        martin                                                      #
# Last Update:  2023-01-12                                                  #
# Version:      1.00                                                        #
#                                                                           #
# Changes:      Initial Version (1.00)                                      #
#                                                                           #
# Instruction:  run this and I'll nuke systemd-resolved                     #
#                                                                           #
#                                                                           #
#############################################################################


die-resolved() {
    echo -e "\e[1;32m--------------------------------------------\e[0m";
    echo -e "\e[1;32m - Stopping and disabling systemd-resolved\e[0m";
    sudo systemctl stop systemd-resolved.service
    sudo systemctl disable systemd-resolved.service
    echo -e "\e[1;32m - remove resolved stub resolver entry from resolv.conf\e[0m";
    sudo resolvconf -d systemd-resolved
    echo -e "\e[1;32m - enable dhclient\e[0m";    
    sudo chmod +x /etc/dhcp/dhclient-enter-hooks.d/resolvconf
    echo -e "\e[1;32m - Likely not needed, but let's really nuke old resolv.conf\e[0m";
    sudo rm /etc/resolv.conf
    echo -e "\e[1;32m - Then soft link\e[0m";
    sudo ln -s /run/resolvconf/resolv.conf /etc/resolv.conf
    echo -e "\e[1;32m - run dhclient\e[0m";
    sudo dhclient;
    ping google.com.
}


##################################################################################################################
## Main                                                                                                          #
##################################################################################################################

main() {
    die-resolved;
}

main;

exit 0;
