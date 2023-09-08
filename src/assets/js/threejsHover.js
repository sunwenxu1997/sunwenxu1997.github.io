import * as THREE from 'three'
import { gsap } from 'gsap'
var hoverEffect = function (opts) {
  // 顶点着色器
  var vertex = `
        varying vec2 vUv;
        void main() {
          vUv = uv;
          gl_Position = projectionMatrix * modelViewMatrix * vec4( position, 1.0 );
        }
    `
  // 片段着色器
  var fragment = `
        varying vec2 vUv;

        uniform sampler2D texture1;
        uniform sampler2D texture2;
        uniform sampler2D disp;

        // uniform float time;
        // uniform float _rot;
        uniform float dispFactor;
        uniform float effectFactor;

        // vec2 rotate(vec2 v, float a) {
        //  float s = sin(a);
        //  float c = cos(a);
        //  mat2 m = mat2(c, -s, s, c);
        //  return m * v;
        // }

        void main() {

            vec2 uv = vUv;

            // uv -= 0.5;
            // vec2 rotUV = rotate(uv, _rot);
            // uv += 0.5;

            vec4 disp = texture2D(disp, uv);

            vec2 distortedPosition = vec2(uv.x + dispFactor * (disp.r*effectFactor), uv.y);
            vec2 distortedPosition2 = vec2(uv.x - (1.0 - dispFactor) * (disp.r*effectFactor), uv.y);

            vec4 _texture = texture2D(texture1, distortedPosition);
            vec4 _texture2 = texture2D(texture2, distortedPosition2);

            vec4 finalTexture = mix(_texture, _texture2, dispFactor);

            gl_FragColor = finalTexture;
            // gl_FragColor = disp;
        }
    `

  var parent = opts.parent || console.warn('no parent') //父标签元素
  var dispImage = opts.displacementImage || console.warn('displacement image missing') //转换效果图片
  var image1 = opts.image1 || console.warn('first image missing') //第一张要转换的图片
  var image2 = opts.image2 || console.warn('second image missing') //第二张要被转换的图片
  var intensity = opts.intensity || 1 //转换强度
  var speedIn = opts.speedIn || 1.6 //进入速度
  var speedOut = opts.speedOut || 1.2 //离开速度
  var userHover = opts.hover === undefined ? true : opts.hover
  var easing = opts.easing || 'expo.easeOut' //缓动效果 gsap

  // 适配移动端
  var mobileAndTabletcheck = function () {
    var check = false
    ;(function (a) {
      if (
        /(android|bb\d+|meego).+mobile|avantgo|bada\/|blackberry|blazer|compal|elaine|fennec|hiptop|iemobile|ip(hone|od)|iris|kindle|lge |maemo|midp|mmp|mobile.+firefox|netfront|opera m(ob|in)i|palm( os)?|phone|p(ixi|re)\/|plucker|pocket|psp|series(4|6)0|symbian|treo|up\.(browser|link)|vodafone|wap|windows ce|xda|xiino|android|ipad|playbook|silk/i.test(
          a
        ) ||
        /1207|6310|6590|3gso|4thp|50[1-6]i|770s|802s|a wa|abac|ac(er|oo|s\-)|ai(ko|rn)|al(av|ca|co)|amoi|an(ex|ny|yw)|aptu|ar(ch|go)|as(te|us)|attw|au(di|\-m|r |s )|avan|be(ck|ll|nq)|bi(lb|rd)|bl(ac|az)|br(e|v)w|bumb|bw\-(n|u)|c55\/|capi|ccwa|cdm\-|cell|chtm|cldc|cmd\-|co(mp|nd)|craw|da(it|ll|ng)|dbte|dc\-s|devi|dica|dmob|do(c|p)o|ds(12|\-d)|el(49|ai)|em(l2|ul)|er(ic|k0)|esl8|ez([4-7]0|os|wa|ze)|fetc|fly(\-|_)|g1 u|g560|gene|gf\-5|g\-mo|go(\.w|od)|gr(ad|un)|haie|hcit|hd\-(m|p|t)|hei\-|hi(pt|ta)|hp( i|ip)|hs\-c|ht(c(\-| |_|a|g|p|s|t)|tp)|hu(aw|tc)|i\-(20|go|ma)|i230|iac( |\-|\/)|ibro|idea|ig01|ikom|im1k|inno|ipaq|iris|ja(t|v)a|jbro|jemu|jigs|kddi|keji|kgt( |\/)|klon|kpt |kwc\-|kyo(c|k)|le(no|xi)|lg( g|\/(k|l|u)|50|54|\-[a-w])|libw|lynx|m1\-w|m3ga|m50\/|ma(te|ui|xo)|mc(01|21|ca)|m\-cr|me(rc|ri)|mi(o8|oa|ts)|mmef|mo(01|02|bi|de|do|t(\-| |o|v)|zz)|mt(50|p1|v )|mwbp|mywa|n10[0-2]|n20[2-3]|n30(0|2)|n50(0|2|5)|n7(0(0|1)|10)|ne((c|m)\-|on|tf|wf|wg|wt)|nok(6|i)|nzph|o2im|op(ti|wv)|oran|owg1|p800|pan(a|d|t)|pdxg|pg(13|\-([1-8]|c))|phil|pire|pl(ay|uc)|pn\-2|po(ck|rt|se)|prox|psio|pt\-g|qa\-a|qc(07|12|21|32|60|\-[2-7]|i\-)|qtek|r380|r600|raks|rim9|ro(ve|zo)|s55\/|sa(ge|ma|mm|ms|ny|va)|sc(01|h\-|oo|p\-)|sdk\/|se(c(\-|0|1)|47|mc|nd|ri)|sgh\-|shar|sie(\-|m)|sk\-0|sl(45|id)|sm(al|ar|b3|it|t5)|so(ft|ny)|sp(01|h\-|v\-|v )|sy(01|mb)|t2(18|50)|t6(00|10|18)|ta(gt|lk)|tcl\-|tdg\-|tel(i|m)|tim\-|t\-mo|to(pl|sh)|ts(70|m\-|m3|m5)|tx\-9|up(\.b|g1|si)|utst|v400|v750|veri|vi(rg|te)|vk(40|5[0-3]|\-v)|vm40|voda|vulc|vx(52|53|60|61|70|80|81|83|85|98)|w3c(\-| )|webc|whit|wi(g |nc|nw)|wmlb|wonu|x700|yas\-|your|zeto|zte\-/i.test(
          a.substr(0, 4)
        )
      )
        check = true
    })(navigator.userAgent || navigator.vendor || window.opera)
    return check
  }

  var scene = new THREE.Scene() // 场景
  // THREE.OrthographicCamera( left, right, top, bottom, near, far )
  // 正投影相机
  // http://www.webgl3d.cn/pages/1c3a1a/
  var camera = new THREE.OrthographicCamera(
    parent.offsetWidth / -2,
    parent.offsetWidth / 2,
    parent.offsetHeight / 2,
    parent.offsetHeight / -2,
    1, // near属性表示的是从距离相机多远的位置开始渲染，一般情况会设置一个很小的值。 默认值0.1
    1000 // far属性表示的是距离相机多远的位置截止渲染，如果设置的值偏小小，会有部分场景看不到。 默认值2000
  )

  camera.position.z = 1

  // 创建WEBGL渲染器
  // https://threejs.org/docs/index.html?q=WebGLRenderer#api/en/renderers/WebGLRenderer
  var renderer = new THREE.WebGLRenderer({
    antialias: false // 抗锯齿
  })

  renderer.setPixelRatio(window.devicePixelRatio) // 设置设备像素比 防止输出画布模糊
  renderer.setClearColor(0xffffff, 0.0) // 设置透明颜色和不透明度
  renderer.setSize(parent.offsetWidth, parent.offsetHeight) // 设置渲染器的大小
  parent.appendChild(renderer.domElement) // 将渲染器的canvas元素添加到页面中

  // 加载图片
  var loader = new THREE.TextureLoader()
  loader.crossOrigin = ''
  var texture1 = loader.load(image1)
  var texture2 = loader.load(image2)

  // 加载不同转换类型的图片
  var disp = loader.load(dispImage)

  // texture1.magFilter = texture2.magFilter = THREE.LinearFilter;
  // texture1.minFilter = texture2.minFilter = THREE.LinearFilter;

  // texture1.anisotropy = renderer.capabilities.getMaxAnisotropy();
  // texture2.anisotropy = renderer.capabilities.getMaxAnisotropy();

  // 创建着色器材质
  // https://threejs.org/docs/index.html?q=ShaderMaterial#api/en/materials/ShaderMaterial
  // ShaderMaterial只能由WebGLRenderer正确渲染
  var mat = new THREE.ShaderMaterial({
    uniforms: {
      effectFactor: { type: 'f', value: intensity }, // 转换强度
      dispFactor: { type: 'f', value: 0.0 }, // 转换效果覆盖因素，最高为1
      texture1: { type: 't', value: texture1 },
      texture2: { type: 't', value: texture2 }, // 转换后的图片，注释掉的话就会保持第一张图的过度
      disp: { type: 't', value: disp } // 转换类型的图片
    },

    vertexShader: vertex, // 顶点着色器
    fragmentShader: fragment, // 片段着色器
    transparent: true,
    opacity: 1.0
  })

  // 创建平面
  var geometry = new THREE.PlaneGeometry(parent.offsetWidth, parent.offsetHeight)

  // 创建网格
  var object = new THREE.Mesh(geometry, mat)
  scene.add(object)

  // 添加事件
  var addEvents = function () {
    var evtIn = 'mouseenter' // 鼠标进入
    var evtOut = 'mouseleave' // 鼠标离开
    if (mobileAndTabletcheck()) {
      // 判断是否是移动端
      evtIn = 'touchstart' // 触摸开始
      evtOut = 'touchend' // 触摸结束
    }

    // gsap 鼠标移入时动画执行效果
    parent.addEventListener(evtIn, function (e) {
      // 通过控制 mat.uniforms.dispFactor 的value值来实现转换效果
      gsap.to(mat.uniforms.dispFactor,{
        value: 1,
        duration:speedIn,
        ease: easing
      })
    })
    // gsap 鼠标移出时动画执行效果
    parent.addEventListener(evtOut, function (e) {
      gsap.to(mat.uniforms.dispFactor, {
        value: 0,
        duration: speedOut,
        ease: easing
      })
    })
  }

  if (userHover) {
    addEvents()
  }

  // 监听窗口大小变化
  window.addEventListener('resize', function (e) {
    renderer.setSize(parent.offsetWidth, parent.offsetHeight)
  })

  // 渲染
  var animate = function () {
    requestAnimationFrame(animate)

    renderer.render(scene, camera)
  }
  animate()
}
export default hoverEffect
