# 作品草稿写入规范（AI 执行手册）

> 本文自包含：读完这一份就能完成全部操作，**不需要去读任何项目源码或 SQL 文件**。
> 文中所有表结构、接口地址、请求头、字段类型都是最终结论，可直接照抄。
>
> 你（AI）的任务：把封面图 + Markdown 正文写入 Supabase，落一条
> `is_published = false` 的草稿，并给用户一个可预览的链接。
> 发布动作由用户在后台完成，你不得代为发布。

---

## 使用前：配置区

**四项全部从项目根目录的 `.env.local` 读取，本文不保存任何真实凭据。**

| 配置项 | 值 | 来源 |
|---|---|---|
| `SUPABASE_URL` | `$VITE_SUPABASE_URL` | `.env.local`，与前端构建用的是同一个变量 |
| `ANON_KEY` | `$VITE_SUPABASE_PUBLISHABLE_KEY` | `.env.local`，公开发布的公钥，只读、无写权限 |
| `ADMIN_EMAIL` | `$SUPABASE_ADMIN_EMAIL` | `.env.local`，后台登录邮箱 |
| `ADMIN_PASSWORD` | `$SUPABASE_ADMIN_PASSWORD` | `.env.local`，后台登录密码 |

说明：

- 使用前先载入：`set -a; source .env.local; set +a`。
- `.env.local` 已被 `.gitignore` 的 `*.local` 规则忽略，不会进仓库；换项目或换账号只改这一个文件。
- 前两项只用于定位项目和过 API 网关，后两项用于换取 token。
- token 缓存在 `.draft-token.json` 后 1 小时内不必重复登录。
- 密码属于敏感信息：不写入任何被追踪的文件、不在回复里复述、不打印到日志。
- 任何一个变量读不到时，才需要询问用户。

---

## 0. 30 秒速查

| 项目 | 结论 |
|---|---|
| 数据库表 | `public.works_meta` |
| 新建 | `POST /rest/v1/works_meta` |
| 更新 | `PATCH /rest/v1/works_meta?id=eq.<uuid>` |
| 封面存储 | bucket `works-covers`，`POST /storage/v1/object/works-covers/<path>` |
| 认证 | 邮箱密码换 JWT，请求带 `apikey` + `Authorization: Bearer <token>` |
| token 缓存 | 与本文件同目录的 `.draft-token.json`，有效期内直接复用 |
| 草稿标记 | 必须显式传 `is_published: false`（该字段默认值是 **true**） |
| 正文列 | `info_md`（Markdown）。`info_html` 已废弃，禁止写入 |
| 重复检测 | 查名称 + 查四个外链，任一命中就停下问用户，不自动创建也不自动更新 |
| 成功产出 | 返回 `id`，预览链接 `https://sunwenxu1997.github.io/#/work/<id>` |

---

## 1. 凭据与缓存

### 1.1 token 从哪来、怎么存

第一件事是登录换取 `access_token`，然后**把它缓存到本地**，避免每次调用都重新登录。

缓存文件位置：**与本 `draft-work.md` 同目录**，文件名 `.draft-token.json`。

文件内容：

```json
{
  "access_token": "eyJhbGciOi...",
  "expires_at": 1730874000,
  "email": "admin@example.com",
  "supabase_url": "<VITE_SUPABASE_URL 的值>"
}
```

`expires_at` 是**秒级时间戳**（不是毫秒），等于 `登录时刻 + expires_in`（接口返回的 `expires_in` 通常是 3600）。

使用规则，按顺序判断：

1. 文件不存在 → 走 3.1 登录，成功后写入缓存。
2. 文件存在，但 `email` 或 `supabase_url` 与当前配置不一致 → 视为无效，重新登录并覆盖。
3. 文件存在且匹配，`expires_at - 60 > 当前秒级时间戳` → **直接复用** `access_token`，跳过登录。
4. 文件存在但剩余有效期不足 60 秒 → 重新登录，覆盖缓存。
5. 任何请求返回 `401 JWT expired` → 删除缓存，重新登录一次，再重试该请求（**只重试一次**，仍失败就报错）。

安全要求：

- 该文件含可写权限的 JWT，泄露等于泄露后台。**必须**加入 `.gitignore`，不得提交、不得贴给他人。
- 用户换账号或换项目时，要先删掉这个文件。

