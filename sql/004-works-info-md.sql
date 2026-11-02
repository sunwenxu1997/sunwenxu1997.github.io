-- ================================================================
-- works_meta.info_md：作品介绍改为 Markdown 正文
-- 前端只读 info_md；info_html 保留但不再读写
-- ================================================================

alter table public.works_meta add column if not exists info_md text;

comment on column public.works_meta.info_md is 'Markdown 正文，渲染入口唯一来源';
comment on column public.works_meta.info_html is '历史 HTML 正文，已废弃，前后端均不再读写';

-- RLS 与索引无需调整（同一行策略）
