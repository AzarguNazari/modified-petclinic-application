- For benchmarking, we used the [SYSSTAT](http://sebastien.godard.pagesperso-orange.fr/)
- The exported data from the benchmark was done within 5 minutes (300 seconds). 

- Command to get the CPU utlization
```shell
CPU
iostat 1 300 > cpu.txt
```
- Command to get the RAM utilization 
```shell
 sar -r 1 300 -o JSON > memory.txt
```