### 1.2 权限模型

| 身份 | 读 `works_meta` | 写 `works_meta` | 读写 `works-covers` |
|---|---|---|---|
| 仅 `apikey`（匿名） | 全部行，含草稿 | 拒绝 | 只能读 |
| 已登录且 `is_admin()` 为 true | 全部行 | 允许 | 读写 |
| 已登录但非 admin | 全部行 | 拒绝 | 拒绝 |

权限由数据库的行级安全策略强制执行，无法从客户端绕过。所以第 4 节的「验权」步骤不可跳过。

### 1.3 两个已知副作用

- **草稿对匿名访客可见**：只要有链接就能打开，加工作品不要直接落库。
- **草稿不进公开列表**：`/#/works` 的查询自带 `is_published = true` 过滤。

---

## 2. 字段规范（本节最重要）

`public.works_meta` 的完整列定义。写库时**只能出现**这张表里标注为「可写」的列。

| 列名 | 类型 | 必填 | 库默认值 | 约束与限制 | JSON 传输格式 |
|---|---|---|---|---|---|
| `id` | uuid | 新建不传 | `gen_random_uuid()` | 主键。更新时放在 URL 查询参数，不放进 body | 字符串 |
| `name` | text | **是** | 无 | 去首尾空白后非空；建议 ≤ 40 字符，硬上限 120；**无唯一约束** | `"animejs-切割模糊文字"` |
| `cover_url` | text | **是** | null | 可公开访问的图片直链，本项目统一用 Storage 公开地址 | `"https://xxx.supabase.co/storage/v1/object/public/works-covers/covers/202611/1730-abc1.png"` |
| `info_md` | text | **是** | null | Markdown 正文，详情页唯一渲染来源（渲染配置 `html:false` / `breaks:true`） | `"# 标题\n\n正文..."` |
| `info_html` | text | **禁止** | null | 历史字段，已废弃，传了不渲染 | — |
| `code_url` | text | 否 | null | `http://` 或 `https://` 开头 | `"https://github.com/..."` |
| `link_url` | text | 否 | null | 同上，语义是「文章链接」 | `"https://juejin.cn/post/..."` |
| `codepen_url` | text | 否 | null | 同上，语义是「在线代码」 | `"https://codepen.io/.../pen/xxx"` |
| `open_url` | text | 否 | null | 同上，语义是「可直接运行的 demo」 | `"https://sunwenxu1997.github.io/xxx"` |
| `date` | date | 否 | null | 严格 `YYYY-MM-DD` 且日期真实存在；为 null 时列表排在最后 | `"2025-08-21"` |
| `sort_weight` | int | 否 | `0` | 非负整数，越大越靠前；**库里没有自增**，新建需自己取 `max + 1` | `12` |
| `is_published` | boolean | **是** | **`true`** | 草稿必须显式传 `false` | `false` |
| `tags` | text[] | 否 | `{}` | 以 md 中「标签」小节为准，原样保留（允许中文与大小写）；没有标签小节时才按 5.2 提炼 | `["gsap","svg"]` |
| `created_at` | timestamptz | 不传 | `now()` | 数据库自动维护 | — |
| `updated_at` | timestamptz | 不传 | `now()` | UPDATE 时由触发器自动刷新 | — |
| `slug` | — | **禁止** | — | 该列已被删除，传了直接 400 | — |

### 2.1 三个最容易出错的点

**① `is_published` 默认是 `true`**

不传这个字段 = 直接发布上线。草稿必须显式写：

```json
{ "is_published": false }
```

**② 空值只能是 `null`，不能是 `""`**

后台的「封面/日期/链接是否已配置」筛选用 `IS NULL` 判断。传空字符串会被当成「已配置」，导致统计口径错误。

```json
{ "codepen_url": null }   // 正确
{ "codepen_url": "" }     // 错误
```

**③ `tags` 是 Postgres 数组，但传输时用 JSON 数组**

```json
{ "tags": ["css", "gsap"] }        // 正确
{ "tags": "{css,gsap}" }           // 错误：PG 数组字面量，会被当普通字符串
{ "tags": "css,gsap" }             // 错误：字符串，类型不匹配
```

