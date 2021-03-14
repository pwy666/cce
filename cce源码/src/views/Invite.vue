<template>
  <div class="invite padding">
    <div class="font-Tt Wcolor invite-title">邀请好友</div>

    <!-- 二维码 -->
    <ul class="border radius headerBg invite-main allFlex column">
      <li class="Wcolor font-Eight">邀请二维码</li>

      <li id="code">
        <vue-qr :text="shareAddress" :size="size"></vue-qr>
      </li>

      <li
        class="invite-btn border center PFcolor font-Five"
        v-clipboard:copy="shareAddress"
        v-clipboard:success="onCopy"
      >
        复制链接
      </li>
    </ul>
  </div>
</template>
<script>
import VueQr from 'vue-qr';
import Global from '../api';
export default {
  data() {
    return {
      address: '',
      size: 138,
      host: '',
    };
  },
  computed: {
    shareAddress() {
      return this.host + '?tgm=' + this.address;
    },
  },
  components: { VueQr },
  methods: {
    async getralation() {
      let res = await getralationFn(1);
      console.log(res);
      if (res) {
        this.address = res[0];
      }
    },
    onCopy() {
      this.$toast('复制成功');
    },
  },
  created() {
    let index = window.location.href.indexOf('#');
    this.host = window.location.href.slice(0, index + 2);
  },
  mounted() {
    Global.contract().then((res) => {
      this.address = window.tronWeb.defaultAddress.base58;
      console.log(this.address);
    });
  },
};
</script>
<style scoped lang="scss">
.invite-title {
  margin: 10px 0;
}

.invite-main {
  height: 330px;
  padding: 25px 10px;
  align-items: center;
}

#code {
  width: 138px;
  height: 138px;
}

.invite-btn {
  width: 130px;
  height: 40px;
  line-height: 40px;
  background: #363847;
  border-radius: 20px;
}
</style>
