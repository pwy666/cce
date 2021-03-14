import Vue from 'vue';
import ElementUI, { Message } from 'element-ui';
import vuescroll from 'vuescroll/dist/vuescroll-native';
import VueClipboard from 'vue-clipboard2';
import App from './App.vue';
import router from './router';
import i18n from './i18n/i18n';
import 'element-ui/lib/theme-chalk/index.css';
import { Popup } from 'vant';
import 'amfe-flexible';
import 'vant/lib/index.css';
import { Toast } from 'vant';

// 组件
import AppHeader from './components/appHeader';
// import AppFooter from './components/appFooter';
import store from '@/store';

// 公共样式
import './assets/css/common.css';

import { bus } from './bus';
import 'vuescroll/dist/vuescroll.css';
Vue.prototype.$message = Message;

const showMessage = Symbol('showMessage');

let messageInstance = null;
class DonMessage {
  success(options, single = true) {
    this[showMessage]('success', options, single);
  }

  warning(options, single = true) {
    this[showMessage]('warning', options, single);
  }

  info(options, single = true) {
    this[showMessage]('info', options, single);
  }

  error(options, single = true) {
    this[showMessage]('error', options, single);
  }

  [showMessage](type, options, single) {
    if (messageInstance && single) {
      messageInstance.close(); // 先把原来的关闭
    }
    messageInstance = Message[type](options); // 再创建新的消息
  }
}
Vue.prototype.$messageNew = new DonMessage();

Vue.config.productionTip = false;

Vue.prototype.$bus = bus;

Vue.filter("formatDates",(date)=>{
  const nDate=new Date(date*1000)
  const y = nDate.getFullYear()
  const m = (nDate.getMonth()+ 1 + '').padStart(2,'0')
  const d =(nDate.getDate() + '').padStart(2,'0')
  const hh =(nDate.getHours() + '').padStart(2,'0')
  const mm =(nDate.getMinutes() + '').padStart(2,'0')
  const ss =(nDate.getSeconds() + '').padStart(2,'0')
  return `${y}/${m}/${d} ${hh}:${mm}:${ss}`
})

// 全局组件
Vue.use(AppHeader);
// Vue.use(AppFooter);
Vue.use(VueClipboard);
Vue.use(Popup);


Vue.use(Toast);

// UI组件
Vue.use(ElementUI);
Vue.use(vuescroll);

router.beforeEach((to, from, next) => {
  document.title = to.meta.title;
  next();
});

new Vue({
  router,
  i18n,
  store,
  render: (h) => h(App),
}).$mount('#app');