### 2.2 排序规则，决定 `sort_weight` 怎么取

```
sort_weight DESC → date DESC NULLS LAST → created_at DESC → id ASC
```

- 新建时必须 `max(sort_weight) + 1`。留 0 会和新数据并列，之后拖拽排序会触发全量重排。
- `date` 留 `null` 会沉到列表末尾。除非用户明确说没有日期，否则尽量填。

### 2.3 标签词表

新标签会污染筛选器，**先查再写**（查询片段见 3.4）。截至目前的已知词表：

```
css  gsap  anime  svg  three  canvas  mask  cssHtml  other
tailwindcss  draggable  scrollTrigger  slidev  editor  lottery
3d  interaction  component  audio  filter  parallax  webgl
```

找不到贴切的词才新增，且必须是单个小写英文单词。

---

## 3. 接口规范

### 3.0 通用约定

每个请求都必须带 `apikey`。除登录外，写操作还必须带 `Authorization: Bearer <token>`。

先设定下面这些变量，后面所有片段直接引用。四项全部来自 `.env.local`。

```bash
# 全部凭据从项目根目录 .env.local 读（该文件不提交）
set -a; source .env.local; set +a

BASE="$VITE_SUPABASE_URL"
ANON_KEY="$VITE_SUPABASE_PUBLISHABLE_KEY"
ADMIN_EMAIL="$SUPABASE_ADMIN_EMAIL"
ADMIN_PASSWORD="$SUPABASE_ADMIN_PASSWORD"

TOKEN="<登录拿到的 access_token>"
TABLE="works_meta"
BUCKET="works-covers"
```

四个 header 缺一不可的场景对照：

| 场景 | apikey | Authorization | Content-Type | Prefer |
|---|---|---|---|---|
| 登录 | 必须 | 不需要 | `application/json` | — |
| `rpc/is_admin` | 必须 | 必须 | `application/json` | — |
| 查询 | 必须 | 建议带 | — | — |
| 上传文件 | 必须 | 必须 | 图片真实 MIME | — |
| 插入 / 更新 | 必须 | 必须 | `application/json` | `return=representation` |
| 删除对象 | 必须 | 必须 | `application/json` | — |

### 3.1 登录换 token

```bash
curl -sS -X POST "$BASE/auth/v1/token?grant_type=password" \
  -H "apikey: $ANON_KEY" \
  -H "Content-Type: application/json" \
  -d '{"email":"'"$ADMIN_EMAIL"'","password":"'"$ADMIN_PASSWORD"'"}'
```

Node 版本（Node 22 内置 fetch）：

```js
const res = await fetch(`${BASE}/auth/v1/token?grant_type=password`, {
  method: 'POST',
  headers: { apikey: ANON_KEY, 'Content-Type': 'application/json' },
  body: JSON.stringify({ email: ADMIN_EMAIL, password: ADMIN_PASSWORD })
})
const auth = await res.json()
// auth.access_token  字符串
// auth.expires_in    秒，一般 3600
```

成功响应：

```json
{ "access_token": "eyJ...", "refresh_token": "...", "expires_in": 3600, "token_type": "bearer" }
```

登录成功后立刻按 1.1 的格式写缓存：`expires_at = 当前秒级时间戳 + expires_in`。

失败：`400 invalid_grant` → 邮箱或密码错；`400 email_not_confirmed` → 账号未验证邮箱。

### 3.2 确认是 admin（不可跳过）

```bash
curl -sS -X POST "$BASE/rest/v1/rpc/is_admin" \
  -H "apikey: $ANON_KEY" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{}'
```

返回 `true` 才能继续。返回 `false` 立即停止——后面每一步都会被拒绝，不要试。

### 3.3 查重（三级，任一级命中就停）

新建之前必须依次做三级检查。**任何一级命中或近似，都不要创建、不要更新，先把结果报给用户，等用户决定。**

**第一级：按标题精确查**

```bash
curl -sS -G "$BASE/rest/v1/works_meta" \
  --data-urlencode "select=id,name,is_published,sort_weight,cover_url" \
  --data-urlencode "name=eq.作品标题" \
  -H "apikey: $ANON_KEY"
```

**第二级：按标题模糊查**（同一作品换了说法）

