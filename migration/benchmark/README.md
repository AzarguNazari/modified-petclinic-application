- For benchmarking, we used (https://github.com/netdata/netdata#features)
- We exported the machine's performance and calculated later.


```shell

CPU
iostat 1 300 > cpu.txt && sar -r 1 300 -o JSON > memory.txt
```