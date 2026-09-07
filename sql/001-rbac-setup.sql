-- ================================================================
-- RBAC 初始化脚本（Supabase Postgres）
-- 作用：建 profiles 表 + 注册自动建 profile + RLS + admin 提升
-- 跑一次即可，幂等安全（重复跑会报已存在，不会破坏数据）
-- ================================================================

-- 1. profiles 表：和 auth.users 一一对应
create table if not exists public.profiles (
  id          uuid references auth.users on delete cascade primary key,
  username    text unique,
  avatar_url  text,
  role        text not null default 'user'
                check (role in ('user', 'admin')),
  created_at  timestamptz not null default now(),
  updated_at  timestamptz not null default now()
);

-- 2. 注册时自动插入 profile（触发器）
create or replace function public.handle_new_user()
returns trigger language plpgsql security definer set search_path = ''
as $$
begin
  insert into public.profiles (id, username, avatar_url)
  values (
    new.id,
    coalesce(new.raw_user_meta_data ->> 'user_name',
             new.raw_user_meta_data ->> 'full_name',
             split_part(new.email, '@', 1)),
    new.raw_user_meta_data ->> 'avatar_url'
  )
  on conflict (id) do nothing;
  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();

-- 3. updated_at 自动更新
create or replace function public.set_updated_at()
returns trigger language plpgsql as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

drop trigger if exists set_profiles_updated_at on public.profiles;
create trigger set_profiles_updated_at
  before update on public.profiles
  for each row execute procedure public.set_updated_at();

-- 4. 启用 RLS
alter table public.profiles enable row level security;
alter table public.profiles force row level security;

-- 5. RLS 策略：
--    - 任何已登录用户都能读所有人（列表、查管理员）
--    - 用户只能改自己
--    - 删除只允许 admin
drop policy if exists "profiles: read all authenticated" on public.profiles;
drop policy if exists "profiles: update self" on public.profiles;
drop policy if exists "profiles: admin delete" on public.profiles;

create policy "profiles: read all authenticated"
  on public.profiles for select to authenticated
  using (true);

create policy "profiles: update self"
  on public.profiles for update to authenticated
  using (auth.uid() = id)
  with check (
    -- 不能自己把自己的 role 改成 admin（防越权）
    auth.uid() = id
    and (select role from public.profiles where id = auth.uid()) = role
  );

create policy "profiles: admin delete"
  on public.profiles for delete to authenticated
  using (exists (select 1 from public.profiles where id = auth.uid() and role = 'admin'));

-- 6. 辅助函数：判断当前用户是否 admin（其他表 RLS 里复用）
create or replace function public.is_admin()
returns boolean language sql stable security definer set search_path = ''
as $$
  select exists (
    select 1 from public.profiles
    where id = (select auth.uid()) and role = 'admin'
  );
$$;

-- 7. admin 提升函数（只能由现有 admin 调用）
create or replace function public.promote_to_admin(target_id uuid)
returns void language plpgsql security definer set search_path = ''
as $$
begin
  if not exists (select 1 from public.profiles where id = auth.uid() and role = 'admin') then
    raise exception 'not an admin';
  end if;
  update public.profiles set role = 'admin' where id = target_id;
end;
$$;

-- 8. Bootstrap：首个管理员（⚠️ 跑完上面 7 步后，单独跑下面这条）
--    把 '你的邮箱' 替换成你注册用的邮箱，例如 '1291397693@qq.com'
--    此函数只能被 service_role 调用，普通 anon/authenticated 无法执行
create or replace function public.bootstrap_first_admin(user_email text)
returns void language plpgsql security definer set search_path = ''
as $$
begin
  update public.profiles
  set role = 'admin'
  where id = (select id from auth.users where email = user_email limit 1);
end;
$$;

-- 防止 authenticated/anon 调用 bootstrap_first_admin
revoke execute on function public.bootstrap_first_admin(text) from public, authenticated;
grant execute on function public.bootstrap_first_admin(text) to service_role;

-- ================================================================
-- 跑完请验证：
--   select * from public.profiles;        -- 空表（还没注册）
--   select current_setting('request.jwt.claims', true); -- 看当前 jwt
-- ================================================================