```bash
curl -sS -G "$BASE/rest/v1/works_meta" \
  --data-urlencode "select=id,name" \
  --data-urlencode "name=ilike.*关键词*" \
  -H "apikey: $ANON_KEY"
```

**第三级：按外链查**（最可靠，链接唯一）

```bash
curl -sS -G "$BASE/rest/v1/works_meta" \
  --data-urlencode "select=id,name" \
  --data-urlencode "codepen_url=eq.<CodePen 地址>" \
  -H "apikey: $ANON_KEY"
```

`code_url` / `link_url` / `open_url` 同理，有几个就查几个。

判读规则：

- 三级全部返回 `[]` → 无重复，可以继续。
- 任一级命中 → **停止**。把命中的 `id`、`name`、`is_published` 列给用户，问他是想更新那一条、另起标题新建，还是放弃。
- 名称不同但明显是同一主题（如 `svg-path路径过渡` vs `SVG 贝塞尔曲线动画`）→ 也算「类似」，同样停下问用户。
- 不要在用户不知情的情况下自动 PATCH 已有记录。

其它注意：

- 匿名 apikey 就能查，不需要 token。
- 中文标题必须 URL 编码，用 `curl -G --data-urlencode` 或 `encodeURIComponent`，不要手动拼。

### 3.4 查标签词表

```bash
curl -sS "$BASE/rest/v1/works_meta?select=tags" -H "apikey: $ANON_KEY"
```

不需要 token（匿名可读全表）。返回形如 `[{"tags":["css","gsap"]}, ...]`，把所有数组摊平去重即得词表。

### 3.5 取当前最大排序权重

```bash
curl -sS -G "$BASE/rest/v1/works_meta" \
  --data-urlencode "select=sort_weight" \
  --data-urlencode "order=sort_weight.desc" \
  --data-urlencode "limit=1" \
  -H "apikey: $ANON_KEY" \
  -H "Authorization: Bearer $TOKEN"
```

返回 `[{"sort_weight": 11}]` → 新建用 `12`。空表则用 `1`。

### 3.6 上传封面

对象路径规则固定，必须与前端一致，否则后台换图时删不掉旧文件：

```
covers/{yyyyMM}/{毫秒时间戳}-{6位随机小写字母数字}.{ext}
例：covers/202611/1730870400000-a3f9k2.png
```

`yyyyMM` 是上传月份，如 2026 年 11 月 → `202611`。

```bash
OBJ="covers/202611/1730870400000-a3f9k2.png"

curl -sS -X POST "$BASE/storage/v1/object/works-covers/$OBJ" \
  -H "apikey: $ANON_KEY" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: image/png" \
  -H "cache-control: max-age=31536000" \
  -H "x-upsert: false" \
  --data-binary "@./cover.png"
```

Node 版本：

```js
import { readFile } from 'node:fs/promises'

const bytes = await readFile('./cover.png')   // Buffer
const res = await fetch(`${BASE}/storage/v1/object/works-covers/${OBJ}`, {
  method: 'POST',
  headers: {
    apikey: ANON_KEY,
    Authorization: `Bearer ${TOKEN}`,
    'Content-Type': 'image/png',
    'cache-control': 'max-age=31536000',
    'x-upsert': 'false'
  },
  body: bytes
})
```

类型与体积限制：

| 格式 | `Content-Type` | 扩展名 | 单张上限 |
|---|---|---|---|
| JPG | `image/jpeg` | jpg / jpeg | 2MB |
| PNG | `image/png` | png | 2MB |
| WebP | `image/webp` | webp | 2MB |
| GIF | `image/gif` | gif | 10MB |

- `Content-Type` 必须与文件真实格式一致，服务端会校验，不一致返回 `415`。
- `--data-binary` 不能换成 `-d`（会损坏二进制）。
- 公开地址不需要再调接口，直接拼接：

```
{BASE}/storage/v1/object/public/works-covers/{OBJ}
```

### 3.7 新建草稿

```bash
curl -sS -X POST "$BASE/rest/v1/works_meta" \
  -H "apikey: $ANON_KEY" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -H "Prefer: return=representation" \
  -d '{
    "name": "标题",
    "cover_url": "'"$BASE"'/storage/v1/object/public/works-covers/'"$OBJ"'",
    "info_md": "# 标题\n\n正文",
    "date": "2025-08-21",
    "tags": ["css", "gsap"],
    "code_url": null,
    "link_url": null,
    "codepen_url": null,
    "open_url": null,
    "sort_weight": 12,
    "is_published": false
  }'
```

