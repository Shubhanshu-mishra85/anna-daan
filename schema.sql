-- Anna Daan database (Supabase > SQL Editor me paste karke Run karo)

create table if not exists posts (
  id         bigint generated always as identity primary key,
  place      text        not null check (char_length(place) between 2 and 60),
  type       text        not null check (type in ('veg','nv')),
  plates     int         not null check (plates between 1 and 2000),
  made_at    timestamptz not null,
  phone      text        not null check (phone ~ '^[0-9]{10}$'),
  claimed    boolean     not null default false,
  created_at timestamptz not null default now()
);

-- Index: latest posts jaldi milein
create index if not exists posts_made_at_idx on posts (made_at desc);

-- Row Level Security: har koi padh sakta hai, post kar sakta hai, claim kar sakta hai
alter table posts enable row level security;
drop policy if exists "read"  on posts;
drop policy if exists "add"   on posts;
drop policy if exists "claim" on posts;
create policy "read"  on posts for select using (true);
create policy "add"   on posts for insert with check (true);
create policy "claim" on posts for update using (true) with check (true);
