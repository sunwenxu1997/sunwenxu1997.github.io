/**
 * 图片水印处理工具类
 * 用于给图片添加文字水印，支持多种配置
 */
class WatermarkProcessor {
  /**
   * 构造函数
   * @param {Object} options - 水印默认配置
   * @param {string} options.text - 水印文字，默认"水印"
   * @param {string} options.color - 水印颜色，默认"#ffffff"
   * @param {number} options.opacity - 水印透明度(0-1)，默认0.7
   * @param {number} options.size - 水印字体大小(px)，默认24
   * @param {string} options.position - 水印位置，可选值：top-left, top-right, bottom-left, bottom-right, center, tiled
   * @param {string} options.font - 水印字体，默认"Arial, sans-serif"
   * @param {number} options.maxWidth - 处理后图片最大宽度，默认800
   * @param {number} options.maxHeight - 处理后图片最大高度，默认600
   */
  constructor(options = {}) {
    // 默认配置
    this.defaultOptions = {
      text: 'OPPLE',
      color: '#ffffff',
      opacity: 0.5,
      size: 22,
      position: 'tiled',
      font: 'Arial, sans-serif',
      maxWidth: 1920,
      maxHeight: 1080
    };

    // 合并用户配置
    this.options = { ...this.defaultOptions, ...options };
  }

  /**
   * 更新水印配置
   * @param {Object} options - 要更新的配置项
   */
  updateOptions(options) {
    this.options = { ...this.options, ...options };
  }

  /**
   * 处理图片并添加水印
   * @param {File|string|HTMLImageElement} imageSource - 图片源，可以是File对象、base64字符串或Image元素
   * @returns {Promise<string>} - 带水印的图片base64字符串
   */
  process(imageSource) {
    return new Promise((resolve, reject) => {
      // 根据不同的图片源类型进行处理
      if (imageSource instanceof File) {
        this._processFile(imageSource, resolve, reject);
      } else if (
        typeof imageSource === 'string' &&
        imageSource.startsWith('data:image')
      ) {
        this._processBase64(imageSource, resolve, reject);
      } else if (imageSource instanceof HTMLImageElement) {
        this._processImageElement(imageSource, resolve, reject);
      } else {
        reject(
          new Error('不支持的图片源类型，请提供File、base64字符串或Image元素')
        );
      }
    });
  }

  /**
   * 验证是否为有效的图片文件
   * @param {File} file - 要验证的文件
   * @returns {boolean} - 是否为有效图片文件
   */
  _isValidImageFile(file) {
    if (!file) return false;

    // 常见图片MIME类型
    const imageMimeTypes = [
      'image/jpeg',
      'image/png',
      'image/gif',
      'image/bmp',
      'image/webp',
      'image/svg+xml',
      'image/tiff'
    ];

    // 常见图片文件扩展名
    const imageExtensions = [
      '.jpg',
      '.jpeg',
      '.png',
      '.gif',
      '.bmp',
      '.webp',
      '.svg',
      '.tiff'
    ];

    // 获取文件扩展名（小写）
    const fileName = file.name.toLowerCase();
    const hasValidExtension = imageExtensions.some(ext =>
      fileName.endsWith(ext)
    );

    // 检查MIME类型
    const hasValidMimeType =
      imageMimeTypes.includes(file.type) ||
      (file.type.startsWith('image/') && file.type !== 'image/*');

    // MIME类型和扩展名有一个匹配即可（增加容错性）
    return hasValidMimeType || hasValidExtension;
  }
  /**
   * 处理File对象
   * @private
   */
  _processFile(file, resolve, reject) {
    if (!this._isValidImageFile(file)) {
      reject(new Error('请提供有效的图片文件'));
      return;
    }

    const reader = new FileReader();
    reader.onload = e => {
      this._processBase64(e.target.result, resolve, reject);
    };
    reader.onerror = () => reject(new Error('文件读取失败'));
    reader.readAsDataURL(file);
  }

  /**
   * 处理base64字符串
   * @private
   */
  _processBase64(base64, resolve, reject) {
    const img = new Image();
    // 处理跨域图片
    img.crossOrigin = 'anonymous';
    img.onload = () => {
      this._processImageElement(img, resolve, reject);
    };
    img.onerror = () => reject(new Error('图片加载失败'));
    img.src = base64;
  }

  /**
   * 处理Image元素
   * @private
   */
  _processImageElement(img, resolve) {
    // 创建Canvas元素
    const canvas = document.createElement('canvas');
    const ctx = canvas.getContext('2d');

    // 计算处理后的图片尺寸（保持比例）
    const { width, height } = this._calculateDimensions(img);
    canvas.width = width;
    canvas.height = height;

    // 绘制原图
    ctx.drawImage(img, 0, 0, width, height);

    // 绘制水印
    this._drawWatermark(ctx, width, height);

    // 转换为base64并返回
    resolve(canvas.toDataURL('image/png'));
  }