- **`Prefer: return=representation` 不能省**，否则只返回 201 空响应，拿不到 `id`。
- 返回值是**数组**，取 `[0].id`。
- 不要传 `id`、`created_at`、`updated_at`、`info_html`、`slug`。

### 3.8 更新已有记录

```bash
curl -sS -X PATCH "$BASE/rest/v1/works_meta?id=eq.<uuid>" \
  -H "apikey: $ANON_KEY" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -H "Prefer: return=representation" \
  -d '{ "name": "标题", "cover_url": "...", "info_md": "..." }'
```

> **警告**：`?id=eq.<uuid>` 绝对不能漏。PostgREST 允许不带过滤条件的 PATCH，在 admin 身份下会把**整张表所有行**改成同样的值。

更新时保留原有的 `sort_weight` 与 `is_published`，除非用户明确要求修改。

### 3.9 删除 Storage 对象（换封面时清理旧图）

```bash
curl -sS -X DELETE "$BASE/storage/v1/object/works-covers" \
  -H "apikey: $ANON_KEY" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{ "prefixes": ["covers/202610/old-abc.png"] }'
```

`prefixes` 里放**对象路径**（从公开 URL 的 `/object/public/works-covers/` 之后截取），不是完整 URL。

### 3.10 token 缓存的读写片段

放到与本文件同目录的 `.draft-token.json`：

```js
import { readFile, writeFile } from 'node:fs/promises'
import path from 'node:path'

const CACHE = path.join(import.meta.dirname ?? '.', '.draft-token.json')

// 读取：只有三项都匹配且未过期才复用
async function loadToken(base, email) {
  try {
    const cached = JSON.parse(await readFile(CACHE, 'utf8'))
    const valid =
      cached.supabase_url === base &&
      cached.email === email &&
      cached.expires_at - 60 > Math.floor(Date.now() / 1000)
    return valid ? cached.access_token : null
  } catch {
    return null     // 文件不存在或损坏，当作没有缓存
  }
}

// 写入：登录成功后立刻调用
async function saveToken(base, email, accessToken, expiresIn) {
  await writeFile(
    CACHE,
    JSON.stringify(
      {
        access_token: accessToken,
        expires_at: Math.floor(Date.now() / 1000) + expiresIn,
        email,
        supabase_url: base
      },
      null,
      2
    ),
    { mode: 0o600 }
  )
}
```

`0o600` 是文件权限（仅本人可读写），在 macOS/Linux 上生效。

---

## 4. 执行步骤与检查项

按顺序做，每步都有「通过判据」。判据不满足就停下，不要带着问题往下走。

### 步骤 1 · 确认配置

确认项目根目录 `.env.local` 里四项都在：`VITE_SUPABASE_URL`、`VITE_SUPABASE_PUBLISHABLE_KEY`、`SUPABASE_ADMIN_EMAIL`、`SUPABASE_ADMIN_PASSWORD`。

- 通过判据：四个变量都能读到且非空。
- 不满足：请用户补进 `.env.local`（不要写在本文里，也不要写在其他被追踪的文件里）。

### 步骤 2 · 收集内容

需要凑齐：标题、封面图文件、Markdown 正文，以及可选的日期 / 标签 / 链接。

- 通过判据：标题非空；封面是真实存在的本地文件；正文非空。
- 不满足：向用户索取，**不许自己编造**（尤其是正文和日期）。

### 步骤 3 · 本地校验（不发任何请求）

逐项核对第 2 节的约束：

- 标题去空白后非空，≤ 120 字符
- 封面扩展名 ∈ {jpg, jpeg, png, webp, gif}，体积符合 3.6 的分档上限
- `date` 匹配 `^\d{4}-\d{2}-\d{2}$` 且是真实日期（`2025-02-30` 不合法）
- 四个链接都是 `http(s)://` 开头
- `tags` 已按 5.2 从 md 的标签小节取出，去重、去空
- 同一个 URL 没有同时填进多个链接字段

