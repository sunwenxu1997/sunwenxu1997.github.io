<template>
  <div class="flex h-full min-h-[calc(100vh_-_56px)] flex-col">
    <div class="flex min-h-0 flex-1 flex-col overflow-hidden bg-white">
      <!-- 首行：名称即标题，操作按钮贴右上角，与正文共用 880px 居中容器 -->
      <div class="box-border mx-auto flex h-14 w-full max-w-[880px] shrink-0 items-center gap-3 px-8 max-md:h-auto max-md:flex-wrap max-md:gap-2 max-md:px-3.5 max-md:py-3">
        <input
          v-model="form.name"
          class="min-w-0 flex-1 border-0 bg-transparent py-1 text-[17px] font-semibold text-stone-800 outline-none placeholder:font-medium placeholder:text-stone-400 max-md:basis-[60%] max-md:text-base"
          placeholder="作品名称"
        />
        <div class="flex shrink-0 gap-2 max-md:ml-auto">
          <button
            class="cursor-pointer rounded-lg border border-stone-200 bg-transparent px-4 py-2 text-[13px] text-stone-600 transition-colors hover:bg-stone-100 hover:text-stone-800"
            @click="onClear"
          >
            清空
          </button>
          <button
            class="cursor-pointer rounded-lg border-0 bg-stone-800 px-[22px] py-[9px] text-[13px] font-medium text-white transition-colors hover:bg-stone-900 disabled:cursor-not-allowed disabled:opacity-70"
            :disabled="saving"
            @click="openMeta"
          >
            {{ saving ? '保存中...' : primaryText }}
          </button>
        </div>
      </div>

      <!-- 状态标识：独占一行，与名称输入框左缘对齐 -->
      <div class="box-border mx-auto w-full max-w-[880px] shrink-0 px-8 pb-3 max-md:px-3.5 max-md:pb-2.5">
        <span class="inline-block rounded border border-stone-200 bg-stone-100 px-2 py-px text-[11px] leading-tight text-stone-600">
          {{ form.id ? '编辑中' : '新建' }}
        </span>
      </div>

      <!-- 封面区：始终 880 居中，不随预览开关变化 -->
      <div class="box-border mx-auto w-full max-w-[880px] shrink-0 px-8 pb-4 pt-6 max-md:px-3.5 max-md:py-4">
        <!-- 上：封面（整块 420px 居中，内部标签/缩略图/URL 左对齐同宽） -->
        <div class="mx-auto flex w-full max-w-[420px] flex-col gap-2.5">
          <label class="block text-xs font-medium tracking-[0.03em] text-stone-600">封面</label>
          <!-- 预览区同时是拖拽上传区：点一下即可选本地图片 -->
          <div
            class="relative box-border block w-full cursor-pointer overflow-hidden rounded-lg bg-stone-50 transition-colors [aspect-ratio:16/9]"
            :class="dragOver
              ? 'border-2 border-stone-700'
              : form.cover_url
                ? 'border border-stone-200'
                : 'border-2 border-dashed border-stone-300'"
            @click="pickCover"
            @dragover.prevent="dragOver = true"
            @dragleave.prevent="dragOver = false"
            @drop.prevent="onCoverDrop"
          >
            <img
              v-if="form.cover_url"
              class="block h-full w-full object-cover"
              :src="form.cover_url"
              alt="cover"
              @error="form.cover_url = ''"
            />
            <div
              v-else
              class="flex h-full w-full flex-col items-center justify-center gap-1 text-[11px] text-stone-400"
            >
              <ImageIcon :size="16" class="opacity-60" />
              <span>{{ uploading ? '上传中...' : '点击或拖拽图片到此处' }}</span>
            </div>
            <div
              v-if="uploading"
              class="absolute inset-0 flex items-center justify-center bg-white/70 text-xs text-stone-700"
            >
              上传中...
            </div>
          </div>

          <!-- 本地文件选择：原生 input 隐藏，按钮和预览区都触发它 -->
          <input
            ref="coverInputRef"
            type="file"
            class="hidden"
            :accept="COVER_ACCEPT"
            @change="onCoverChange"
          />

          <div class="flex flex-wrap items-center gap-2">
            <button
              class="inline-flex cursor-pointer items-center gap-1.5 rounded-lg border border-stone-200 bg-transparent px-2.5 py-1 text-xs text-stone-600 transition-colors hover:bg-stone-100 hover:text-stone-800 disabled:cursor-not-allowed disabled:opacity-60"
              :disabled="uploading"
              @click="pickCover"
            >
              <Upload :size="13" />
              {{ uploading ? '上传中...' : form.cover_url ? '更换图片' : '上传图片' }}
            </button>
            <button
              v-if="form.cover_url"
              class="inline-flex cursor-pointer items-center gap-1.5 rounded-lg border border-stone-200 bg-transparent px-2.5 py-1 text-xs text-stone-600 transition-colors hover:bg-stone-100 hover:text-stone-800"
              @click="copyCoverUrl"
            >
              <Copy :size="13" />
              复制链接
            </button>
            <span class="ml-auto text-[11px] text-stone-400">{{ COVER_SIZE_HINT }}</span>
          </div>

          <input
            v-model="form.cover_url"
            class="box-border w-full rounded-lg border border-stone-200 bg-stone-50 px-2.5 py-[7px] text-[13px] text-stone-800 outline-none transition-colors placeholder:text-stone-400 focus:border-stone-700"
            placeholder="封面图 URL（也可直接粘贴外链）"
          />
        </div>
      </div>

      <!-- 正文区：关闭预览时 880 居中；开启时跳出限宽铺满屏幕。两种状态都是左右 32px，与汉堡图标的笔画左缘对齐 -->
      <div
        class="box-border mx-auto flex min-h-0 w-full min-w-0 flex-1 flex-col px-8 pb-6 max-md:px-3.5 max-md:pb-4"
        :class="previewOpen ? 'max-w-none' : 'max-w-[880px]'"
      >
        <div class="flex shrink-0 items-center justify-between gap-3">
          <label class="block text-xs font-medium tracking-[0.03em] text-stone-600">介绍 (Markdown)</label>
          <div class="flex items-center gap-2.5">
            <span class="text-[11px] text-stone-400">{{ form.info_md.length }} 字符</span>
            <button
              class="inline-flex cursor-pointer items-center gap-1.5 rounded-md border px-2.5 py-1 text-xs transition-colors"
              :class="previewOpen ? 'border-stone-800 bg-stone-800 text-white hover:bg-stone-900' : 'border-stone-200 bg-transparent text-stone-600 hover:bg-stone-100 hover:text-stone-800'"
              :title="previewOpen ? '关闭预览' : '打开预览 (⌘/Ctrl + ⇧ + P)'"
              @click="togglePreview"
            >
              <EyeOff v-if="previewOpen" :size="13" />
              <Eye v-else :size="13" />
              {{ previewOpen ? '关闭预览' : '预览' }}
            </button>
          </div>
        </div>
        <p v-if="legacyHtmlOnly" class="mt-2 shrink-0 rounded-lg border border-amber-200 bg-amber-50 px-3 py-2 text-xs leading-relaxed text-amber-800">
          这条作品的正文还是旧的 HTML 格式（info_html）。跑完 sql/005 迁移后才会显示在这里；
          现在保存不会覆盖原 HTML，正文留空也没关系。
        </p>
        <div
          class="mt-2 grid min-h-0 flex-1 grid-cols-1 gap-3.5"
          :class="{ 'lg:grid-cols-2': previewOpen }"
        >
          <div class="flex min-h-0 min-w-0 flex-col overflow-hidden rounded-lg border border-stone-200 bg-stone-50 max-lg:min-h-[240px] max-lg:max-h-[420px]">
            <textarea
              v-model="form.info_md"
              class="box-border min-h-0 flex-1 resize-none overflow-auto rounded-none border-0 bg-transparent p-3.5 font-mono text-[13px] leading-[1.7] text-stone-800 outline-none placeholder:text-stone-400"
              spellcheck="false"
              placeholder="用 Markdown 写：## 小标题、`行内代码`、[链接](https://...)、**加粗**，代码块用三个反引号包裹"
            ></textarea>
          </div>
          <div
            v-if="previewOpen"
            class="min-h-0 min-w-0 overflow-y-auto rounded-lg border border-stone-200 bg-white px-4 py-3 max-lg:min-h-[240px] max-lg:max-h-[420px]"
          >
            <MarkdownBody v-if="form.info_md.trim()" :content="form.info_md" />
            <p v-else class="m-0 text-[13px] text-stone-400">预览区：左边写 Markdown，这里实时渲染</p>
          </div>
        </div>
      </div>
    </div>

    <!-- 元信息弹框：点发布/更新才出现，单列。挂到 #app（tailwind important 前缀是 #app，挂 body 会丢样式） -->
    <Teleport to="#app">
      <div
        v-if="metaOpen"
        class="meta-surface fixed inset-0 z-[100] flex items-center justify-center bg-[rgba(28,25,23,0.45)] p-6 backdrop-blur-[2px] max-md:p-3"
        @click.self="closeMeta"
      >
        <div
          class="flex max-h-[80vh] w-[480px] max-w-full flex-col overflow-hidden rounded-2xl bg-white shadow-[0_24px_64px_rgba(0,0,0,0.18)] max-md:max-h-[88vh]"
          role="dialog"
          aria-modal="true"
          aria-label="作品信息"
        >
          <div class="flex shrink-0 items-center justify-between border-b border-stone-100 px-5 py-4">
            <h2 class="m-0 text-[15px] font-semibold text-stone-800">{{ form.id ? '更新作品' : '发布作品' }}</h2>
            <button
              class="inline-flex h-7 w-7 cursor-pointer items-center justify-center rounded-md border-0 bg-transparent text-[15px] leading-none text-stone-400 transition-colors hover:bg-stone-100 hover:text-stone-800"
              aria-label="关闭"
              @click="closeMeta"
            >✕</button>
          </div>

          <div ref="metaBodyRef" class="grid min-h-0 flex-1 content-start gap-3.5 overflow-y-auto px-5 py-[18px] outline-none" tabindex="-1">
            <div class="flex flex-col">
              <label class="mb-1.5 block text-xs font-medium tracking-[0.03em] text-stone-600">日期</label>
              <input
                v-model="form.date"
                type="date"
                class="box-border w-full rounded-lg border border-stone-200 bg-stone-50 px-3.5 py-2.5 text-sm text-stone-800 outline-none transition-colors focus:border-stone-700"
              />
            </div>

            <div class="flex flex-col">
              <label class="mb-1.5 block text-xs font-medium tracking-[0.03em] text-stone-600">代码地址</label>
              <input
                v-model="form.code_url"
                class="box-border w-full rounded-lg border border-stone-200 bg-stone-50 px-3.5 py-2.5 text-sm text-stone-800 outline-none transition-colors placeholder:text-stone-400 focus:border-stone-700"
                placeholder="https://github.com/..."
              />
            </div>

            <div class="flex flex-col">
              <label class="mb-1.5 block text-xs font-medium tracking-[0.03em] text-stone-600">文章链接</label>
              <input
                v-model="form.link_url"
                class="box-border w-full rounded-lg border border-stone-200 bg-stone-50 px-3.5 py-2.5 text-sm text-stone-800 outline-none transition-colors placeholder:text-stone-400 focus:border-stone-700"
                placeholder="https://juejin.cn/..."
              />
            </div>

            <div class="flex flex-col">
              <label class="mb-1.5 block text-xs font-medium tracking-[0.03em] text-stone-600">CodePen</label>
              <input
                v-model="form.codepen_url"
                class="box-border w-full rounded-lg border border-stone-200 bg-stone-50 px-3.5 py-2.5 text-sm text-stone-800 outline-none transition-colors placeholder:text-stone-400 focus:border-stone-700"
                placeholder="https://codepen.io/..."
              />
            </div>

            <div class="flex flex-col">
              <label class="mb-1.5 block text-xs font-medium tracking-[0.03em] text-stone-600">打开地址</label>
              <input
                v-model="form.open_url"
                class="box-border w-full rounded-lg border border-stone-200 bg-stone-50 px-3.5 py-2.5 text-sm text-stone-800 outline-none transition-colors placeholder:text-stone-400 focus:border-stone-700"
                placeholder="https://..."
              />
            </div>

            <div class="flex flex-col">
              <label class="mb-1.5 block text-xs font-medium tracking-[0.03em] text-stone-600">标签</label>
              <div class="flex flex-wrap items-center gap-1.5">
                <span
                  v-for="(tag, idx) in tags"
                  :key="tag + idx"
                  class="cursor-pointer whitespace-nowrap rounded border border-stone-200 bg-stone-100 px-2 py-px text-[11px] text-stone-700"
                  @click="removeTag(idx)"
                >{{ tag }}</span>
                <input
                  ref="tagInputRef"
                  v-model="tagInput"
                  class="box-border w-[90px] rounded-lg border border-stone-200 bg-stone-50 px-2.5 py-1.5 text-xs text-stone-800 outline-none transition-colors placeholder:text-stone-400 focus:border-stone-700"
                  placeholder="+ 添加"
                  @keydown.enter.prevent="addTag"
                  @keydown.backspace="onTagBackspace"
                />
              </div>
            </div>

            <div class="flex cursor-pointer items-center gap-2.5 pt-1" @click="form.is_published = !form.is_published">
              <div
                class="relative h-[18px] w-[34px] shrink-0 cursor-pointer rounded-full transition-colors"
                :class="form.is_published ? 'bg-stone-800' : 'bg-stone-300'"
                role="switch"
                :aria-checked="form.is_published"
              >
                <div
                  class="absolute left-0.5 top-0.5 h-3.5 w-3.5 rounded-full bg-white shadow-[0_1px_2px_rgba(0,0,0,0.1)] transition-transform"
                  :class="form.is_published ? 'translate-x-4' : ''"
                ></div>
              </div>
              <div>
                <span class="block text-[13px] text-stone-800">发布到前台</span>
                <span class="mt-0.5 block text-[11px] text-stone-400">关闭后前台不可见，等同草稿</span>
              </div>
            </div>
          </div>

          <div class="flex shrink-0 justify-end gap-2 border-t border-stone-100 px-5 py-3.5">
            <button
              class="cursor-pointer rounded-lg border border-stone-200 bg-transparent px-4 py-2 text-[13px] text-stone-600 transition-colors hover:bg-stone-100 hover:text-stone-800"
              @click="closeMeta"
            >
              取消
            </button>
            <button
              class="cursor-pointer rounded-lg border-0 bg-stone-800 px-[22px] py-[9px] text-[13px] font-medium text-white transition-colors hover:bg-stone-900 disabled:cursor-not-allowed disabled:opacity-70"
              :disabled="saving"
              @click="saveWork"
            >
              {{ saving ? '保存中...' : (form.id ? '确认更新' : '确认发布') }}
            </button>
          </div>
        </div>
      </div>
    </Teleport>
  </div>
