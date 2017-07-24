create or replace package log
as
  type rec_param is record(name varchar2(255), val varchar2(4000));
  type tab_param is table of rec_param index by binary_integer;

  procedure debug();
  procedure info();
  procedure warn();
  procedure error();

end;