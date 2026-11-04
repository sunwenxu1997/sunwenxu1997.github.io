-- ================================================================
-- 007：Supabase Storage 封面 bucket（作品封面上传）
--
-- 背景：
--   作品封面存在 works_meta.cover_url（纯文本 URL）。之前只能手填外链，
--   本脚本建立公开 bucket works-covers，配合 src/api/storage.js 让后台
--   编辑器可以选本地图片直传，拿 getPublicUrl() 的直链回填该字段。
--
-- 权限模型（前端只有 anon/publishable key，这里才是真正的安全边界）：
--   - public = true → 前台 <img> 免签名加载封面
--   - select       → anon / authenticated 都可读
--   - insert/update/delete → 仅 authenticated 且 public.is_admin()
--     （is_admin 来自 001-rbac-setup.sql）
--
-- 限制：
--   file_size_limit = 10MB（迁就 GIF 动图；bucket 只能设一个统一上限，
--     所以 JPG/PNG/WebP 的 2MB 限制只在前端 src/api/storage.js 做）
--   仅允许 jpg/png/webp/gif（bucket 的 allowed_mime_types 是最终防线）
--
-- 在哪执行：
--   Supabase Dashboard → 左侧 SQL Editor → New query → 整段粘贴 → Run
--   （.env.local 里的是 anon key，role=anon 没有任何 DDL 权限，
--     建 bucket / 改策略必须用 Dashboard 的 postgres 身份执行）
--
-- 幂等：可重复执行（bucket 用 on conflict do update，策略先 drop 再 create）
-- 回滚：
--   drop policy if exists "works-covers: public read"   on storage.objects;
--   drop policy if exists "works-covers: admin insert"  on storage.objects;
--   drop policy if exists "works-covers: admin update"  on storage.objects;
--   drop policy if exists "works-covers: admin delete"  on storage.objects;
--   delete from storage.buckets where id = 'works-covers';  -- 会连同文件一起清掉
-- ================================================================

-- 1. 建 bucket（已存在则更新配置）
insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values (
  'works-covers',
  'works-covers',
  true,
  10485760,
  array['image/jpeg', 'image/png', 'image/webp', 'image/gif']
)
on conflict (id) do update
  set public             = excluded.public,
      file_size_limit    = excluded.file_size_limit,
      allowed_mime_types = excluded.allowed_mime_types;

-- 2. 策略：读取（公开）
drop policy if exists "works-covers: public read" on storage.objects;
create policy "works-covers: public read"
  on storage.objects for select
  to anon, authenticated
  using (bucket_id = 'works-covers');

-- 3. 策略：上传（仅 admin）
drop policy if exists "works-covers: admin insert" on storage.objects;
create policy "works-covers: admin insert"
  on storage.objects for insert
  to authenticated
  with check (bucket_id = 'works-covers' and public.is_admin());

-- 4. 策略：覆盖/移动（仅 admin，upsert: true 时会走这条）
drop policy if exists "works-covers: admin update" on storage.objects;
create policy "works-covers: admin update"
  on storage.objects for update
  to authenticated
  using (bucket_id = 'works-covers' and public.is_admin())
  with check (bucket_id = 'works-covers' and public.is_admin());

-- 5. 策略：删除（仅 admin，换封面时清理旧文件用）
drop policy if exists "works-covers: admin delete" on storage.objects;
create policy "works-covers: admin delete"
  on storage.objects for delete
  to authenticated
  using (bucket_id = 'works-covers' and public.is_admin());

-- ================================================================
-- 跑完请验证：
--   select id, name, public, file_size_limit, allowed_mime_types
--   from storage.buckets where id = 'works-covers';
--
--   select policyname, cmd, roles
--   from pg_policies
--   where schemaname = 'storage' and tablename = 'objects'
--     and policyname like 'works-covers:%';
-- ================================================================