- 通过判据：全部通过。任一失败先修参数，不要先发请求再回改。

### 步骤 4 · 取 token

1. 按 3.10 读缓存。
2. 命中且有效 → 直接用，跳过登录。
3. 未命中 / 过期 / 账号或项目变了 → 走 3.1 登录，再按 3.10 写入缓存。

- 通过判据：手里有一个非空 `access_token`。
- 失败：`invalid_grant` → 密码错；`email_not_confirmed` → 账号未验证。原样转述用户，不要连续重试。

### 步骤 5 · 验权

按 3.2 执行。

- 通过判据：返回 `true`。
- 失败：返回 `false` → 该账号不是 admin，需要先用 service_role 权限执行提权。告知用户，不要尝试写库。

### 步骤 6 · 查重 + 定权重 + 查词表

依次执行 3.3（三级查重）、3.5、3.4。

- 通过判据：
  - 三级查重全部为空，确认是全新作品
  - 新建时已算出 `sort_weight = max + 1`
  - 已读取 md 中的标签小节；没有标签小节时，才对不在词表内的标签给出提醒
- **不满足就停**：任一级查重命中或标题近似，立即中止，把命中记录报给用户，
  不调用 3.6 上传、不调用 3.7 / 3.8 写库。

### 步骤 7 · 上传封面

按 3.6 执行。

- 通过判据：HTTP 200，且拼出的公开地址能打开（返回 200 而不是 404）。
- 失败常见原因：`403` → 不是 admin，或 bucket 策略缺失；`415` → `Content-Type` 与文件不符；`403 The resource already exists` → 路径撞了，换随机后缀重传。

### 步骤 8 · 写入数据库

新建走 3.7，更新走 3.8。

- 通过判据：返回数组非空且 `[0].id` 存在。
- 失败时**必须**按 3.9 删掉步骤 7 刚上传的封面，避免留下孤儿文件。

### 步骤 9 · 回报结果

固定输出以下内容，缺一不可：

```
状态：草稿（待发布）
标题：<name>
封面：<cover_url>
日期：<date 或 未填>
标签：<tags 或 无>
链接：<有哪几个，没有就写「无」>
预览：https://sunwenxu1997.github.io/#/work/<id>
发布：请到 https://sunwenxu1997.github.io/#/admin/works 打开该条，确认后把「发布」开关打开
```

- 通过判据：用户拿到一个能直接点开的预览链接。
- 链接必须用 hash 路由（站点基于 hash 路由），写成 `/work/<id>` 会 404。

---

## 5. 内容提取规则

AI 负责判断内容，接口只负责存。不按这个口径来会被退回。

### 5.1 `date`

优先级：用户明确说的日期 → 正文或对话里提到的发布/上线日期 → 运行当天。

- 归一化为 `YYYY-MM-DD`。
- 不要从封面图、文件修改时间、编码习惯推测。
- 用户说「上个月」「去年底」这类相对时间，先把今天日期说清楚再换算，拿不准就问。

### 5.2 `tags`

**第一优先：直接用 md 文件里的标签小节。**

如果正文里有 `## 标签`（或「标签」「Tags」「keywords」）小节，把列出的词全部取出：

```md
## 标签

GSAP, TimelineMax, SVG, 贝塞尔曲线, 路径形变, attr插件, Logo动画
```

→ `["GSAP","TimelineMax","SVG","贝塞尔曲线","路径形变","attr插件","Logo动画"]`

规则：

- **原样保留**：不改大小写、不翻译、不删减、不压缩数量。
- 只做三件清理：去首尾空白、丢弃空项、去重（保持原有顺序）。
- 中文、大写都允许——这是数据源本身的约定。

**第二优先：md 里没有标签小节时**，才按 3.4 的词表提炼：

- 1–3 个，优先复用词表中已有的值。
- 不要用句子、不要把标题整句塞进去。
- 与技术栈无关的形容词（`cool`、`demo`）不要当标签。

注意：站内历史数据既存 `gsap` 也存 `GSAP`，既存英文也存中文，筛选器按值精确匹配。
**不要为了「统一」去改用户给的标签**，那会让同一作品挂到另一个筛选分组。

### 5.3 四个链接

