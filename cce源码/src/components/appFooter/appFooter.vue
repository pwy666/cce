<template>
  <div class="footer center">
    <ul class="footer-main cen allFlex footer-pc">
      <li class="font-Two footerColor2 hand">
        <img
          src="../../assets/img/telegram.png"
          alt=""
          @click="toLink('https://t.me/lebondfinance')"
        />
        <img
          src="../../assets/img/Twitter.png"
          alt=""
          @click="toLink('https://twitter.com/Lebond_Finance')"
        />
        <img
          src="../../assets/img/git.png"
          alt=""
          @click="toLink('https://beta.cent.co/LeBondFinance/')"
        />
        <img
          src="../../assets/img/github.png"
          alt=""
          @click="toLink('https://github.com/LeBondFinance')"
        />
      </li>
    </ul>
    <div class="footer-phone footerColor font-Two">
      © 2020 Le BOND. All rights reserved.
    </div>
  </div>
</template>

<script>
export default {
  name: 'appFooter',
  data() {
    return {};
  },
  methods: {
    toLink(url) {
      window.open(url);
    },
  },
};
</script>

<style scoped lang="scss">
@import './footer.scss';
.footerColor {
  color: #688b85;
}
.footer {
  background: #002325;
}
</style>
