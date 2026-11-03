<template>
  <div class="panel">
    <div class="panel-header">
      <div>
        <h1 class="panel-title">{{ form.id ? `编辑: ${form.name}` : '新建作品' }}</h1>
        <p class="panel-desc">填写作品信息后保存</p>
      </div>
      <div class="panel-actions">
        <button class="btn-ghost" @click="resetForm">清空</button>
        <button class="btn-primary" :disabled="saving" @click="saveWork">{{ saving ? '保存中...' : '保存' }}</button>
      </div>
    </div>

    <div class="card">
      <div class="form-grid">
        <!-- 封面预览 + 发布开关 -->
        <div class="full cover-row">
          <div class="cover-left">
            <label class="label">封面预览</label>
            <div class="cover-center">
              <img v-if="form.cover_url" class="cover-preview" :src="form.cover_url" alt="cover" @error="form.cover_url = ''" />
              <div v-else class="cover-placeholder">
                <ImageIcon :size="28" />
                <span>暂无封面</span>
              </div>
            </div>
          </div>
          <div class="cover-right">
            <label class="toggle-row">
              <div class="toggle-track" :class="{ on: form.is_published }" @click="form.is_published = !form.is_published">
                <div class="toggle-dot"></div>
              </div>
              <span>发布</span>
            </label>
          </div>
        </div>

        <!-- 名称 + Slug -->
        <div>
          <label class="label">名称</label>
          <input v-model="form.name" class="input" placeholder="作品显示名称" @input="autoSlug" />
        </div>
        <div>
          <label class="label">Slug</label>
          <input v-model="form.slug" class="input" placeholder="/external/..." @input="onSlugInput" />
        </div>

        <!-- 封面 URL + 日期 -->
        <div>
          <label class="label">封面 URL</label>
          <input v-model="form.cover_url" class="input" placeholder="https://..." />
        </div>
        <div>
          <label class="label">日期</label>
          <input v-model="form.date" type="date" class="input" />
        </div>

        <!-- 代码 + 文章 -->
        <div>
          <label class="label">代码地址</label>
          <input v-model="form.code_url" class="input" placeholder="https://github.com/..." />
        </div>
        <div>
          <label class="label">文章链接</label>
          <input v-model="form.link_url" class="input" placeholder="https://juejin.cn/..." />
        </div>

        <!-- CodePen + 打开地址 -->
        <div>
          <label class="label">CodePen</label>
          <input v-model="form.codepen_url" class="input" placeholder="https://codepen.io/..." />
        </div>
        <div>
          <label class="label">打开地址</label>
          <input v-model="form.open_url" class="input" placeholder="https://..." />
        </div>

        <!-- 介绍：Markdown 正文 + 实时预览，与详情页共用同一渲染器 -->
        <div class="full">
          <div class="md-head">
            <label class="label">介绍 (Markdown)</label>
            <span class="md-count">{{ form.info_md.length }} 字符</span>
          </div>
          <p v-if="legacyHtmlOnly" class="md-warn">
            这条作品的正文还是旧的 HTML 格式（info_html）。跑完 sql/005 迁移后才会显示在这里；
            现在保存不会覆盖原 HTML，正文留空也没关系。
          </p>
          <div class="md-editor">
            <div class="md-pane">
              <textarea
                v-model="form.info_md"
                class="input md-input"
                spellcheck="false"
                placeholder="用 Markdown 写：## 小标题、`行内代码`、[链接](https://...)、**加粗**，代码块用三个反引号包裹"
              ></textarea>
            </div>
            <div class="md-pane md-preview">
              <MarkdownBody v-if="form.info_md.trim()" :content="form.info_md" />
              <p v-else class="md-empty">预览区：左边写 Markdown，这里实时渲染</p>
            </div>
          </div>
        </div>

        <!-- 标签 -->
        <div class="full">
          <label class="label">标签</label>
          <div class="tags-input">
            <span v-for="(tag, idx) in tags" :key="tag + idx" class="tag" @click="removeTag(idx)">{{ tag }}</span>
            <input
              ref="tagInputRef"
              v-model="tagInput"
              class="input tag-add"
              placeholder="+ 添加"
              @keydown.enter.prevent="addTag"
              @keydown.backspace="onTagBackspace"
            />
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive, computed } from 'vue'
import { toast } from 'vue-sonner'
import { ImageIcon } from 'lucide-vue-next'
import { upsertWork } from '@/api/works'
import MarkdownBody from '@/components/markdown/MarkdownBody.vue'

defineProps({
  saving: Boolean
})

const emit = defineEmits(['saved', 'reset', 'save-start', 'save-end'])

