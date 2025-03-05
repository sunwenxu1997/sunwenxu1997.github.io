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

// 创建BroadcastChannel消息通道
export function createBroadcastChannel(channelName, data) {
  if (!window.broadcastChannel) {
    window.broadcastChannel = {};
  }
  if (!window.broadcastChannel[channelName]) {
    window.broadcastChannel[channelName] = new BroadcastChannel(channelName);
  }
  const broadcastChannel = window.broadcastChannel[channelName];
  if (data) broadcastChannel.postMessage(data);
  return broadcastChannel;
}

// 监听BroadcastChannel消息通道
export function listenBroadcastChannel(channelName, callback) {
  const broadcastChannel = createBroadcastChannel(channelName);
    broadcastChannel.onmessage = (event) => {
        callback(event);
    };
}

// 关闭BroadcastChannel消息通道
export function closeBroadcastChannel(channelName) {
  const broadcastChannel = window.broadcastChannel && window.broadcastChannel[channelName];
  if (broadcastChannel) {
    broadcastChannel.close();
    delete window.broadcastChannel[channelName];
    if (Object.keys(window.broadcastChannel).length === 0) {
      delete window.broadcastChannel;
    }
  }
}