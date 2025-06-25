import axios from 'axios'

const instance = axios.create({
  baseURL: '/api',
  timeout: 30000,
  hiddenError: false // 隐藏错误提示
})

// Request interceptor
instance.interceptors.request.use(
  (config) => {
    return config
  },
  (error) => {
    return Promise.reject(error)
  }
)

// Response interceptor
instance.interceptors.response.use(
  (response) => {
    const { hiddenError } = response.config
    const res = response.data
    if (res.code !== 200) {
      if (!hiddenError) alert(res.msg || 'Error')
      return Promise.reject(new Error(res.msg || 'Error'))
    } else {
      return res
    }
  },
  (error) => {
    console.log('err' + error) // for debug
    alert(error.msg)
    return Promise.reject(error)
  }
)

export default instance