  /**
   * 计算处理后的图片尺寸
   * @private
   */
  _calculateDimensions(img) {
    let { width, height } = img;
    const { maxWidth, maxHeight } = this.options;

    // 计算缩放比例
    if (width > maxWidth) {
      const ratio = maxWidth / width;
      width = maxWidth;
      height = height * ratio;
    }

    if (height > maxHeight) {
      const ratio = maxHeight / height;
      height = maxHeight;
      width = width * ratio;
    }

    return { width, height };
  }

  /**
   * 绘制水印
   * @private
   */
  _drawWatermark(ctx, canvasWidth, canvasHeight) {
    const { text, color, opacity, size, position, font } = this.options;

    // 设置水印样式
    ctx.fillStyle = color;
    ctx.globalAlpha = opacity;
    ctx.font = `200 ${size}px ${font}`;
    ctx.textBaseline = 'middle';

    const textWidth = ctx.measureText(text).width;
    const textHeight = size;
    const padding = 20; // 边距

    // 根据位置绘制水印
    switch (position) {
      case 'top-left':
        ctx.fillText(text, padding, padding + textHeight / 2);
        break;
      case 'top-right':
        ctx.fillText(
          text,
          canvasWidth - textWidth - padding,
          padding + textHeight / 2
        );
        break;
      case 'bottom-left':
        ctx.fillText(text, padding, canvasHeight - padding - textHeight / 2);
        break;
      case 'bottom-right':
        ctx.fillText(
          text,
          canvasWidth - textWidth - padding,
          canvasHeight - padding - textHeight / 2
        );
        break;
      case 'center':
        ctx.fillText(text, (canvasWidth - textWidth) / 2, canvasHeight / 2);
        break;
      case 'tiled':
        this._drawTiledWatermark(
          ctx,
          canvasWidth,
          canvasHeight,
          text,
          textWidth,
          textHeight
        );
        break;
    }
  }

  /**
   * 绘制平铺水印
   * @private
   */
  _drawTiledWatermark(
    ctx,
    canvasWidth,
    canvasHeight,
    text,
    textWidth,
    textHeight
  ) {
    // 旋转角度（30度）
    const rotation = Math.PI / 6;

    /**
     * 计算旋转后水印的实际占用尺寸（用于平铺间隔）
     * 水平方向最大宽度 = 原宽度 ×cosθ + 原高度 ×sinθ
     * 垂直方向最大高度 = 原宽度 ×sinθ + 原高度 ×cosθ
     */
    const tileWidth =
      textWidth * Math.cos(rotation) + textHeight * Math.sin(rotation);
    const tileHeight =
      textWidth * Math.sin(rotation) + textHeight * Math.cos(rotation) - 10;

    // 计算平铺间隔（在实际尺寸基础上增加一些间距）
    const gapX = tileWidth * 1.2; // 1.2倍间距，可调整
    const gapY = tileHeight * 1.2;

    // 计算起始偏移量（让水印从画布外开始，避免边缘空白）
    const startX = -gapX / 2;
    const startY = -gapY / 2;

    // 计算需要平铺的列数和行数（覆盖整个画布及边缘外一点）
    const cols = Math.ceil((canvasWidth + gapX) / gapX);
    const rows = Math.ceil((canvasHeight + gapY) / gapY);

    // 循环绘制水印（以中心为基准点）
    for (let row = 0; row < rows; row++) {
      for (let col = 0; col < cols; col++) {
        // 计算当前水印中心的坐标
        const centerX = startX + col * gapX;
        const centerY = startY + row * gapY;

        // 保存当前状态
        ctx.save();

        // 平移到水印中心
        ctx.translate(centerX, centerY);

        // 旋转
        ctx.rotate(rotation);

        // 绘制文字（此时(0,0)是水印中心）
        ctx.fillText(text, 0, 0);

        // 恢复状态
        ctx.restore();
      }
    }
  }

  /**
   * 将base64转换为File对象
   * @param {string} base64 - 图片base64字符串
   * @param {string} filename - 文件名
   * @returns {File} - File对象
   */
  base64ToFile(base64, filename = 'watermarked-image.png') {
    const arr = base64.split(',');
    const mime = arr[0].match(/:(.*?);/)[1];
    const bstr = atob(arr[1]);
    let n = bstr.length;
    const u8arr = new Uint8Array(n);

    while (n--) {
      u8arr[n] = bstr.charCodeAt(n);
    }

    return new File([u8arr], filename, { type: mime });
  }
}

// 导出默认实例和类，方便不同方式使用
export const watermarkProcessor = new WatermarkProcessor();
export default WatermarkProcessor;
