set search_path to config, public;

create table if not exists lookup (
  id                uuid primary key default uuid_generate_v4()
, name              varchar(30)
, modified_on       timestamp not null default now()
, modified_by       uuid
);

comment on table lookup IS 'Generic lookup table for various lookups.';

create table if not exists lookup_value (
  id                uuid primary key default uuid_generate_v4()
, name              varchar(30)
, lookup_id         uuid references lookup(id)
, modified_on       timestamp not null default now()
, modified_by       uuid
);

comment on table lookup_value IS 'Different values associated with the lookup.';

set search_path to staging, public;

create table if not exists sample(
  id                uuid primary key default uuid_generate_v4()
, name              varchar(30)
, modified_on       timestamp not null default now()
, modified_by       uuid
)