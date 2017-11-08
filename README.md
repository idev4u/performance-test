# performance-test

A description of this package.

Endpoint Call
```
curl -iv -X POST http://localhost:8080/test2 -H "Content-Type: application/json" -d '{"name":"hello" }'
```

complete example
```
bash$ echo `curl -X POST http://localhost:8080/test -H "Content-Type: application/json" -d '{"name":"hello" }' `
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100    28  100    11  100    17   1981   3063 --:--:-- --:--:-- --:--:--  3400
Hello hello
```

wrk -t2 -c40 -d30s http://localhost:8080/test2 -s post.lua

## Local Laptop
### GO vs. Swift
swift kitura 1.7.9
```
bash$ wrk -t20 -c400 -d30s http://localhost:8080/test2 -s post.lua
Running 30s test @ http://localhost:8080/test2
  20 threads and 400 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency    66.03ms  171.31ms   1.47s    96.13%
    Req/Sec   574.78     79.81     1.02k    81.88%
  329332 requests in 30.07s, 41.14MB read
  Socket errors: connect 0, read 324, write 0, timeout 0
Requests/sec:  10951.71
Transfer/sec:      1.37MB
```

release compile

```
bash$ swift build -c release -Xswiftc -static-stdlib
```
run kitura 1.7.9
```
bash$  wrk -t20 -c400 -d30s http://localhost:8080/test2 -s post.lua
Running 30s test @ http://localhost:8080/test2
  20 threads and 400 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency    27.62ms   53.91ms 661.40ms   97.53%
    Req/Sec     0.95k   202.17     2.17k    87.93%
  559486 requests in 30.09s, 69.90MB read
  Socket errors: connect 0, read 324, write 0, timeout 0
Requests/sec:  18592.11
Transfer/sec:      2.32MB
```
go handles 40,84% more requests then kitura 1.7.9
this could be solved with 4 instance double ca 1118972

run kitura 2.0
```
normansmacbook:performance-test norman$ wrk -t20 -c400 -d30s http://localhost:8080/test2 -s post.lua
Running 30s test @ http://localhost:8080/test2
  20 threads and 400 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency    19.09ms    4.05ms  84.64ms   91.12%
    Req/Sec     1.04k   134.69     1.97k    84.20%
  619142 requests in 30.04s, 83.85MB read
  Socket errors: connect 0, read 310, write 0, timeout 0
Requests/sec:  20610.31
Transfer/sec:      2.79MB
```
go handles 34,47% more requests then kitura 2.0.0

golang standard single thread
```
performance-test/compare/performance-test-go bash$ wrk -t20 -c400 -d30s http://localhost:8082/test2 -s post.lua
Running 30s test @ http://localhost:8082/test2
  20 threads and 400 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency    12.67ms    5.11ms 167.65ms   91.85%
    Req/Sec     1.58k   230.28     2.73k    79.68%
  945649 requests in 30.07s, 116.34MB read
  Socket errors: connect 0, read 252, write 0, timeout 0
Requests/sec:  31451.52
Transfer/sec:      3.87MB
```

and finally ruby sinatra
```
bash$ wrk -t20 -c400 -d30s http://localhost:4567/test2 -s post.lua
Running 30s test @ http://localhost:4567/test2
  20 threads and 400 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency     5.71ms    7.19ms 391.74ms   99.07%
    Req/Sec     0.96k   530.44     1.75k    34.65%
  84739 requests in 30.09s, 13.90MB read
  Socket errors: connect 0, read 257, write 0, timeout 0
Requests/sec:   2815.96
Transfer/sec:    472.99KB
```
go handles 91,04% more requests


## Perfomance on Cloud Foundry

### before
at first push the 2 performance-test apps.
** // swift app
```
cf push performance-test -m 32M -i 3
```

** // go app
```
(cd compare/performance-test-go; cf push performance-test-go -m 256M )
```

### go performance test
```
bash$ wrk -t20 -c400 -d30s https://performance-test-go.eu-de.mybluemix.net/test2 -s post.lua
```
```
Running 30s test @ https://performance-test-go.eu-de.mybluemix.net/test2
  20 threads and 400 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency   194.99ms  161.73ms   1.95s    86.53%
    Req/Sec   117.55     56.19   390.00     70.13%
  68570 requests in 30.09s, 15.62MB read
  Socket errors: connect 0, read 0, write 0, timeout 2
Requests/sec:   2278.76
Transfer/sec:    531.58KB
```

### swift performance test

kitura 2 with 5 instances and 160 Mb RAM
```
bash$ wrk -t20 -c400 -d30s https://performance-test.eu-de.mybluemix.net/test2 -s post.lua
```

```
Running 30s test @ https://performance-test.eu-de.mybluemix.net/test2
  20 threads and 400 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency   110.86ms  159.47ms   1.94s    92.08%
    Req/Sec   259.21     89.28   474.00     64.71%
  153092 requests in 30.10s, 29.46MB read
  Socket errors: connect 0, read 0, write 0, timeout 7
Requests/sec:   5085.52
Transfer/sec:      0.98MB
```

with 1 instances and 32Mb RAM
```
Running 30s test @ https://performance-test.eu-de.mybluemix.net/test2
  20 threads and 400 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency   332.26ms  151.53ms   1.69s    75.01%
    Req/Sec    61.05     28.01   171.00     64.40%
  36054 requests in 30.09s, 6.94MB read
Requests/sec:   1198.18
Transfer/sec:    236.31KB
```

with 3 instances and 96Mb RAM
```
name                  requested state   instances   memory   disk   urls
performance-test      started           3/3         32M      1G     performance-test.eu-de.mybluemix.net
performance-test-go   started           1/1         256M     1G     performance-test-go.eu-de.mybluemix.net
performance-test bash$ wrk -t20 -c400 -d30s https://performance-test.eu-de.mybluemix.net/test2 -s post.lua
Running 30s test @ https://performance-test.eu-de.mybluemix.net/test2
  20 threads and 400 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency   169.63ms  184.55ms   1.74s    87.33%
    Req/Sec   158.22     71.64   420.00     66.62%
  92411 requests in 30.10s, 17.79MB read
Requests/sec:   3070.44
Transfer/sec:    605.41KB
``
