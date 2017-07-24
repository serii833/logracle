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