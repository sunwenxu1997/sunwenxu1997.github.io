-- ================================================================
-- 004：works_meta 新增 info_md 列（Markdown 正文）
--
-- 在哪执行：
--   Supabase Dashboard → 左侧 SQL Editor → New query → 整段粘贴 → Run
--   （.env.local 里的是 anon key，role=anon 没有任何 DDL 权限，
--     加列必须用 Dashboard 的 postgres 身份，本地脚本跑不了）
--
-- 幂等：可重复执行，已有列时自动跳过
-- 顺序：先跑本脚本(004)，再跑 005-migrate-info-md.sql 回填 67 条数据
--       顺序反了 005 会直接报 "column info_md does not exist"
-- ================================================================

begin;

-- 1. 加列（已存在则跳过，不会丢数据）
alter table public.works_meta add column if not exists info_md text;

-- 2. 字段注释（Dashboard → Table Editor 悬停可见）
comment on column public.works_meta.info_md
  is 'Markdown 正文，详情页唯一渲染来源（markdown-it，html:false / breaks:true）';
comment on column public.works_meta.info_html
  is '历史 HTML 正文，已废弃；005 回填后前后端均不再读写，仅留作回滚备份';

commit;

-- 3. 让 PostgREST 立即刷新 schema 缓存（避免 REST 接口继续报列不存在）
notify pgrst, 'reload schema';

-- 4. 执行结果自检：期望 col_added=1，info_md_rows=0（还没回填，属正常）
select
  (select count(*) from information_schema.columns
     where table_schema = 'public'
       and table_name = 'works_meta'
       and column_name = 'info_md')                       as col_added,
  (select count(*) from public.works_meta)                as total_rows,
  (select count(*) from public.works_meta
     where info_html is not null)                         as info_html_rows,
  (select count(*) from public.works_meta
     where info_md is not null)                           as info_md_rows;
