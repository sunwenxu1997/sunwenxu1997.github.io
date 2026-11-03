-- ================================================================
-- 006：works_meta 放开匿名读取（草稿凭链接可看）
--
-- 背景：
--   002 脚本的策略 "works_meta: anon read published" 只允许 anon 读
--   is_published=true 的记录，因此草稿（is_published=false）的详情
--   链接对匿名访客表现为「作品不存在或已下线」。
--   本脚本把 anon 策略改为可读全部记录：草稿变成「凭链接可见」。
--
-- 影响面：
--   - 作品列表 /works 不受影响：fetchPublishedWorks 的查询自带
--     .eq('is_published', true)，草稿依然不会出现在列表里；
--   - 后台管理不受影响：authenticated/admin 策略未变动；
--   - 唯一变化：拿到草稿详情链接（/work/<id>）的任何人可直接查看。
--
-- 在哪执行：
--   Supabase Dashboard → 左侧 SQL Editor → New query → 整段粘贴 → Run
--   （.env.local 里的是 anon key，role=anon 没有任何 DDL 权限，
--     改策略必须用 Dashboard 的 postgres 身份执行）
--
-- 幂等：可重复执行（先 drop if exists 再 create）
-- 回滚：重跑 002-works-meta.sql 里 anon 策略的 create 语句即可恢复
-- ================================================================

drop policy if exists "works_meta: anon read published" on public.works_meta;
drop policy if exists "works_meta: anon read all" on public.works_meta;

create policy "works_meta: anon read all"
  on public.works_meta
  for select
  to anon
  using (true);
