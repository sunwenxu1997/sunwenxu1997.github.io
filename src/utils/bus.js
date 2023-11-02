import mitt from 'mitt';

// 创建事件总线
let bus = mitt()

// 在发送组件中发布事件
export const emitBus = (name, val) => {
  bus.emit(name, val)
}
// 在接收组件中订阅事件
export const onBus = (name, callback) => {
  bus.off(name)
  bus.on(name, callback)
}
