import * as THREE from "three";

var
    camera, //相机
    scene, //场景对象Scene
    renderer, //渲染器
    geometry,//几何
    material,//材质
    mesh,//网
    clock,//时钟
    text;

var smokeParticles;
var requestAnimationFrameFun;
const smoke = {
    progress: 0,
    play(containerId) {
        var container = document.querySelector(containerId)
        init();
        smoke.animate();
        //初始化数据
        function init() {
            // https://threejs.org/docs/index.html?q=Clock#api/zh/core/Clock
            // 创建时钟计时器
            clock = new THREE.Clock();
            // https://threejs.org/docs/index.html?q=WebGLRenderer#api/zh/renderers/WebGLRenderer
            // 创建WebGL渲染器
            renderer = new THREE.WebGLRenderer();
            renderer.setSize(window.innerWidth, window.innerHeight);
            // 创建一个新的场景对象
            scene = new THREE.Scene();
            var loader = new THREE.TextureLoader();
            // scene.background = new THREE.Color(0x4831ab);
            var canvasBackground = loader.load('/images/bg-kv-gray.jpg');
            scene.background = canvasBackground
            // 创建透视摄像机
            // https://threejs.org/docs/index.html?q=PerspectiveCamera#api/zh/cameras/PerspectiveCamera
            // PerspectiveCamera( fov : Number, aspect : Number, near : Number, far : Number )
            // fov — 摄像机视锥体垂直视野角度
            // aspect — 摄像机视锥体长宽比
            // near — 摄像机视锥体近端面
            // far — 摄像机视锥体远端面
            camera = new THREE.PerspectiveCamera(90, window.innerWidth / window.innerHeight, 1, 1000);
            camera.position.z = 1000;
            scene.add(camera); //场景添加相机


            // 一个用于生成平面几何体的类，生成一个300*300的平面
            // https://threejs.org/docs/index.html?q=PlaneGeometry#api/zh/geometries/PlaneGeometry
            var textGeo = new THREE.PlaneGeometry(300, 300);
            // THREE.ImageUtils.crossOrigin = ''; //需要这拉在跨域图像从AWS
            var textTexture = loader.load('/images/smoke.png');
            // 网格材质 一种非光泽表面的材质，没有镜面高光
            // https://threejs.org/docs/index.html?q=MeshLambertMaterial#api/zh/materials/MeshLambertMaterial
            // , blending: THREE.AdditiveBlending  颜色混合模式
            var textMaterial = new THREE.MeshLambertMaterial({ color: 0x47de2c, opacity: 1, map: textTexture, transparent: true })
            // https://threejs.org/docs/index.html?q=Mesh#api/zh/objects/Mesh
            text = new THREE.Mesh(textGeo, textMaterial);
            text.position.z = 800;
            scene.add(text);

            // 创建灯光 颜色，光照强度
            var light = new THREE.DirectionalLight(0xffffff, 1.5);
            //光照方向
            light.position.set(-1, 0, 1);
            scene.add(light);

            var smokeTexture = loader.load('/images/fog.png');
            var smokeMaterial = new THREE.MeshLambertMaterial({ color: 0xffffff, opacity: 0.5, map: smokeTexture, transparent: true });
            var smokeGeo = new THREE.PlaneGeometry(300, 300);
            smokeParticles = []; //生成的烟雾集合

            //   烟雾数量
            for (var p = 0; p < 150; p++) {
                var particle = new THREE.Mesh(smokeGeo, smokeMaterial);
                // 生成随机位置和旋转方向
                particle.position.set(Math.random() * 500 - 250, Math.random() * 500 - 250, Math.random() * 1000 - 100);
                particle.rotation.z = Math.random() * 360;
                scene.add(particle);
                smokeParticles.push(particle);
            }

            // renderer.domElement 未指定canvas时，新建一个
            container.appendChild(renderer.domElement);

        }
    },
    animate() {
        requestAnimationFrameFun = requestAnimationFrame(smoke.animate);
        smoke.evolveSmoke();
        smoke.render();
    },
    clear() {
        cancelAnimationFrame(requestAnimationFrameFun)
    },
    //演变的烟雾，烟雾动画执行旋转
    evolveSmoke() {
        // note: three.js includes requestAnimationFrame shim
        var delta = clock.getDelta();
        var sp = smokeParticles.length;
        while (sp--) {
            smokeParticles[sp].rotation.z += (delta * 0.2); //烟雾每秒的旋转速度
        }
    },
    render() {
        // mesh.rotation.x += 0.005;
        // mesh.rotation.y += 0.01;
        // cubeSineDriver += .01;
        // mesh.position.z = 100 + (Math.sin(cubeSineDriver) * 500);
        camera.position.z = (1 - smoke.progress) * 1100 - 100
        text.position.z = (1 - smoke.progress) * 800;
        renderer.render(scene, camera);

    }
}
export default smoke