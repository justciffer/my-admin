/* eslint-disable */
import axios from 'axios';
import env from '../../build/env';
import semver from 'semver';
import packjson from '../../package.json';
import Main from '@/views/Main.vue';

let util = {

};
util.title = function (title) {
    title = title || '后台管理系统';
    window.document.title = title;
};

const ajaxUrl = env === 'development'
    ? 'http://localhost:8360/'
    : env === 'production'
        ? 'https://demo.housailei.info/'
        : 'https://demo.housailei.info/';
        
window.UPLOAD_IMG_URL='http://p2fovavhn.bkt.clouddn.com/';

util.ajax = axios.create({
    baseURL: ajaxUrl,
    timeout: 30000,
});

util.post = function (vm,url, param,cb) {
    let axiosIns = axios.create({
        baseURL: ajaxUrl,
        timeout: 30000,
        headers: {"Content-Type": "application/json",
                  "x-token":localStorage.getItem('token')
        }
    });
    axiosIns.post(url, param ).then( res => {  
        console.log(res.data);
        vm.loading =false; 
        if(res&&res.status==200&&res.data&&res.data.errno==0){
            cb(res.data.data);
        }else{
            vm.$Message.destroy();
            util.changeModalLoading(vm);
            if(res.data&&res.data.errmsg&&res.data.errmsg.length>0){
                vm.$Message.error(res.data.errmsg);
            }else{
                vm.$Message.error('请求数据异常，请稍后重试！');
            }           
        }
        
        
    }).catch(err => {
        console.log(err);
        vm.$Message.destroy();
        util.changeModalLoading(vm);
        vm.$Message.error('请求数据异常，请稍后重试！');
    })
};

util.imageUpload = function (vm,file,cb) {
    vm.$Notice.info({title:'图片上传中，请耐心等待...',duration:0})
    var formData = new FormData();
    formData.append('file', file);
    util.post(vm,'admin/common/uploadToken',{},function(datas){ 
        formData.append('token', datas.token);
        axios({
           url: 'http://up.qiniu.com',
           method: 'POST',
           data: formData
        })
        .then((result) => {
            vm.$Notice.destroy();
            cb(result.data.key);
        })           
        .catch((err) => {
            console.log(err);
            vm.$Notice.destroy();
            vm.$Notice.error({title:'上传图片出错，请重试！',duration:2});
        })                         
    });
};

      

util.changeModalLoading=function (vm , flag) {
    if(flag){
        vm.modalLoading = true;
        vm.modalCanBut = false;
    }else{
        vm.modalLoading = false;
        vm.modalCanBut = true;
        vm.loading = false;
    }
    
};

util.copy=function (datas) {
    let obj={};  
    obj=JSON.parse(JSON.stringify(datas));
    return obj    
};

util.showDictLabel=function (type,value) {
    let dicts=localStorage.getItem('dicts');
    if(dicts){
        dicts=JSON.parse(dicts);
        if(dicts&&dicts[type]&&dicts[type][value]){
            return dicts[type][value]; 
        }
    }
    return '-';     
};

util.showDictList=function (type) {
    let list=[];  
    let dicts=localStorage.getItem('dicts');
    if(dicts){
        dicts=JSON.parse(dicts);
        if(dicts&&dicts[type]){
            let obj=dicts[type];
            for(var key in obj){
                list.push({value:key,label:obj[key]});
            }
        }   
    } 
    return list    
};

util.inOf = function (arr, targetArr) {
    let res = true;
    arr.forEach(item => {
        if (targetArr.indexOf(item) < 0) {
            res = false;
        }
    });
    return res;
};

util.oneOf = function (ele, targetArr) {
    if (targetArr.indexOf(ele) >= 0) {
        return true;
    } else {
        return false;
    }
};

util.showThisRoute = function (itAccess, currentAccess) {
    if (typeof itAccess === 'object' && Array.isArray(itAccess)) {
        return util.oneOf(currentAccess, itAccess);
    } else {
        return itAccess === currentAccess;
    }
};

util.getRouterObjByName = function (routers, name) {
    if (!name || !routers || !routers.length) {
        return null;
    }
    // debugger;
    let routerObj = null;
    for (let item of routers) {
        if (item.name === name) {
            return item;
        }
        routerObj = util.getRouterObjByName(item.children, name);
        if (routerObj) {
            return routerObj;
        }
    }
    return null;
};

util.handleTitle = function (vm, item) {
    if (typeof item.title === 'object') {
        return vm.$t(item.title.i18n);
    } else {
        return item.title;
    }
};

