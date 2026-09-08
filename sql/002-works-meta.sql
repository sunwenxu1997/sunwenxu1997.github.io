-- ================================================================
-- works_meta：把 settings.js 里 externalRoutes 的 meta 数据迁到 DB
-- 代码（Vue 组件）仍然留在仓库，DB 只存「运营态」字段
-- ================================================================

-- 1. 建表
create table if not exists public.works_meta (
  id          uuid default gen_random_uuid() primary key,
  slug        text unique not null,            -- 路由标识，如 '/anime/anime-跟随小爱心'
  name        text not null,                   -- 显示标题
  cover_url   text,                            -- 封面图 URL（后续可迁到 Supabase Storage）
  info_html   text,                            -- 富文本介绍（HTML）
  code_url    text,                            -- GitHub 代码地址
  link_url    text,                            -- 文章/外部链接
  codepen_url text,                            -- CodePen 地址
  open_url    text,                            -- 直接打开的地址（外部 demo 等）
  date        date,                            -- 发布日期
  sort_weight int not null default 0,          -- 排序权重，越大越靠前
  is_published boolean not null default true,  -- 是否发布
  tags        text[] default '{}',             -- 分类标签，如 '{css,gsap,anime}'
  created_at  timestamptz not null default now(),
  updated_at  timestamptz not null default now()
);

-- 2. updated_at 自动更新
drop trigger if exists set_works_meta_updated_at on public.works_meta;
create trigger set_works_meta_updated_at
  before update on public.works_meta
  for each row execute procedure public.set_updated_at();

-- 3. 启用 RLS
alter table public.works_meta enable row level security;
alter table public.works_meta force row level security;

-- 4. RLS 策略
drop policy if exists "works_meta: anon read published" on public.works_meta;
drop policy if exists "works_meta: auth read all"      on public.works_meta;
drop policy if exists "works_meta: admin write"        on public.works_meta;
drop policy if exists "works_meta: admin update"       on public.works_meta;
drop policy if exists "works_meta: admin delete"       on public.works_meta;

-- 匿名只能读已发布
create policy "works_meta: anon read published"
  on public.works_meta for select to anon
  using (is_published = true);

-- 登录用户（含 admin）能读所有行（方便后台管理列表）
create policy "works_meta: auth read all"
  on public.works_meta for select to authenticated
  using (true);

-- admin 才能增/改/删
create policy "works_meta: admin write"
  on public.works_meta for insert to authenticated
  with check (public.is_admin());

create policy "works_meta: admin update"
  on public.works_meta for update to authenticated
  using (public.is_admin())
  with check (public.is_admin());

create policy "works_meta: admin delete"
  on public.works_meta for delete to authenticated
  using (public.is_admin());

-- 5. 索引：常用查询优化
create index if not exists idx_works_meta_sort
  on public.works_meta (sort_weight desc, date desc nulls last, created_at desc);
create index if not exists idx_works_meta_slug
  on public.works_meta (slug) where is_published = true;

-- 6. 验证 RLS 已启用
select relname, relrowsecurity, relforcerowsecurity
from pg_class
where relname = 'works_meta';
