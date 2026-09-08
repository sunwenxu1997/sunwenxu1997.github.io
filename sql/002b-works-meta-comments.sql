-- ================================================================
-- 字段/表注释：让 Supabase Dashboard Table Editor 悬停时能看到说明
-- 在 002-works-meta.sql 跑完后执行，幂等（重复跑无副作用）
-- ================================================================

-- profiles（001 已建的 RBAC 表）
comment on table public.profiles
  is '用户档案：与 auth.users 1:1 关联，由触发器 on_auth_user_created 自动创建';
comment on column public.profiles.id
  is '用户 UUID，与 auth.users.id 相同';
comment on column public.profiles.username
  is '显示名，默认取 raw_user_meta_data.user_name 或邮箱 @ 之前';
comment on column public.profiles.avatar_url
  is '头像 URL，OAuth 登录时自动从 provider 拉取';
comment on column public.profiles.role
  is '角色：user（默认）/ admin；用户不能自己把自己改成 admin（有 RLS 保护）';

-- works_meta（002 建的表）
comment on table public.works_meta
  is '作品元数据：存储 settings.js externalRoutes 的「运营态」字段。Vue demo 组件代码仍留在 src/views/works/，本表只存封面/介绍/链接/排序等';
comment on column public.works_meta.id
  is 'UUID 主键，由 gen_random_uuid() 自动生成';
comment on column public.works_meta.slug
  is '路由标识（唯一），需要和前端路由 path 一致才能关联到 Vue demo。例："/anime/anime-跟随小爱心"；外部链接类用 "/external/vue-组件页面装修demo" 这种前缀';
comment on column public.works_meta.name
  is '显示标题，渲染在作品卡片上方';
comment on column public.works_meta.cover_url
  is '封面图 URL。目前用 iili.io 外链，后续建议迁移到 Supabase Storage 的 works bucket（路径建议 works/<id>.<ext>）';
comment on column public.works_meta.info_html
  is '富文本介绍，支持 <code>/<b>/<a> 等 HTML。渲染时用 v-html，注意 XSS（建议后续只允许白名单标签）';
comment on column public.works_meta.code_url
  is 'GitHub 代码地址，作品卡片上「GitHub 图标」按钮跳转';
comment on column public.works_meta.link_url
  is '文章/外部链接（掘金、MDN 等），作品卡片上「链接图标」按钮跳转';
comment on column public.works_meta.codepen_url
  is 'CodePen 地址，作品卡片上「CodePen 图标」按钮跳转';
comment on column public.works_meta.open_url
  is '直接打开的地址（外部 demo / 线上站点），作品卡片上「打开图标」按钮跳转；与本地 Vue demo 的 path 二选一使用';
comment on column public.works_meta.date
  is '发布日期，用于排序和卡片右上角日期显示；null 时不显示日期';
comment on column public.works_meta.sort_weight
  is '排序权重（数值越大越靠前）；同权重按 date 降序；再同按 id 降序。默认 0，重要作品可设为 100/200 置顶';
comment on column public.works_meta.is_published
  is '发布标志：false 时匿名访问看不到，admin 后台能看到，用于草稿态。是作品可见性的唯一控制字段';
comment on column public.works_meta.tags
  is '分类标签数组，用于前端筛选。例：{css,gsap,3d}、{anime,动画}、{vue,装修}';
comment on column public.works_meta.created_at
  is '记录创建时间，自动生成';
comment on column public.works_meta.updated_at
  is '记录最后修改时间，由触发器 set_profiles_updated_at 自动更新';

-- 索引说明
comment on index public.idx_works_meta_sort
  is '首页/列表默认排序索引：sort_weight DESC, date DESC NULLS LAST, id DESC';
comment on index public.idx_works_meta_slug
  is 'slug 查找索引（仅含已发布），用于按 slug 快速定位作品';
