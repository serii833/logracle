create table log (
  id number not null,
  time_stamp timestamp default systimestamp not null,
  log_level varchar(1 char) not null,

  user_id number not null,
  sid number not null,

  text varchar2(4000),

  unit_name varchar2(4000),
  params varchar2(4000), --!!! проверить 4-фонд

  program varchar2(4000),
  call_stack varchar2(4000)
)