</template>

<script setup>
import { ref, reactive, computed, nextTick, onMounted, onUnmounted } from 'vue'
import { toast } from 'vue-sonner'
import { ImageIcon, Eye, EyeOff, Upload, Copy } from 'lucide-vue-next'
import { upsertWork } from '@/api/works'
import { uploadCover, deleteCoverByUrl, COVER_ACCEPT, COVER_SIZE_HINT } from '@/api/storage'
import MarkdownBody from '@/components/markdown/MarkdownBody.vue'

defineProps({
  saving: Boolean
})

const emit = defineEmits(['saved', 'reset', 'save-start', 'save-end'])

const tagInput = ref('')
const tagInputRef = ref(null)
// 仅在「有旧 HTML 正文、尚无 Markdown 正文」时为 true，用于提示先跑 005 迁移
const legacyHtmlOnly = ref(false)
// 元信息弹框
const metaOpen = ref(false)
const metaBodyRef = ref(null)
// 预览开关：默认关闭，只显示 Markdown 输入，打开后右侧并排渲染
const previewOpen = ref(false)
// 封面本地文件上传：隐藏的 file input、上传中状态、拖拽高亮
const coverInputRef = ref(null)
const uploading = ref(false)
const dragOver = ref(false)
// 本次编辑中被替换掉的封面 URL，保存成功后才真正删除文件
const replacedCovers = ref([])

