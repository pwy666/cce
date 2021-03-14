<template>
  <div id="app" class="mainBg">
    <!-- <vue-scroll
      :ops="ops"
      style="height:100vh"
      @handle-scroll="handleScroll"
      ref="vs"
      v-loading="isLoading"
    > -->

    <app-header @show="show = !show"></app-header>
    <van-popup
      v-model="show"
      position="right"
      :style="{ height: '100%', width: '40%' }"
    >
      <ul class="nav">
        <li
          v-for="(item, key) in navArr"
          :key="key"
          class="center font-Seven"
          :class="key == index ? 'Wcolor redBg' : 'titleColor'"
          @click="toJup(key, item.link)"
        >
          {{ item.title }}
        </li>
      </ul></van-popup
    >
    <router-view />
    <!-- </vue-scroll> -->
  </div>
</template>
<script>
import { mapState } from 'vuex';

export default {
  name: 'App',

  data() {
    return {
      ops: {
        vuescroll: {
          mode: 'native',
          sizeStrategy: 'percent',
          detectResize: true,
        },
        scrollPanel: {
          initialScrollY: false,
          initialScrollX: false,
          scrollingX: false,
          scrollingY: true,
          speed: 300,
          easing: undefined,
          verticalNativeBarPos: 'right',
        },
        rail: {
          background: 'transparent',
          opacity: 0,
          size: '6px',
          specifyBorderRadius: false,
          gutterOfEnds: null,
          gutterOfSide: '2px',
          keepShow: false,
        },
        bar: {
          showDelay: 500,
          onlyShowBarOnScroll: true,
          keepShow: false,
          background: 'transparent',
          opacity: 1,
          hoverStyle: false,
          specifyBorderRadius: false,
          minSize: false,
          size: '6px',
          disable: false,
        },
      },
      navArr: [
        {
          title: '流动挖矿',
          link: '/',
        },
        {
          title: 'CCE理财',
          link: '/financial',
        },
        {
          title: 'IPFS矿池',
          link: '/mining',
        },
        {
          title: '闪兑',
          link: '/exchange',
        },
        {
          title: '收益明细',
          link: '/profit',
        },
        {
          title: '矿池管理',
          link: '/pool',
        },
        {
          title: '邀请好友',
          link: '/invite',
        },
      ],
      show: false,
      index: 0,
    };
  },
  computed: {
    path() {
      return this.$route.path;
    },
    ...mapState(['isLoading']),
  },
  // watch: {
  //   path() {
  //     this.$refs.vs.scrollTo({
  //       x: 0,
  //       y: 0,
  //     });
  //   },
  // },
  methods: {
    toJup(index, link) {
      if (this.path == link) {
        this.show = !this.show;
        return;
      }
      this.index = index;
      this.show = !this.show;
      this.$router.push(link);
    },
  },
  created() {},
};
</script>
<style lang="scss">
#app {
  font-family: 'Avenir', Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  color: #2c3e50;
  min-height: 100vh;
}
.nav li {
  height: 55px;
  line-height: 55px;
  transition: ease-in-out 0.1s;
}
</style>
