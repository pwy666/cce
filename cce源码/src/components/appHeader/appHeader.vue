<template>
  <div class="header allFlex padding headerBg">
    <div class="allFlex">
      <img
        src="@img/back-icon.png"
        alt=""
        class="left-icon"
        v-if="path !== '/'"
        @click="$router.go(-1)"
      />
      <img src="@img/icon_logo.png" alt="" class="logo" />
    </div>
    <img src="@img/icon_cd.png" alt="" class="more-icon" @click="toShow" />
  </div>
</template>
<script>
export default {
  name: 'appHeader',
  data() {
    return {
      navShow: false,
      leftArr: [
        {
          title: '',
          link: '/',
        },
      ],
      langArr: [
        {
          title: 'EN',
          command: 'EN',
          language: 'en',
        },
        {
          title: 'ZH',
          command: 'ZH',
          language: 'zh',
        },
      ],

      langKey: 1,
      language: 'ZH',
    };
  },
  props: {
    position: {
      type: String,
      default: 'relative',
    },
  },
  computed: {
    path() {
      return this.$route.path;
    },
  },
  watch: {},
  methods: {
    toShow() {
      this.$emit('show');
    },
  },
  mounted() {},
  created() {
    this.langKey = this.$i18n.locale === 'zh' ? 1 : 0;
    this.language = this.langArr[this.langKey].title;
  },
};
</script>
<style scoped="scoped" lang="scss">
.header {
  height: 55px;
  align-items: center;
  div {
    justify-content: flex-start;
    align-items: center;
  }
}
.left-icon {
  width: 9px;
  height: 16px;
  margin-right: 10px;
}
.logo {
  width: 92px;
  height: 39px;
}
.more-icon {
  width: 20px;
  height: 20px;
}
</style>
