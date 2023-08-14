const toolbarConfig = {
    // 插入配置
    insertKeys: {
        index: 30, // 插入的位置，基于当前的 toolbarKeys
        keys: ['preview']
    },
    // 移除相关配置
    excludeKeys: [
        'blockquote', // 引用
        'codeBlock' // 代码块
    ]
}
// 只支持配置一次和插入一次，再多的配置，请重新分配工具栏配置
/**
 * insertKeys 不支持 array，菜单排列不灵活 #4305
 * https://github.com/wangeditor-team/wangEditor/issues/4305
 */
toolbarConfig.insertKeys = {
    index: 11,
    keys: ['fontSize','fontFamily','lineHeight','emotion']
}
export default toolbarConfig