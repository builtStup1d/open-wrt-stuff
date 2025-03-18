count=0
while true; do  
    if ! ldd code | awk '/libc.so/ {gsub(/[()]/, "", $NF); print $NF}' >> output.txt; then
        echo "Error: No space left on device. Exiting."
        exit 1
    fi
    count=$((count + 1))
    echo "Collected: $count"
done