util.setCurrentPath = function (vm, name) {
    let title = '';
    let isOtherRouter = false;
    vm.$store.state.app.routers.forEach(item => {
        if (item.children.length === 1) {
            if (item.children[0].name === name) {
                title = util.handleTitle(vm, item);
                if (item.name === 'otherRouter') {
                    isOtherRouter = true;
                }
            }
        } else {
            item.children.forEach(child => {
                if (child.name === name) {
                    title = util.handleTitle(vm, child);
                    if (item.name === 'otherRouter') {
                        isOtherRouter = true;
                    }
                }
            });
        }
    });
    let currentPathArr = [];
    if (name === 'home_index') {
        currentPathArr = [
            {
                title: util.handleTitle(vm, util.getRouterObjByName(vm.$store.state.app.routers, 'home_index')),
                path: '',
                name: 'home_index'
            }
        ];
    } else if ((name.indexOf('_index') >= 0 || isOtherRouter) && name !== 'home_index') {
        currentPathArr = [
            {
                title: util.handleTitle(vm, util.getRouterObjByName(vm.$store.state.app.routers, 'home_index')),
                path: '/home',
                name: 'home_index'
            },
            {
                title: title,
                path: '',
                name: name
            }
        ];
    } else {
        let currentPathObj = vm.$store.state.app.routers.filter(item => {
            if (item.children.length <= 1) {
                return item.children[0].name === name;
            } else {
                let i = 0;
                let childArr = item.children;
                let len = childArr.length;
                while (i < len) {
                    if (childArr[i].name === name) {
                        return true;
                    }
                    i++;
                }
                return false;
            }
        })[0];
        if (currentPathObj.children.length <= 1 && currentPathObj.name === 'home') {
            currentPathArr = [
                {
                    title: '首页',
                    path: '',
                    name: 'home_index'
                }
            ];
        } else if (currentPathObj.children.length <= 1 &&!currentPathObj.children[0].icon&& currentPathObj.name !== 'home') {
            currentPathArr = [
                {
                    title: '首页',
                    path: '/home',
                    name: 'home_index'
                },
                {
                    title: currentPathObj.title,
                    path: '',
                    name: name
                }
            ];
        } else {
            let childObj = currentPathObj.children.filter((child) => {
                return child.name === name;
            })[0];
            currentPathArr = [
                {
                    title: '首页',
                    path: '/home',
                    name: 'home_index'
                },
                {
                    title: currentPathObj.title,
                    path: '',
                    name: currentPathObj.name
                },
                {
                    title: childObj.title,
                    path: currentPathObj.path + '/' + childObj.path,
                    name: name
                }
            ];
        }
    }
    vm.$store.commit('setCurrentPath', currentPathArr);

    return currentPathArr;
};

util.openNewPage = function (vm, name, argu, query) {
    let pageOpenedList = vm.$store.state.app.pageOpenedList;
    let openedPageLen = pageOpenedList.length;
    let i = 0;
    let tagHasOpened = false;
    while (i < openedPageLen) {
        if (name === pageOpenedList[i].name) { // 页面已经打开
            vm.$store.commit('pageOpenedList', {
                index: i,
                argu: argu,
                query: query
            });
            tagHasOpened = true;
            break;
        }
        i++;
    }
    if (!tagHasOpened) {
        let tag = vm.$store.state.app.tagsList.filter((item) => {
            if (item.children) {
                return name === item.children[0].name;
            } else {
                return name === item.name;
            }
        });
        tag = tag[0];
        if (tag) {
            tag = tag.children ? tag.children[0] : tag;
            if (argu) {
                tag.argu = argu;
            }
            if (query) {
                tag.query = query;
            }
            vm.$store.commit('increateTag', tag);
        }
    }
    vm.$store.commit('setCurrentPageName', name);
};

util.toDefaultPage = function (routers, name, route, next) {
    let len = routers.length;
    let i = 0;
    let notHandle = true;
    while (i < len) {
        if (routers[i].name === name && routers[i].children && routers[i].redirect === undefined) {
            route.replace({
                name: routers[i].children[0].name
            });
            notHandle = false;
            next();
            break;
        }
        i++;
    }
    if (notHandle) {
        next();
    }
};

util.fullscreenEvent = function (vm) {
    vm.$store.commit('initCachepage');
    // 权限菜单过滤相关
    vm.$store.commit('updateMenulist');
    // 全屏相关
};


// 时间格式化
util.formatDate = function (date, fmt) {
    let o = {
        'M+': date.getMonth() + 1, // 月份
        'd+': date.getDate(), // 日
        'h+': date.getHours(), // 小时
        'm+': date.getMinutes(), // 分
        's+': date.getSeconds(), // 秒
        'S': date.getMilliseconds() // 毫秒
    }
    if (/(y+)/.test(fmt)) {
        fmt = fmt.replace(RegExp.$1, (date.getFullYear() + '').substr(4 - RegExp.$1.length))
    }
    for (var k in o) {
        if (new RegExp('(' + k + ')').test(fmt)) {
            fmt = fmt.replace(RegExp.$1, (RegExp.$1.length === 1) ? (o[k]) : (('00' + o[k]).substr(('' + o[k]).length)))
        }
    }
    return fmt
}

util.checkUpdate = function (vm) {
    axios.get('https://api.github.com/repos/iview/iview-admin/releases/latest').then(res => {
        let version = res.data.tag_name;
        vm.$Notice.config({
            duration: 0
        });
        if (semver.lt(packjson.version, version)) {
            vm.$Notice.info({
                title: 'iview-admin更新啦',
                desc: '<p>iView-admin更新到了' + version + '了，去看看有哪些变化吧</p><a style="font-size:13px;" href="https://github.com/iview/iview-admin/releases" target="_blank">前往github查看</a>'
            });
        }
    });
};


util.reloadMenu=function(list){
    let _menuList = [];
    list.forEach((item, index) => {              
        if (!item.children||item.children.length == 0) {
            let _item={};
            _item.path='/'+item.name;
            _item.icon=item.icon;
            _item.name=item.name;
            _item.title=item.title;
            _item.component=Main;
            _item.children=[{
                path: 'index',
                name: item.name+'_index',
                title: item.title,
                component: resolve => { require(['@/views/'+item.href+'.vue'], resolve); }
            }];
            _menuList.push(_item);
        } else {
            let _item={};
            _item.path='/'+item.name;
            _item.icon=item.icon;
            _item.name=item.name;
            _item.title=item.title;
            _item.component=Main;
            _item.children=[];
            item.children.forEach((item2, index) => {                        
                _item.children.push({
                    path: item2.name,
                    icon: item2.icon,
                    name: item2.name,
                    title: item2.title,
                    component: resolve => { require(['@/views/'+item2.href+'.vue'], resolve); }
                });
            });                 
            _menuList.push(_item);
        }
    });
    console.log(_menuList);
    return _menuList;
};

export default util;
