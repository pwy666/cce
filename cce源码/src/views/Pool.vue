<template>
  <div class="pool padding">
    <div class="font-Tt Wcolor pool-title">收益</div>

    <!-- 矿池 -->
    <ul class="pool-main">
      <li class="titleNav redBg Wcolor font-Eight padding">矿池3</li>
      <li class="boxBg padding allFlex">
        <div class="center">
          <span class="font-Four textColor "> 矿池总算力（USDT）</span>
          <span class="font-Eight Wcolor main-value">{{ obj.value1 }}</span>
        </div>

        <div class="center">
          <span class="font-Four textColor"> 团队贡献值（USDT）</span>
          <span class="font-Eight Wcolor main-value">{{ obj.value2 }}</span>
        </div>
      </li>
    </ul>

    <!-- 邀请 -->
    <div class="font-Tt Wcolor pool-title">邀请列表</div>

    <ul class="pool-list">
      <li
        class="boxBg border radius textColor allFlex center padding"
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
import { getralationFn, getrankingFn } from '@/api/axios';

export default {
  data() {
    return {
      obj: {
        value1: '',
        value2: '',
      },
      list: [],
    };
  },
  methods: {
    async getranking() {
      let res = await getrankingFn(1);
      console.log(res);
      if (res) {
        this.obj.value1 = Number(
          Global.numberUtil(res._total_usdt_num, 6)
        ).toFixed(2);
        this.obj.value2 = Number(
          Global.numberUtil(res._pool_achievement, 6)
        ).toFixed(2);
      }
    },
    async getralation() {
      let res = await getralationFn(1);
      console.log(res);
      if (res) {
        this.list = res[1];
      }
    },
  },
  created() {},
  mounted() {
    Global.contract().then((res) => {
      this.getranking();
      this.getralation();
    });
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