| 字段 | 对应内容 | 例子 |
|---|---|---|
| `code_url` | 代码仓库 | GitHub、Gitee |
| `link_url` | 文章 | 掘金、公众号、MDN 文档 |
| `codepen_url` | 在线代码 | CodePen、CodeSandbox |
| `open_url` | 能直接跑的线上 demo | 自己的 GitHub Pages |

- 找不到就留 `null`，不要猜、不要占位（禁止 `example.com`）。
- 同一个 URL 只能进一个字段。

### 5.4 `name`

用户给了就用；没给则从正文首行或对话主题提炼，≤ 40 字符，保持既有的 `主题-效果` 风格（如 `anime-切割模糊文字`）。

### 5.5 `info_md`

直接用用户提供的 Markdown 原文。

- 不改写、不润色、不补「知识点」段落、不改代码围栏的语言标识。
- 正文里的反引号、LaTeX、表格原样保留。

---

## 6. 禁止事项

1. 用 `ANON_KEY` 单独尝试写库（必然 403，说明没走登录）。
2. 不传 `is_published: false` 就提交（会直接发布上线）。
3. `PATCH` / `DELETE` 不带 `?id=eq.` 过滤条件（会波及整表）。
4. 写入 `info_html` 或 `slug`。
5. 用空字符串代替 `null`。
6. 把 `tags` 写成 `"{css,gsap}"` 或 `"css,gsap"`。
7. 跳过步骤 5 的 admin 校验直接上传（会白传一张图）。
8. 写库失败后不清理已上传的封面。
9. 在回复、文件、日志里复述 `ADMIN_PASSWORD` 或完整 `access_token`。
10. 把 `.draft-token.json` 提交到 git 或分享给他人。
11. 替用户执行发布（把 `is_published` 改成 `true`），除非用户明确要求。
12. 检测到重复或近似作品后仍继续创建 / 更新（必须先问用户）。

---

## 7. 失败处理对照表

| 现象 | 出现位置 | 原因 | 处理 |
|---|---|---|---|
| `400 invalid_grant` | 登录 | 邮箱或密码错 | 请用户核对，不要连续重试 |
| `400 email_not_confirmed` | 登录 | 账号未验证 | 让用户在 Auth 里确认 |
| 登录成功但 `is_admin` 为 false | 验权 | 账号不是 admin | 告知用户提权，停止后续步骤 |
| `401 No API key found` | 任意 | 漏了 `apikey` 头 | 补上 `ANON_KEY` |
| `401 JWT expired` | 任意 | token 超过 1 小时 | 删缓存，重新登录一次后重试 |
| `401 Invalid authentication credentials` | 任意 | token 损坏或已登出 | 同上 |
| `403 new row violates row-level security policy` | 写库 / 上传 | 不是 admin，或 bucket 策略缺失 | 回到步骤 5 |
| `403 The resource already exists` | 上传 | 对象路径撞了 | 换随机后缀重传 |
| `415 invalid mime type` | 上传 | `Content-Type` 与真实格式不符 | 按 3.6 表格改正 |
| `404 relation "works_meta" does not exist` | 查询 | 表未创建 | 告知用户需先建表 |
| `400 column "slug" does not exist` | 写库 | 传了已删除的列 | 去掉 `slug` |
| `400 invalid input syntax for type json` | 写库 | `tags` 传成了 PG 数组字面量 | 改成 JSON 数组 |
| `22P02 invalid input syntax for type uuid` | 查询 / 更新 | `id` 不是合法 uuid | 检查是否把标题当 id 传了 |
| `PGRST204 Could not find the 'xxx' column` | 写库 | 字段名拼错 | 对照第 2 节表格 |

---

## 8. 验收标准

一条草稿算写入成功，必须同时满足：

1. 写库请求返回了非空 `id`；
2. `GET {BASE}/rest/v1/works_meta?id=eq.<id>` 能查到该行，且 `is_published` 为 `false`；
3. `cover_url` 用浏览器打开能出图（HTTP 200）；
4. 打开 `https://sunwenxu1997.github.io/#/work/<id>` 能看到标题、封面、正文、日期、标签；
5. 打开 `https://sunwenxu1997.github.io/#/works` **看不到**这条。

第 5 条最容易被忽略，但它同时验证了两件事：写进去的确实是草稿，以及公开列表的过滤没被破坏。
