-- ================================================================
-- 008：删除 works_meta.slug
-- 背景：本地 demo 路由（src/views/works + src/router/works.js）已下线，
--       slug 不再对应任何可访问页面；详情页路由统一用 id（uuid）。
-- 执行方式：Supabase Dashboard → SQL Editor → Run（drop 列不可逆，执行前先导出备份）
-- 变更说明：数据清理语句（delete）已注释，本脚本只做结构变更，可重复执行
-- 注意：003 系列 seed 脚本是历史记录，drop 列后不要再重跑
-- ================================================================

-- 1. 清理本地 demo 时期的旧记录（slug 不以 /external/ 开头的都是已删组件）
-- ⚠️ 已注释：这条会不可回滚地删除数据，与结构变更分开，按需单独执行。
--    误删的 40 条已经由 sql/009-restore-local-demo-rows.sql 恢复。
--    如需清理，先跑下面那条 count 确认影响行数，再取消 delete 的注释执行。
-- select count(*) from public.works_meta where slug not like '/external/%';
-- delete from public.works_meta
-- where slug not like '/external/%';

-- 2. 删除 slug 相关的索引与唯一约束（002 建表时创建）
drop index if exists public.idx_works_meta_slug;
alter table public.works_meta drop constraint if exists works_meta_slug_key;

-- 3. 删除列
alter table public.works_meta drop column if exists slug;

-- 4. 验证：期望结果中不再有 slug
select column_name, data_type
from information_schema.columns
where table_schema = 'public'
  and table_name = 'works_meta'
order by ordinal_position;
