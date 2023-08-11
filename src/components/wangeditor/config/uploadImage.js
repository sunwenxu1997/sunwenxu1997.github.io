import 'element-plus/es/components/message/style/css'
import { ElMessage } from 'element-plus'
export default {
    // 服务端地址
    server: '/api/myx/filesystem-web/fileIndex/upload',
    // form-data fieldName ，默认值 'wangeditor-uploaded-image'
    fieldName: 'targetFile',
    // 单个文件的最大体积限制，默认为 2M
    maxFileSize: 2 * 1024 * 1024, // 2M
    // 最多可上传几个文件，默认为 100
    maxNumberOfFiles: 10,
    // 选择文件时的类型限制，默认为 ['image/*'] 。如不想限制，则设置为 []
    allowedFileTypes: ['image/*'],
    // 自定义上传参数，例如传递验证的 token 等。参数会被添加到 formData 中，一起上传到服务端。
    meta: {
        fileReqDTO: new Blob([JSON.stringify({ appName: '3', businessType: 'default', type: 'FDFS' })])
        // token: 'xxx',
        // otherKey: 'yyy'
    },
    // 将 meta 拼接到 url 参数中，默认 false
    metaWithUrl: false,
    // 自定义增加 http  header
    headers: {
        Accept: 'application/json',
        // Cookie: 'SECKEY_ABVK=RIPgv6T749o3ezAxtVTTR4BAxBTbdlawK8d4E0DB0Ug%3D; BMAP_SECKEY=cAy7trNOjbEfh4QD5IBfm6o3s-9aSQ4rPgQ0eeDaOr3JFdWJVv-hX-H-aTSww_qhp3W7CPjMrgZEF8ocz5AXbYYLuEbLoKRxgKOVGTF5A0t0JjTv-1CecGnZiSI6x9wnOxtmglBfy7iChnPsx2v4FGorPcHqiZljg7XeiK6GkTGW4CrpsQ-qIEyZXGL8wlHU; MEICLOUDCCSSESSIONID=9cd01088-c4e6-463e-a078-522758455d32'
    },
    // 跨域是否传递 cookie ，默认为 false
    withCredentials: true,
    // 超时时间，默认为 10 秒
    timeout: 5 * 1000, // 5 秒
    /**
     * 
     *自定义插入图片
     *https://www.wangeditor.com/v5/menu-config.html#%E8%87%AA%E5%AE%9A%E4%B9%89%E5%8A%9F%E8%83%BD
     */
    customInsert(res, insertFn) {
        /**
         * "url": "xxx", // 图片 src ，必须
         * "alt": "yyy", // 图片描述文字，非必须
         * "href": "zzz" // 图片的链接，非必须
         */
        const { downloadUrl, fileName } = res.content
        // 从 res 中找到 url alt href ，然后插入图片
        //   insertFn(url, alt, href)
        insertFn(downloadUrl, fileName)
    },
    // 上传之前触发
    onBeforeUpload(file) {    // JS 语法
        // file 选中的文件，格式如 { key: file }
        return file
        // 可以 return
        // 1. return file 或者 new 一个 file ，接下来将上传
        // 2. return false ，不上传这个 file
    },
    // 上传进度的回调函数
    onProgress(progress) {       // JS 语法
        // progress 是 0-100 的数字
        console.log('progress', progress)
    },

    // 单个文件上传成功之后
    onSuccess(file, res) {          // JS 语法
        console.log(`${file.name} 上传成功`, res)
    },

    // 单个文件上传失败
    onFailed(file, res) {           // JS 语法
        console.log(`${file.name} 上传失败`, res)
    },

    // 上传错误，或者触发 timeout 超时
    onError(file, err, res) {               // JS 语法
        console.log(`${file.name} 上传出错`, err, res)
        ElMessage({
            message: err,
            center: true,
            grouping: true,
            type: 'error',
        })
    },
}