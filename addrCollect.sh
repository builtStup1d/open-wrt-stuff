while true; do  
    ldd code | awk '/libc.so/ {gsub(/[()]/, "", $NF); print $NF >> "output.txt"}'  
done