const form = reactive({
  id: null,
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

// 主按钮文案：新建=发布/存为草稿，编辑=更新
const primaryText = computed(() => {
  if (form.id) return '更新'
  return form.is_published ? '发布' : '存为草稿'
})

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

// ====== 封面：本地图片上传 ======
function markCoverReplaced(oldUrl) {
  if (!oldUrl || replacedCovers.value.includes(oldUrl)) return
  replacedCovers.value.push(oldUrl)
}

function pickCover() {
  if (uploading.value) return
  coverInputRef.value?.click()
}

function onCoverChange(e) {
  const file = e.target.files?.[0]
  // 清空 value，同一张图再选一次也能触发 change
  e.target.value = ''
  handleCoverFile(file)
}

function onCoverDrop(e) {
  dragOver.value = false
  handleCoverFile(e.dataTransfer?.files?.[0])
}

async function handleCoverFile(file) {
  if (!file || uploading.value) return
  uploading.value = true
  try {
    const url = await uploadCover(file)
    markCoverReplaced(form.cover_url)
    form.cover_url = url
    toast.success('封面上传成功')
  } catch (e) {
    console.error(e)
    toast.error('上传失败: ' + (e.message || e))
  } finally {
    uploading.value = false
  }
}

async function copyCoverUrl() {
  if (!form.cover_url) return
  try {
    await navigator.clipboard.writeText(form.cover_url)
    toast.success('封面链接已复制')
  } catch {
    toast.error('复制失败，请手动选择链接')
  }
}

/** 保存成功后清理本次被替换掉的封面文件；失败只告警，不影响保存结果 */
async function cleanupReplacedCovers(currentUrl) {
  const stale = replacedCovers.value.filter((url) => url && url !== currentUrl)
  replacedCovers.value = []
  for (const url of stale) {
    await deleteCoverByUrl(url)
  }
}

function onClear() {
  if (!window.confirm('确定清空当前表单？未保存的内容会丢失')) return
  resetForm()
}

function resetForm() {
  Object.assign(form, {
    id: null,
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
  legacyHtmlOnly.value = false
  tagInput.value = ''
  replacedCovers.value = []
  uploading.value = false
  dragOver.value = false
  closeMeta()
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
  tagInput.value = ''
  replacedCovers.value = []
  uploading.value = false
  dragOver.value = false
  closeMeta()
}

// ====== 元信息弹框 ======
function onKeydown(e) {
  if (e.key === 'Escape') closeMeta()
}

function lockScroll(locked) {
  document.body.style.overflow = locked ? 'hidden' : ''
}

function openMeta() {
  if (!form.name.trim()) {
    toast.warning('先填作品名称')
    return
  }
  metaOpen.value = true
  lockScroll(true)
  document.addEventListener('keydown', onKeydown)
  nextTick(() => metaBodyRef.value?.focus())
}

function closeMeta() {
  if (!metaOpen.value) return
  metaOpen.value = false
  lockScroll(false)
  document.removeEventListener('keydown', onKeydown)
}

// ====== 预览开关 ======
function togglePreview() {
  previewOpen.value = !previewOpen.value
}

// 快捷键 ⌘/Ctrl + Shift + P 切换预览（弹框打开时不响应）
function onPreviewKeydown(e) {
  if (metaOpen.value) return
  if ((e.metaKey || e.ctrlKey) && e.shiftKey && e.key.toLowerCase() === 'p') {
    e.preventDefault()
    togglePreview()
  }
}

onMounted(() => document.addEventListener('keydown', onPreviewKeydown))

onUnmounted(() => {
  document.removeEventListener('keydown', onKeydown)
  document.removeEventListener('keydown', onPreviewKeydown)
  lockScroll(false)
})

async function saveWork() {
  if (!form.name.trim()) {
    toast.warning('作品名称不能为空')
    return
  }
  const isEdit = !!form.id
  emit('save-start')
  try {
    const payload = {
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
    const saved = await upsertWork(payload)
    // 新建成功后回填 id：留在编辑页继续点保存时走 update，避免又插入一条重复记录
    if (!isEdit && saved?.id) form.id = saved.id
    // 先关弹框（挂在 #app 上，不关会一直浮在编辑页上方）
    closeMeta()
    // 保存成功后再清理被替换掉的旧封面文件，中途取消不会误删线上仍在引用的图
    await cleanupReplacedCovers(saved?.cover_url)
    // 发布/存草稿/更新成功后默认复制带 id 的详情链接，方便直接分享
    let copied = false
    if (saved?.id) {
      try {
        await navigator.clipboard.writeText(`${window.location.origin}/#/work/${saved.id}`)
        copied = true
      } catch {
        /* 复制失败（如权限被拒）只提示保存成功，不影响主流程 */
      }
    }
    const action = isEdit ? '更新' : form.is_published ? '发布' : '存草稿'
    toast.success(`${action}成功${copied ? '，详情链接已复制' : ''}`)
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
/*
 * 弹框 Teleport 到 #app，已经不在 WorksAdmin 的 .admin-works 内，
 * 那份 border 重置管不到这里。preflight 关闭时 input/select 默认是
 * border-style: inset，只有宽度和颜色被工具类覆盖，会渲染出内阴影感，
 * 所以这里单独补一份等价的重置。
 */
.meta-surface :deep(*),
.meta-surface :deep(*::before),
.meta-surface :deep(*::after) {
  border-width: 0;
  border-style: solid;
}
</style>
