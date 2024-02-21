current_value=$(cat /proc/sys/net/core/skb_zeroing)

if [ $current_value == '1' ]
then
    sysctl net.core.skb_zeroing=0
else
    sysctl net.core.skb_zeroing=1
fi
