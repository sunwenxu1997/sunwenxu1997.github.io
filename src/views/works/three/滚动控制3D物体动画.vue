<script>
export default {
  hidden: true
}
</script>
<script setup>
import * as THREE from 'three'
import { onMounted,onUnmounted } from 'vue'
import { gsap } from 'gsap'
import { ScrollTrigger } from 'gsap/ScrollTrigger.js'

// 离开页面时，清空所有动画
onUnmounted(() => {
  ScrollTrigger.killAll()
})
onMounted(() => {
  //  创建场景对象Scene
  var scene = new THREE.Scene()
  // 创建辅助坐标系
  const axesHelper = new THREE.AxesHelper(2000)
  scene.add(axesHelper)

  /**
   * 创建网格模型
   */
  var geometry = new THREE.BoxGeometry(100, 100, 100)
  var material = new THREE.MeshLambertMaterial({
    color: 'white'
  })
  material.transparent = true
  material.opacity = 0.7
  var mesh = new THREE.Mesh(geometry, material)
  var material1 = new THREE.MeshLambertMaterial({
    color: 'blue'
  })
  var mesh1 = new THREE.Mesh(geometry, material1)
  scene.add(mesh, mesh1)

  /**
   * 创建点光源
   */
  var point = new THREE.PointLight('white')
  point.position.set(300, 500, 300)
  scene.add(point)

  //创建环境光
  var ambient = new THREE.AmbientLight('red')
  // scene.add(ambient)

  /**
   * 创建相机对象
   */
  var width = window.innerWidth //窗口宽度
  var height = window.innerHeight //窗口高度
  var aspect = width / height //窗口宽高比
  var far = 2000 //三维场景显示范围控制系数，系数越大，显示的范围越大
  var camera = new THREE.PerspectiveCamera(90, aspect, 0.1, far)
  camera.position.set(300, 300, 1000) //设置相机位置
  camera.lookAt(scene.position) //设置相机方向(指向的场景对象)

  /**
   * 创建渲染器对象
   * antialias 开启抗锯齿
   */
  var renderer = new THREE.WebGLRenderer({ antialias: true })
  renderer.setSize(width, height) //设置渲染区域尺寸
  renderer.setClearColor('white', 0) //设置背景颜色，0为透明色
  document.querySelector('.canvas').appendChild(renderer.domElement) //body元素中插入canvas对象

  /**
   * 创建控制器对象
   * 鼠标控制物体的旋转
   */
  // const controls = new OrbitControls(camera, renderer.domElement)

  //执行渲染操作   指定场景、相机作为参数
  renderer.render(scene, camera)
  scrollTimeLineAnimation({ mesh }) //滚动时执行时间线动画
  scrollToAnimation({ mesh: mesh1 }) //滚动时执行特定位置动画
  function render() {
    // 更新控制器
    // controls.update()
    renderer.render(scene, camera) //执行渲染操作
    // mesh.rotateY(0.01) //每次绕y轴旋转0.01弧度
    requestAnimationFrame(render) //请求再次执行渲染函数render
  }
  render()
})
// 特定位置动画执行
const scrollToAnimation = ({ mesh }) => {
  // 找到特定位置标签，滚到到其位置时执行对应动画
  const h30 = document.querySelectorAll('h1')[29]
  const h40 = document.querySelectorAll('h1')[39]
  // 滚动条滚动到h30位置时，标签向左移动100px，颜色变为红色
  gsap.to(h30, {
    x: 100,
    duration: 1,
    color: 'red',
    scrollTrigger: {
      trigger: h30,
      start: 'center center',
      end: 'center top',
      markers: true, // 显示触发器位置
      toggleActions: 'restart none none reverse'
    }
  })
  // 滚动条滚动到h30位置时，mesh向前移动300
  gsap.to(mesh.position, {
    z: 300,
    duration: 1,
    scrollTrigger: {
      trigger: h30,
      start: 'center center',
      end: 'center top',
      markers: true, // 显示触发器位置
      toggleActions: 'restart none none reverse'
    }
  })

  gsap.to(h40, {
    x: 100,
    duration: 1,
    color: 'red',
    scrollTrigger: {
      trigger: h40,
      start: 'center center',
      end: 'center top',
      markers: true, // 显示触发器位置
      toggleActions: 'restart none none reverse'
    }
  })
  gsap.to(mesh.position, {
    y: 300,
    duration: 1,
    scrollTrigger: {
      trigger: h40,
      start: 'center center',
      end: 'center top',
      markers: true, // 显示触发器位置
      toggleActions: 'restart none none reverse'
    }
  })
}

// 时间线动画
const scrollTimeLineAnimation = ({ mesh }) => {
  gsap.registerPlugin(ScrollTrigger)
  // 创建动画序列,动画默认按顺序执行以下动画，动画进度和滚动条挂钩
  const timeline = gsap.timeline()
  timeline
    .to(mesh.rotation, { x: Math.PI * 2, duration: 1 })
    .to(mesh.position, { x: 200, duration: 1 }, '-=1')
    .to(mesh.rotation, { y: Math.PI * 2, duration: 1 })
    .to(mesh.position, { y: 200, duration: 1 }, '-=1')

  ScrollTrigger.create({
    trigger: '.app-content',
    animation: timeline,
    start: 'top top',
    // end: '+=3000', //当内容不够多，且无法出现滚动条时，可以选择补差值
    scrub: true, // 滚动时动画进度和滚动条挂钩
    markers: true, // 显示触发器位置
    onUpdate: (self) => {
      console.log(self.progress)
    }
  })
}
</script>
<template>
  <div class="app-content">
    <div class="canvas"></div>
    <h1 v-for="item in 70" :key="item">{{ item }}.three + gsap</h1>
  </div>
</template>
<style lang="scss" scoped>
.canvas {
  width: 100vw;
  height: 100vh;
  overflow: hidden;
  position: fixed;
  top: 0;
  left: 0;
}
h1 {
  text-transform: uppercase;
}
</style>
