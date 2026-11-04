import { supabase } from '@/lib/supabase'

/**
 * Supabase Storage 封面上传封装
 * bucket：works-covers
 *   - public 读（前台 <img> 免签名）
 *   - 仅 admin 可写（策略见 sql/007-storage-cover.sql）
 *   - bucket 统一上限 10MB（迁就 GIF），静态图的 2MB 限制靠下面 maxSizeOf
 * 前端只有 anon/publishable key，所以真正的权限边界在 Storage RLS，
 * 这里的类型/体积校验只是提前拦截、给用户更快的提示。
 */

export const COVER_BUCKET = 'works-covers'
/** 静态图（JPG/PNG/WebP）单张上限：2MB */
export const COVER_MAX_SIZE = 2 * 1024 * 1024
/** GIF 动图单张上限：10MB（动图体积天然偏大） */
export const COVER_GIF_MAX_SIZE = 10 * 1024 * 1024
/** 允许的图片 MIME（与 bucket 的 allowed_mime_types 保持一致） */
export const COVER_ALLOWED_TYPES = ['image/jpeg', 'image/png', 'image/webp', 'image/gif']
/** <input type="file"> 的 accept 值 */
export const COVER_ACCEPT = COVER_ALLOWED_TYPES.join(',')
/** 界面展示的体积限制文案，与校验共用一份口径 */
export const COVER_SIZE_HINT = 'JPG/PNG/WebP ≤ 2MB，GIF ≤ 10MB'

/** 按 MIME 取体积上限：bucket 只能设统一上限，所以分档校验放在前端 */
function maxSizeOf(type) {
  return type === 'image/gif' ? COVER_GIF_MAX_SIZE : COVER_MAX_SIZE
}

function formatSize(bytes) {
  return `${Math.round(bytes / (1024 * 1024))}MB`
}

/** 公开访问 URL 里的路径标记，用于从 URL 反解出对象路径 */
const PUBLIC_MARKER = `/object/public/${COVER_BUCKET}/`

/** 从文件名/MIME 推断扩展名，避免中文文件名带进对象路径 */
function extOf(file) {
  const fromName = (file.name.split('.').pop() || '').toLowerCase().replace(/[^a-z0-9]/g, '')
  if (fromName) return fromName
  const sub = (file.type.split('/').pop() || '').toLowerCase()
  return sub === 'jpeg' ? 'jpg' : sub || 'jpg'
}

/**
 * 生成对象路径：covers/年月/时间戳-随机串.扩展名
 * 不用作品 slug：中文会被 URL 编码，且同一作品多次上传会互相覆盖
 */
function buildPath(file) {
  const now = new Date()
  const month = `${now.getFullYear()}${String(now.getMonth() + 1).padStart(2, '0')}`
  const rand = Math.random().toString(36).slice(2, 8)
  return `covers/${month}/${Date.now()}-${rand}.${extOf(file)}`
}

/**
 * 上传封面图并返回可直接访问的公开 URL
 * @param {File} file - 浏览器选中的本地图片
 * @returns {Promise<string>} publicUrl
 * @throws {Error} 类型/体积不符，或 Storage 返回错误（如 RLS 拒绝）
 */
export async function uploadCover(file) {
  if (!file) throw new Error('没有选中图片')
  if (!COVER_ALLOWED_TYPES.includes(file.type)) {
    throw new Error('只支持 JPG / PNG / WebP / GIF')
  }
  const maxSize = maxSizeOf(file.type)
  if (file.size > maxSize) {
    throw new Error(`${file.type === 'image/gif' ? 'GIF' : '图片'}不能超过 ${formatSize(maxSize)}`)
  }

  const path = buildPath(file)
  const { error } = await supabase.storage.from(COVER_BUCKET).upload(path, file, {
    // 对象路径带随机串不会变，长缓存可以省出网流量
    cacheControl: '31536000',
    upsert: false,
    contentType: file.type
  })
  if (error) throw error

  const { data } = supabase.storage.from(COVER_BUCKET).getPublicUrl(path)
  return data.publicUrl
}

/**
 * 按公开 URL 删除封面文件（换封面后清理旧图）
 * 非本 bucket 的外链 URL 会被忽略；删除失败只告警，不影响主流程
 * @param {string} publicUrl - getPublicUrl() 返回的 URL
 */
export async function deleteCoverByUrl(publicUrl) {
  if (!publicUrl || typeof publicUrl !== 'string') return
  const idx = publicUrl.indexOf(PUBLIC_MARKER)
  if (idx === -1) return
  const path = decodeURIComponent(publicUrl.slice(idx + PUBLIC_MARKER.length).split('?')[0])
  if (!path) return

  const { error } = await supabase.storage.from(COVER_BUCKET).remove([path])
  if (error) console.warn('[storage] 旧封面删除失败:', error.message)
}
