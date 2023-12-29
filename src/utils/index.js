// 是否在移动设备上
export function isMobileDevice() {
  return /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent)
}

// 节流
export function throttle(fn, time) {
  if (time == null || time == undefined) {
    time = 1000
  }
  if (typeof fn !== 'function') {
    throw new Error('Expected a function')
  }
  let timer
  return function (...args) {
    if (!timer) {
      fn.apply(this, args)
      timer = setTimeout(() => {
        timer = null
      }, time)
    }
  }
}

// 防抖
export function debounce(fn, interval) {
  var timer
  var gapTime = interval || 1000 //间隔时间，如果interval不传，则默认1000ms
  return function () {
    clearTimeout(timer)
    var context = this
    var args = arguments //保存此处的arguments，因为setTimeout是全局的，arguments不是防抖函数需要的。
    timer = setTimeout(function () {
      fn.call(context, args)
    }, gapTime)
  }
}
