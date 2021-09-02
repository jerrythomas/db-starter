-- cleanup staging tables before upload
create or replace function staging.cleanup()
returns void
language plpgsql
as
$$
begin
  truncate table staging.sample;
end;
$$;
