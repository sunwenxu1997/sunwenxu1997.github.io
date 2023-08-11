const toolbarConfig = {
    // 插入配置
    insertKeys: {
        index: 20, // 插入的位置，基于当前的 toolbarKeys
        keys: ['emotion']
    },
    // 移除相关配置
    excludeKeys: [
        'blockquote', // 引用
        'codeBlock' // 代码块
    ]
}
toolbarConfig.insertKeys = {
    index: 30,
    keys: ['preview']
}
export default toolbarConfig