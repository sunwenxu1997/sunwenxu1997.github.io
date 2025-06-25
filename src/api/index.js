import request from '../utils/http'

// 登录获取token
export function login(data) {
  return request({
    url: '/login',
    method: 'post',
    data
  })
}
