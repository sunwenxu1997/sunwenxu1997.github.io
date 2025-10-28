<template>
  <div class="xhs-page">
    <div class="header">
      <h1>创作中心</h1>
    </div>

    <div class="form-container">
      <!-- 标题输入 -->
      <div class="form-item">
        <label>标题</label>
        <input v-model="form.title" placeholder="请输入标题" class="title-input" />
      </div>

      <!-- 内容输入 -->
      <div class="form-item">
        <label>内容</label>
        <textarea
          v-model="form.content"
          placeholder="请输入内容"
          class="content-textarea"
        ></textarea>
      </div>

      <!-- 封面图上传 -->
      <div class="form-item">
        <label>封面图</label>
        <div class="upload-area" @click="triggerCoverUpload">
          <input
            ref="coverInput"
            type="file"
            @change="handleCoverUpload"
            accept="image/*"
            style="display: none"
          />
          <div v-if="!form.cover" class="upload-placeholder">
            <span>+</span>
            <p>点击上传封面图</p>
          </div>
          <img v-else :src="form.cover" class="cover-preview" />
        </div>
      </div>

      <!-- 图文笔记 -->
      <div class="form-item">
        <label>图文笔记</label>
        <div class="images-container">
          <div v-for="(image, index) in form.images" :key="index" class="image-item">
            <img :src="image" />
            <button @click="removeImage(index)" class="remove-btn">删除</button>
          </div>
          <div class="upload-area small" @click="triggerImagesUpload">
            <input
              ref="imagesInput"
              type="file"
              @change="handleImagesUpload"
              accept="image/*"
              multiple
              style="display: none"
            />
            <div class="upload-placeholder">
              <span>+</span>
              <p>添加图片</p>
            </div>
          </div>
        </div>
      </div>

      <!-- 操作按钮 -->
      <div class="actions">
        <button @click="publish" class="publish-btn">一键发布</button>
        <button @click="share" class="share-btn">分享</button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'

// 定义表单数据
const form = reactive({
  title: 'test',
  content: '123',
  cover: '',
  images: []
})

// 获取DOM引用
const coverInput = ref(null)
const imagesInput = ref(null)
const route = useRoute()
const router = useRouter()

// 触发封面上传
const triggerCoverUpload = () => {
  coverInput.value.click()
}

// 处理封面上传
const handleCoverUpload = (event) => {
  const file = event.target.files[0]
  if (file) {
    const reader = new FileReader()
    reader.onload = (e) => {
      form.cover = e.target.result
    }
    reader.readAsDataURL(file)
  }
}

// 触发图片上传
const triggerImagesUpload = () => {
  imagesInput.value.click()
}

// 处理图片上传
const handleImagesUpload = (event) => {
  const files = Array.from(event.target.files)
  files.forEach((file) => {
    const reader = new FileReader()
    reader.onload = (e) => {
      form.images.push(e.target.result)
    }
    reader.readAsDataURL(file)
  })
}

// 删除图片
const removeImage = (index) => {
  form.images.splice(index, 1)
}

// 发布功能
const publish = () => {
  if (!form.title || !form.content) {
    alert('请填写标题和内容')
    return
  }
  const { title, content } = form
  xhs.share({
    shareInfo: {
      type: 'normal', // 笔记类型，图文用 'normal'，视频用 'video'
      title, // 笔记标题（可选）
      content, // 笔记正文内容（可选）
      images: ['https://picsum.photos/id/623/1000/600'] // 图文笔记必填，必须是公网图片地址
      // cover: "..." // 视频封面图，必须是公网地址
    },
    verifyConfig: {
      appKey: 'red.1Qb00ilaVO8RIJOT',
      nonce: 'LSfHJZnleaHxZxlr',
      timestamp: '1761638775955',
      signature: '82a57f74fa2251b3c90e23a2a704c49390a56d43364ed1cd4990336a79c7d236'
    },
    fail: (e) => {
      // 调用失败时的处理逻辑
      alert('小红书分享失败: ' + JSON.stringify(e))
    }
  })
  // 这里可以调用发布接口
}

