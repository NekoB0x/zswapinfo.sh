#!/bin/bash

if [[ $(id -u) -ne 0 ]] ; then echo "Please run as root" ; exit 1 ; fi

stored_pages=$(cat /sys/kernel/debug/zswap/stored_pages)
pool_size=$(cat /sys/kernel/debug/zswap/pool_total_size)

printf "ZSWAP Info\n--------------\n"
printf "Stored pages: $stored_pages\n"
printf "Pool size (compressed): %.2f MiB (%.2f MiB)\n" $(echo "$stored_pages*4096/1048576" | bc -l) $(echo "$pool_size/1048576" | bc -l)
[[ $pool_size -ne 0 ]] && printf "Compression ratio: %.2f \n" $(echo "$stored_pages*4096/$pool_size" | bc -l)
printf "System swap usage: %s\n" $(free -h | grep -i 'Swap:' | awk '{print $(NF-1)}')
echo "--------------"
printf "Written back pages: %s\n" $(cat /sys/kernel/debug/zswap/written_back_pages)
printf "Pool limit hit: %s\n" $(cat /sys/kernel/debug/zswap/pool_limit_hit)
printf "Reject compress poor: %s\n" $(cat /sys/kernel/debug/zswap/reject_compress_poor)
printf "Reject kmemcache fail: %s\n" $(cat /sys/kernel/debug/zswap/reject_kmemcache_fail)
printf "Reject alloc fail: %s\n" $(cat /sys/kernel/debug/zswap/reject_alloc_fail)
printf "Reject reclaim fail: %s\n" $(cat /sys/kernel/debug/zswap/reject_reclaim_fail)
