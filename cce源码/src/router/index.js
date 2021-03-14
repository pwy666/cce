import Vue from 'vue';
import VueRouter from 'vue-router';
import Home from '../views/Home.vue';
import financial from '../views/financial.vue';
import mining from '../views/mining.vue';
import exchange from '../views/exchange.vue';

Vue.use(VueRouter);

const routes = [
  {
    path: '/',
    name: 'home',
    component: Home,

    meta: {
      title: 'CCE',
      position: 'fixed',
      requireAuth: false,
      footer: true,
      hea: true,
    },
  },

  // 收益明细
  {
    path: '/profit',
    name: 'profit',
    component: (resolve) => require(['@/views/Profit'], resolve),
    meta: {
      title: 'CCE',
      position: 'fixed',
      requireAuth: false,
      footer: true,
      hea: true,
    },
  },

  //邀请好友
  {
    path: '/invite',
    name: 'invite',
    component: (resolve) => require(['@/views/Invite'], resolve),
    meta: {
      title: 'CCE',
      position: 'fixed',
      requireAuth: false,
      footer: true,
      hea: true,
    },
  },

  //矿池
  {
    path: '/pool',
    name: 'pool',
    component: (resolve) => require(['@/views/Pool'], resolve),
    meta: {
      title: 'CCE',
      position: 'fixed',
      requireAuth: false,
      footer: true,
      hea: true,
    },
  },

  {
    path: '/financial',
    name: 'financial',
    component: financial,

    meta: {
      title: 'CCE',
      position: 'fixed',
      requireAuth: false,
      footer: true,
      hea: true,
    },
  },

  {
    path: '/mining',
    name: 'mining',
    component: mining,

    meta: {
      title: 'CCE',
      position: 'fixed',
      requireAuth: false,
      footer: true,
      hea: true,
    },
  },

  {
    path: '/exchange',
    name: 'exchange',
    component: exchange,

    meta: {
      title: 'CCE',
      position: 'fixed',
      requireAuth: false,
      footer: true,
      hea: true,
    },
  }
];

const router = new VueRouter({
  mode: 'hash',
  base: process.env.BASE_URL,
  routes,
});

export default router;
