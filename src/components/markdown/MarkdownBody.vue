<script setup>
import { computed, nextTick, onMounted, ref, watch } from 'vue'
import { renderMarkdown } from '@/utils/markdown/renderer'

/**
 * Markdown 正文渲染
 * - 同步产出 HTML（v-html），代码块高亮异步补挂
 * - 与后台预览、详情页、列表展开共用同一套渲染，所见即所得
 */
const props = defineProps({
  content: { type: String, default: '' },
  highlight: { type: Boolean, default: true }
})

const emit = defineEmits(['rendered'])

const rootRef = ref(null)
const html = computed(() => renderMarkdown(props.content))

function collectToc(el) {
  return Array.from(el.querySelectorAll('h2[id], h3[id]')).map((node) => ({
    id: node.id,
    text: node.textContent,
    level: Number(node.tagName.slice(1))
  }))
}

async function enhance() {
  const el = rootRef.value
  if (!el) return

  // 正文里的外链统一新窗口打开
  el.querySelectorAll('a[href^="http"]').forEach((a) => {
    a.target = '_blank'
    a.rel = 'noopener noreferrer'
  })

  if (props.highlight) {
    const { highlightAll } = await import('@/utils/markdown/highlight')
    await highlightAll(el)
  }

  emit('rendered', { toc: collectToc(el) })
}

onMounted(enhance)

watch(
  () => [props.content, props.highlight],
  () => nextTick(enhance)
)
</script>

<template>
  <div ref="rootRef" class="md-body prose prose-sm prose-stone max-w-none" v-html="html"></div>
</template>
