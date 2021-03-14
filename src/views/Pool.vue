<template>
  <div class="pool padding">
    <div class="font-Tt Wcolor pool-title">收益</div>

    <!-- 矿池 -->
    <ul class="pool-main">
      <li class="titleNav titleBg Wcolor font-Eight padding">矿池3</li>
      <li class="ztBj padding allFlex">
        <div class="center">
          <span class="font-Four textColor "> 矿池总算力（USDT）</span>
          <span class="font-Eight blueColor main-value">{{ obj.value1 }}</span>
        </div>

        <div class="center">
          <span class="font-Four textColor"> 团队贡献值（USDT）</span>
          <span class="font-Eight blueColor main-value">{{ obj.value2 }}</span>
        </div>
      </li>
    </ul>

    <!-- 邀请 -->
    <div class="font-Tt Wcolor pool-title">邀请列表</div>

    <ul class="pool-list">
      <li
        class="ztBj  radius Wcolor allFlex center padding"
        v-for="(item, key) in list"
        :key="'list' + key"
      >
        {{ item }}
      </li>
    </ul>
  </div>
</template>
<script>
import Global from '@/api';
import { getralationFn, getrankingFn, pooladminPage } from '@/api/axios';

export default {
  data() {
    return {
      obj: {
        value1: '',
        value2: '',
      },
      list: [],
      timer: '',
    };
  },
  methods: {
    async init() {
      let res = await pooladminPage();
      this.getralation(res);
      this.getranking(res);
      console.log(res);
    },
    getranking(res) {
      if (res) {
        this.obj.value1 = Number(
          Global.numberUtil(res._total_usdt_num, 6)
        ).toFixed(2);
        this.obj.value2 = Number(
          Global.numberUtil(res._team_achievement, 6)
        ).toFixed(2);
      }
    },
    getralation(res) {
      if (res) {
        this.list = res.sons;
      }
    },
  },
  created() {},
  mounted() {
    Global.contract().then((res) => {
      this.init();
      this.timer = setInterval(() => {
        this.init();
      }, 10000);
      // this.getranking();
      // this.getralation();
    });
  },
  beforeDestroy() {
    const _this = this;
    clearInterval(_this.timer);
  },
};
</script>
<style scoped lang="scss">
.pool-title {
  margin: 10px 0;
}

.pool-main {
  li:last-child {
    height: 105px;
    border-radius: 0 0 10px 10px;
    align-items: center;
  }
  .main-value {
    margin-top: 10px;
  }
}

.pool-list li {
  align-items: center;
  justify-content: center;
  height: 50px;
  line-height: 50px;
  margin-top: 10px;
}
</style>
