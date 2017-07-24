create or replace type tLog as object (

  packageName varchar2(100),
  procName varchar2(100),

  procParams log_tab_param,
  
  constructor function tLog(inPackageName varchar2, inProcName varchar2) return self as result,
  
  member procedure write(inLogLevel varchar2, inText varchar2, inParamsText varchar2, inCallStack varchar2),
   
  member procedure info(inText varchar2),
  member procedure error(inText varchar2),
    
  member procedure add_proc_param(inName varchar2, inVal varchar2),
  member procedure add_proc_param(inName varchar2, inVal number),

  member function tochar(inVal number) return varchar2
)
