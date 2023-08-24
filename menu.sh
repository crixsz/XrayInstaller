UUID=$(cat /proc/sys/kernel/random/uuid)
clear

echo "========================"
echo "  SIMPLE MENU FOR XRAY "
echo "========================"
echo "1) Create user for VLESS"
echo "2) Show details user created"
echo ""

read choice

addvless()
{
    clear
    
    echo "Enter username for user?:"
    echo ""
    read username

}

showdetails()
{
    clear
    echo "Details of Configs:"
    echo ""

}
if [ "$choice" = "1" ]; then
    addvless
elif [ "$choice" = "2" ]; then
    showdetails
else
    echo "Wrong choice !! Exiting.."
    sleep 3
    clear
fi
