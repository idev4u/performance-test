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