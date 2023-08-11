<script>
defineComponent({
  name: 'WangEditor'
})
</script>
<script setup>
import '@wangeditor/editor/dist/css/style.css' // 引入 css
import { onBeforeUnmount, ref, shallowRef, onMounted, nextTick, defineComponent } from 'vue'
import { DomEditor, Boot } from '@wangeditor/editor'
import { Editor, Toolbar } from '@wangeditor/editor-for-vue'
import uploadImageConfig from './config/uploadImage'
import editorConfigOptions from './config/editor'
import toolbarConfigOptions from './config/toolbar'
import { previewMenu } from './custom/buttonMenus'
// 编辑器实例，必须用 shallowRef
const editorRef = shallowRef()
const previewShow = ref(false)

// 相关配置项
const mode = 'simple' // default 默认 simple 简约
const toolbarConfig = toolbarConfigOptions
const editorConfig = editorConfigOptions
editorConfig.MENU_CONF['uploadImage'] = uploadImageConfig

// 内容 HTML
const valueHtml = ref('')
// 模拟 ajax 异步获取内容
onMounted(() => {
  setTimeout(() => {
    valueHtml.value = '<p>我是一个好用的富文本编辑器~</p>'
  }, 1500)
})
// 组件销毁时，也及时销毁编辑器
onBeforeUnmount(() => {
  const editor = editorRef.value
  if (editor == null) return
  editor.destroy()
})

// 记录 editor 实例，重要！
const handleCreated = (editor) => {
  editorRef.value = editor
  // 初始化编辑器时注册自定义按钮
  Boot.registerMenu(previewMenu)
  nextTick(() => {
    /**
     *  DomEditor.getToolbar(editor) 返回了 null #5394
     * https://github.com/wangeditor-team/wangEditor/issues/5394
     */
    const toolbar = DomEditor.getToolbar(editor)
    console.log(toolbar.getConfig().toolbarKeys)
  })
}
// 禁用编辑器的方法
const handleDisable = () => {
  const editor = editorRef.value
  if (editor == null) return
  editor.disable()
}
// 监听编辑器输入改变
const handleChange = (editor) => {
  previewShow.value = editor.getConfig().preview
  console.log('change:', editor.children)
}
// 编辑器销毁时
const handleDestroyed = (editor) => {
  console.log('destroyed', editor)
}
// 编辑器获取焦点
const handleFocus = (editor) => {
  console.log('focus', editor)
}
// 编辑器失去焦点
const handleBlur = (editor) => {
  console.log('blur', editor)
}
const customAlert = (info, type) => {
  alert(`【自定义提示】${type} - ${info}`)
}
</script>

<template>
  <div class="app-content-center">
    <div class="wangeditor" :class="{ isPreview: previewShow }">
      <Toolbar class="toolbar" :editor="editorRef" :defaultConfig="toolbarConfig" :mode="mode" />
      <Editor
        class="editor"
        v-model="valueHtml"
        :defaultConfig="editorConfig"
        :mode="mode"
        @onCreated="handleCreated"
        @onChange="handleChange"
        @onDestroyed="handleDestroyed"
        @onFocus="handleFocus"
        @onBlur="handleBlur"
        @customAlert="customAlert"
      />
      <div v-if="previewShow" class="preview" v-html="valueHtml"></div>
    </div>
  </div>
</template>

<style lang="scss">
#editor—wrapper {
  z-index: 100; /* 按需定义 */
}
.wangeditor .preview,
.wangeditor .w-e-scroll {
  /*滚动条容器*/
  &::-webkit-scrollbar {
    opacity: 0;
    background: transparent !important; //滚动条容器背景色
    width: 4px; //y轴滚轮的宽
    height: 4px;
  }

  /*滚动条里面小方块*/
  &::-webkit-scrollbar-thumb {
    border-radius: 10px;
    -webkit-box-shadow: inset 0 0 5px rgba(0, 0, 0, 0.2);
    background: #e7e7e7a1;
  }

  /*滚动条里面轨道*/
  &::-webkit-scrollbar-track {
    background: transparent;
  }
}
</style>
<style scoped lang="scss">
.wangeditor {
  width: 70vw;
  height: 80vh;
  display: grid !important;
  align-content: flex-start;
  grid-template:
    'a a'
    'b b';
  grid-template-rows: auto 1fr;
  grid-template-columns: 1fr;
  grid-gap: 4px;
}
.wangeditor.isPreview {
  grid-template:
    'a a'
    'b c';
  grid-template-rows: auto 1fr;
  grid-template-columns: 1fr 1fr;
}
.toolbar {
  grid-area: a;
  position: relative;
  z-index: 10;
}
.editor {
  grid-area: b;
  overflow: hidden;
  position: relative;
  z-index: 9;
}
.preview {
  grid-area: c;
  padding: 0 10px;
  padding-top: 15px;
  overflow-y: auto;
  box-sizing: border-box;
  line-height: 1.5;
  background-color: #ffffff;
  position: relative;
  z-index: 8;
}
</style>