// 分享功能
const share = () => {
  // 将表单数据编码为base64
  const data = JSON.stringify(form)
  const encodedData = btoa(encodeURIComponent(data))

  // 构造分享链接
  const baseUrl = window.location.origin + router.resolve({ name: 'xhs' }).href
  const shareUrl = `${baseUrl}?data=${encodedData}`

  // 复制到剪贴板
  navigator.clipboard.writeText(shareUrl).then(() => {
    alert('分享链接已复制到剪贴板')
  })
}

// 解析URL参数
const parseUrlParams = () => {
  const urlParams = new URLSearchParams(window.location.search)
  const encodedData = urlParams.get('data')

  if (encodedData) {
    try {
      const decodedData = decodeURIComponent(atob(encodedData))
      const parsedData = JSON.parse(decodedData)

      form.title = parsedData.title || ''
      form.content = parsedData.content || ''
      form.cover = parsedData.cover || ''
      form.images = parsedData.images || []
    } catch (error) {
      console.error('解析分享数据失败:', error)
    }
  }
}

// 页面加载时解析URL参数
onMounted(() => {
  parseUrlParams() // 修复：确保调用正确的函数名
})
</script>

<style scoped>
.xhs-page {
  max-width: 800px;
  margin: 0 auto;
  padding: 20px;
  font-family: Arial, sans-serif;
}

.header {
  text-align: center;
  margin-bottom: 30px;
}

.header h1 {
  color: #ff6b6b;
  font-size: 24px;
}

.form-container {
  background: #fff;
  border-radius: 10px;
  padding: 20px;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
}

.form-item {
  margin-bottom: 20px;
}

.form-item label {
  display: block;
  margin-bottom: 8px;
  font-weight: bold;
  color: #333;
}

.title-input {
  width: 100%;
  padding: 12px;
  border: 1px solid #ddd;
  border-radius: 5px;
  font-size: 16px;
  box-sizing: border-box;
}

.content-textarea {
  width: 100%;
  height: 150px;
  padding: 12px;
  border: 1px solid #ddd;
  border-radius: 5px;
  font-size: 16px;
  font-family: inherit;
  box-sizing: border-box;
  resize: vertical;
}

.upload-area {
  border: 2px dashed #ddd;
  border-radius: 5px;
  text-align: center;
  cursor: pointer;
  transition: border-color 0.3s;
  min-height: 200px;
  display: flex;
  align-items: center;
  justify-content: center;
}

.upload-area:hover {
  border-color: #ff6b6b;
}

.upload-placeholder {
  color: #999;
}

.upload-placeholder span {
  font-size: 48px;
  line-height: 1;
}

.cover-preview {
  max-width: 100%;
  max-height: 300px;
  object-fit: cover;
}

.images-container {
  display: flex;
  flex-wrap: wrap;
  gap: 10px;
}

.image-item {
  position: relative;
  width: 150px;
  height: 150px;
}

.image-item img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  border-radius: 5px;
}

.remove-btn {
  position: absolute;
  top: 5px;
  right: 5px;
  background: rgba(255, 255, 255, 0.8);
  border: none;
  border-radius: 50%;
  width: 24px;
  height: 24px;
  cursor: pointer;
}

.upload-area.small {
  width: 150px;
  height: 150px;
  min-height: auto;
}

.actions {
  display: flex;
  gap: 15px;
  justify-content: center;
  margin-top: 30px;
}

.publish-btn,
.share-btn {
  padding: 12px 30px;
  border: none;
  border-radius: 25px;
  font-size: 16px;
  cursor: pointer;
  transition: background-color 0.3s;
}

.publish-btn {
  background-color: #ff6b6b;
  color: white;
}

.publish-btn:hover {
  background-color: #ff5252;
}

.share-btn {
  background-color: #4ecdc4;
  color: white;
}

.share-btn:hover {
  background-color: #26a69a;
}
</style>
