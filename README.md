# performance-test

A description of this package.


Endpoint Call
```
curl -iv -X POST http://localhost:8080/test -H "Content-Type: application/json" -d '{"name":"hello" }'
```

complite example
```
bash$ echo `curl -X POST http://localhost:8080/test -H "Content-Type: application/json" -d '{"name":"hello" }' `
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100    28  100    11  100    17   1981   3063 --:--:-- --:--:-- --:--:--  3400
Hello hello
```

wrk -t2 -c40 -d30s http://localhost:8080/test -s post.lua

### //endpoint with Body parsing
```
bash$ wrk -t40 -c4000 -d30s http://localhost:8080/test2 -s post.lua
Running 30s test @ http://localhost:8080/test2
  40 threads and 4000 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency   290.09ms  162.91ms 624.57ms   58.72%
    Req/Sec   116.85     80.99     1.79k    90.44%
  107254 requests in 30.10s, 13.40MB read
  Socket errors: connect 0, read 2926, write 0, timeout 36
Requests/sec:   3563.44
Transfer/sec:    455.87KB
```

### // endpoint without body parsing
```
bash$ wrk -t40 -c4000 -d30s http://localhost:8080/test -s post.lua
Running 30s test @ http://localhost:8080/test
  40 threads and 4000 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency   273.06ms  148.16ms   1.56s    55.15%
    Req/Sec   112.07     35.73   445.00     72.87%
  95591 requests in 30.09s, 12.58MB read
  Socket errors: connect 0, read 2254, write 0, timeout 17
Requests/sec:   3176.78
Transfer/sec:    428.12KB
```


## GO vs. Swift
swift
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
golang standard single thread
```
bash$ wrk -t20 -c400 -d30s http://localhost:8082/test2 -s post.lua
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
