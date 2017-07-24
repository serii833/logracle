create or replace type log_rec_param is object(name varchar2(255), val varchar2(4000));
	
create or replace type log_tab_param as table of log_rec_param;