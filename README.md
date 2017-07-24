# logracle



Logracle is a simple logging library for pl/sql.
Hugely inspired by https://github.com/OraOpenSource/Logger

logracle has 2 versions
- 'proc' version - using stored procedures
- 'type version - using oracle type object
  
sample usage of 'proc' version
```sql
procedure bench_proc_1
as
  log_packageName varchar2(100) := 'package_name';
  log_procName varchar2(100) := 'some_proc';
  log_params log_p.tab_param_p;
begin
  log_p.add_proc_param(log_params, 'param1', 'param1');
  log_p.add_proc_param(log_params, 'param1', 222);
  
  log_p.info('start', log_packageName, log_procName, log_params);

  null;

  log_p.info('end', log_packageName, log_procName, log_params);
end;
```

sample usage of 'type' version
```sql
procedure bench_type_1
as
    log tLog;
begin
  log := new tLog('package_name', 'some_proc');
  log.add_proc_param('param1', 'param1');
  log.add_proc_param('param2', 222);

  log.info('start');

  null;

  log.info('end');

end;
```
### Benchmarks

|# of iterations| proc | type |
| ------ | ------ | ------ |
| 1 000 000 | 15s | 39s |


P
| d | c |
| ------ | ------ |
| 20.07.2017 | 397 831 |
| 20.07.2017 | 397 831 |
| 19.07.2017 | 369 496 |
| 21.07.2017 | 195 288 |
| 22.07.2017 |  27 687 |

A
| d | c |
| ------ | ------ |
21.07.2017 | 3 884 990 |
20.07.2017 | 5 288 725 |
19.07.2017 | 4 976 019 |
22.07.2017 |    27 808 |
