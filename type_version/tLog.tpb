create or replace type body tLog as 


constructor function tLog(inPackageName varchar2, inProcName varchar2) return self as result
as
begin
  self.packageName := inPackageName;
  self.procName := inProcName;
  self.procParams := new log_tab_param();
  return;
end tLog;

  

member procedure write(inLogLevel varchar2, inText varchar2, inParamsText varchar2, inCallStack varchar2)
as
  pragma autonomous_transaction;
begin
   
--  insert into log (log_level, user_id, sid, text, params, call_stack)
--    values (inLogLevel, sys_context('userenv', 'client_identifier'),
--            to_number(sys_context('userenv','sid')), 
--            inText, inParamsText, inCallStack);
--            
--  commit;
    null;
end;


member procedure info(inText varchar2)
as
begin
  write(inLogLevel=>'I', inText=>inText, inParamsText=>null, inCallStack=>null);
end;

member procedure error(inText varchar2)
as
begin
  write(inLogLevel=>'E', inText=>inText, inParamsText=>null, inCallStack=>dbms_utility.format_error_stack);
end;


member procedure add_proc_param(inName varchar2, inVal varchar2)  
as
  vParam log_rec_param;
begin
  vParam := new log_rec_param(inName, nvl(inVal, 'null'));
 
  self.procParams.extend;
  self.procParams(self.procParams.last) := vParam;
end;


member procedure add_proc_param(inName varchar2, inVal number)  
as
begin
  add_proc_param(inName => inName, inVal => tochar(inVal));
end;

member function tochar(inVal number) return varchar2
as
begin
  return to_char(inVal);
end;


end;