const tagInput = ref('')
const tagInputRef = ref(null)
// 仅在「有旧 HTML 正文、尚无 Markdown 正文」时为 true，用于提示先跑 005 迁移
const legacyHtmlOnly = ref(false)

const form = reactive({
  id: null,
  slug: '/external/',
  name: '',
  cover_url: '',
  info_md: '',
  code_url: '',
  link_url: '',
  codepen_url: '',
  open_url: '',
  date: '',
  sort_weight: 0,
  is_published: true,
  tags: []
})

const tags = computed({
  get: () => form.tags || [],
  set: (val) => { form.tags = val }
})

let prevAutoSlug = '/external/'
let slugManuallyEdited = false

function autoSlug() {
  const name = form.name.trim()
  const expected = '/external/' + name
  if (!slugManuallyEdited || form.slug === prevAutoSlug || !form.slug) {
    form.slug = name ? expected : '/external/'
    prevAutoSlug = form.slug
  }
}

function onSlugInput() {
  slugManuallyEdited = form.slug !== prevAutoSlug
}

function addTag() {
  const raw = tagInput.value.trim()
  if (!raw) return
  const newTags = raw.split(/[,，]/).map((t) => t.trim()).filter(Boolean)
  const set = new Set(form.tags || [])
  newTags.forEach((t) => set.add(t))
  form.tags = Array.from(set)
  tagInput.value = ''
}

function removeTag(idx) {
  form.tags.splice(idx, 1)
}

function onTagBackspace(e) {
  if (!tagInput.value && form.tags.length) {
    e.preventDefault()
    form.tags.pop()
  }
}

function resetForm() {
  Object.assign(form, {
    id: null,
    slug: '/external/',
    name: '',
    cover_url: '',
    info_md: '',
    code_url: '',
    link_url: '',
    codepen_url: '',
    open_url: '',
    date: '',
    sort_weight: 0,
    is_published: true,
    tags: []
  })
  prevAutoSlug = '/external/'
  slugManuallyEdited = false
  legacyHtmlOnly.value = false
  emit('reset')
}

function editWork(work) {
  Object.assign(form, {
    ...work,
    // info_md 列未建 / 值为 null 时统一成空串，避免模板里 .length 报错
    info_md: work.info_md || '',
    tags: Array.isArray(work.tags) ? [...work.tags] : []
  })
  legacyHtmlOnly.value = !work.info_md && !!work.info_html
  prevAutoSlug = work.slug || '/external/'
  slugManuallyEdited = true
}

async function saveWork() {
  if (!form.name || !form.slug) {
    toast.warning('名称和 Slug 不能为空')
    return
  }
  emit('save-start')
  try {
    const payload = {
      slug: form.slug,
      name: form.name,
      cover_url: form.cover_url || null,
      // 只写 info_md；info_html 保持原样，作为迁移前的回滚备份
      info_md: form.info_md || null,
      code_url: form.code_url || null,
      link_url: form.link_url || null,
      codepen_url: form.codepen_url || null,
      open_url: form.open_url || null,
      date: form.date || null,
      is_published: !!form.is_published,
      tags: form.tags || []
    }
    if (form.id) {
      payload.id = form.id
    }
    await upsertWork(payload)
    toast.success('保存成功')
    emit('saved')
  } catch (e) {
    console.error(e)
    toast.error('保存失败: ' + (e.message || e))
  } finally {
    emit('save-end')
  }
}

defineExpose({ editWork, resetForm })
</script>

