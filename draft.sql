create or replace package log
as
  type rec_param is record(name varchar2(255), val varchar2(4000));
  type tab_param is table of rec_param index by binary_integer;

  procedure debug();
  procedure info();
  procedure warn();
  procedure error();

end;




create or replace package body log
as
  


procedure info(inText varchar2, inPackageName varchar2, inProcName varchar2, inParams log.tab_param)

procedure error(inText varchar2)
as
begin
  write(inLogLevel=>'E', inText=>inText, inParamsText=>null, inCallStack=>dbms_utility.format_error_stack);
end;  



procedure write(inLogLevel varchar2, inText varchar2, inParamsText varchar2, inCallStack varchar2)
as
  vUserId number;
  vPageNum number;
  pragma autonomous_transaction;
begin
  
  select sys_context('userenv', 'client_identifier') into vUserId from dual;
  select sys_context('clientcontext', 'log_pageNum') into vPageNum from dual;

  insert into log (time_stamp, log_level, user_id, page_num, text, params, call_stack)
    values systimestamp, inLogLevel, vUserId, vPageNum, inText, inParamsText, inCallStack)
end;


procedure append_param(inParams in out nocopy log.tab_param, inName varchar2, inVal varchar2)  
as
  vParam log.rec_param;
begin
  vParam.name := inName;
  vParam.val := nvl(inVal, 'null');
  inParams(inParams.count + 1) := vParam;
end;


procedure append_param(inParams in out nocopy log.tab_param, inName varchar2, inVal number)  
as
  vParam log.rec_param;
begin
  append_param(inParams => inParams, inName => inName, inVal => tochar(inVal));
end;


function tochar(inVal number) return varchar2
as
begin
  return to_char(inVal);
end;

end;




create table log (
  id number not null,
  time_stamp timestamp not null default timestamp,
  log_level varchar(1 char) not null,

  user_id number not null,
  page_num number not null,

  text varchar2(4000),

  unit_name varchar2(4000),
  params varchar2, --!!! проверить 4-фонд

  program varchar2(4000),
  call_stack varchar2(4000)
)




--------------------------------------------
--------------------------------------------

  
procedure some_proc(param1 number, param2 varchar2)
as
  log_packageName varchar2(100) := 'package_name';
  log_procName varchar2(100) := 'some_proc';
  log_params log.tab_param;
begin

  log.append_param(log_params, 'param1', param1);
  log.append_param(log_params, 'param1', param2);
  log.info('start', log_packageName, log_procName, params);

  some_stuff

  log.info('end', log_packageName, log_procName);
exception when others then
  log.error('', log_packageName, log_procName);
  --https://oracle-base.com/articles/12c/utl-call-stack-12cr1
  --DBMS_UTILITY.format_error_stack
end;



-----------------------------


procedure some_proc(param1 number, param2 varchar2)
as
begin

  log = new tLog('package_name', 'some_proc');
  log.add_proc_param('param1', param1);
  log.add_proc_param('param2', param2);

  log.info('start');

  some_stuff

  log.info('end');

exception when others then
  log.error('some_text');
  --https://oracle-base.com/articles/12c/utl-call-stack-12cr1
  --DBMS_UTILITY.format_error_stack
end;





-- DBMS_SESSION.SET_CONTEXT ( 'CLIENTCONTEXT', 'a', 'b' )
-- SELECT SYS_CONTEXT ('CLIENTCONTEXT', 'a' ) FROM dual;