<style scoped>
.panel-header {
  display: flex; align-items: center; justify-content: space-between;
  margin-bottom: 20px;
}
.panel-title { font-size: 20px; font-weight: 600; color: #292524; }
.panel-desc { font-size: 13px; color: #a8a29e; margin-top: 4px; }
.panel-actions { display: flex; gap: 8px; }

.card { background: #fff; border-radius: 12px; border: 1px solid #e7e5e4; overflow: hidden; }
.input {
  width: 100%; padding: 10px 14px;
  background: #fafaf9; border: 1px solid #e7e5e4; border-radius: 8px;
  font-size: 14px; color: #292524; outline: none; transition: border 0.2s;
  box-sizing: border-box;
}
.input:focus { border-color: #44403c; }
.input::placeholder { color: #a8a29e; }
textarea.input { resize: vertical; min-height: 90px; line-height: 1.6; }
.label {
  font-size: 12px; color: #78716c; font-weight: 500;
  letter-spacing: 0.03em; margin-bottom: 6px; display: block;
}
.btn-primary {
  background: #292524; color: #fff; border: none;
  padding: 9px 22px; border-radius: 8px;
  font-size: 13px; font-weight: 500; cursor: pointer; transition: all 0.2s;
}
.btn-primary:hover:not(:disabled) { background: #1c1917; }
.btn-primary:disabled { opacity: 0.7; cursor: not-allowed; }
.btn-ghost {
  background: transparent; color: #78716c; border: 1px solid #e7e5e4;
  padding: 8px 16px; border-radius: 8px; font-size: 13px;
  cursor: pointer; transition: all 0.15s;
}
.btn-ghost:hover { background: #f5f5f4; color: #292524; }

.toggle-track {
  width: 34px; height: 18px; border-radius: 9px;
  background: #d6d3d1; position: relative; cursor: pointer; transition: background 0.2s;
  flex-shrink: 0;
}
.toggle-track.on { background: #292524; }
.toggle-dot {
  width: 14px; height: 14px; border-radius: 50%; background: #fff;
  position: absolute; top: 2px; left: 2px; transition: transform 0.2s;
  box-shadow: 0 1px 2px rgba(0,0,0,0.1);
}
.toggle-track.on .toggle-dot { transform: translateX(16px); }

.tag {
  font-size: 11px; padding: 2px 8px; border-radius: 4px;
  background: #f5f5f4; color: #57534e; border: 1px solid #e7e5e4;
  white-space: nowrap; cursor: pointer;
}

/* ===== Markdown 编辑器 ===== */
.md-head {
  display: flex; align-items: baseline; justify-content: space-between;
}
.md-count { font-size: 11px; color: #a8a29e; }
.md-warn {
  margin: 0 0 10px; padding: 8px 12px; border-radius: 8px;
  background: #fffbeb; border: 1px solid #fde68a;
  font-size: 12px; line-height: 1.6; color: #92400e;
}
.md-editor {
  display: grid; grid-template-columns: 1fr 1fr; gap: 16px;
}
.md-pane {
  height: 340px; overflow: hidden;
  display: flex; flex-direction: column;
  background: #fafaf9;
  border: 1px solid #e7e5e4; border-radius: 8px;
}
/* 用 textarea.md-input 提升优先级，覆盖上方 textarea.input 的 min-height / resize */
textarea.md-input {
  flex: 1; min-height: 0; resize: none;
  border: none; border-radius: 0; background: transparent;
  padding: 12px 14px;
  font-family: ui-monospace, SFMono-Regular, Menlo, Consolas, monospace;
  font-size: 13px; line-height: 1.7;
}
textarea.md-input:focus { border-color: transparent; }
.md-preview {
  display: block; overflow-y: auto;
  padding: 12px 16px; background: #fff;
}
.md-empty { margin: 0; font-size: 13px; color: #a8a29e; }

@media (max-width: 1023px) {
  .md-editor { grid-template-columns: 1fr; }
  .md-pane { height: 240px; }
}

.form-grid {
  display: grid; grid-template-columns: 1fr 1fr; gap: 20px 24px;
  padding: 28px;
}
.form-grid .full { grid-column: 1 / -1; }
.cover-preview {
  width: 100%; max-width: 480px; aspect-ratio: 16/9;
  border-radius: 8px; object-fit: cover;
  border: 1px solid #e7e5e4; background: #fafaf9;
}
.cover-placeholder {
  width: 100%; max-width: 480px; aspect-ratio: 16/9;
  border-radius: 8px;
  border: 2px dashed #d6d3d1; background: #fafaf9;
  display: flex; align-items: center; justify-content: center;
  flex-direction: column; gap: 6px;
  color: #a8a29e; font-size: 13px;
}
.cover-placeholder .lucide { width: 28px; height: 28px; opacity: 0.5; }
.cover-row { display: flex; gap: 24px; }
.cover-left { flex: 1; min-width: 0; }
.cover-center { display: flex; justify-content: center; margin-top: 8px; }
.cover-right { flex-shrink: 0; padding-top: 2px; }
.tags-input {
  display: flex; gap: 6px; flex-wrap: wrap; align-items: center;
}
.input.tag-add { width: 90px; padding: 6px 10px; font-size: 12px; }
.toggles { display: flex; gap: 28px; }
.toggle-row {
  display: flex; align-items: center; gap: 8px;
  font-size: 13px; color: #57534e; cursor: pointer;
}

@media (max-width: 767px) {
  .panel-header { flex-direction: column; align-items: flex-start !important; gap: 10px; }
  .panel-actions { width: 100%; justify-content: flex-end; }
  .form-grid {
    grid-template-columns: 1fr;
    gap: 14px;
    padding: 18px;
  }
  .cover-preview, .cover-placeholder { max-width: 100%; }
  .toggles { gap: 16px; }
}

@media (min-width: 768px) and (max-width: 1023px) {
  .form-grid { padding: 22px; gap: 16px 20px; }
}
</style>
