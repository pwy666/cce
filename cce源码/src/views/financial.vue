<template>
  <div class="financial allFlex column">
    <h2 class="allTitle">CCE理财</h2>
    <div class="pool">
      <div class="top allFlex">
        <span class="titleColor font-Eight">CCE理财</span>
        <span class="titleColor five-Eight">细则说明</span>
        <img src="../assets/img/icon_wfsm2.png" />
      </div>
      <div class="bottom allFlex boxBg">
        <img src="../assets/img/icon_cce.png" />
        <ul class="allFlex column ">
          <li class="Wcolor">CCE</li>
          <li class="textColor">Cancrie</li>
        </ul>
        <ul class="allFlex column">
          <li class="Wcolor">{{ balanceObj.cce }}</li>
          <li class="textColor">可用余额</li>
        </ul>
        <!--        <div class="btn GFcolor font-Five center">存入</div>-->
      </div>
    </div>
    <!--    参与    -->
    <div class="join allFlex column boxBg">
      <p>日利率</p>
      <div class="Wcolor font-Eight">{{ rate }}%</div>
      <input type="number" v-model="joinNumber" />
      <div class="btn titleColor font-Five center" @click="join">立即参与</div>
    </div>
    <div class="minings">
      <div
        class="mining allFlex column"
        v-for="(item, key) in recordArr"
        :key="key"
      >
        <div class="top allFlex">
          <div class="Wcolor center">{{ key + 1 }}</div>
          <p class="title Wcolor font-Six">CCE理财</p>
          <p>{{ item.time | formatDates }}</p>
        </div>
        <ul class="allFlex">
          <li class="allFlex column">
            <p>参与数量(CCE)</p>
            <p class="Wcolor center">{{ item.number }}</p>
          </li>
          <li class="allFlex column">
            <p>累计收益(USDT)</p>
            <p class="Wcolor center">{{ item.profit }}</p>
          </li>
        </ul>
        <div class="allFlex btns">
          <div class="font-Five center PFcolor" @click="out(item.id)">
            取出本息
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import {
  getjoinrecFn,
  getrateFn,
  joinFn,
  outFn,
  userbalanceFn,
} from '@/api/axios';
import Global from '@/api';

export default {
  name: 'financial',
  data() {
    return {
      balanceObj: {
        cce: '',
      },
      joinNumber: '',
      timer: '',
      recordArr: [],
      rate: 0,
    };
  },
  watch: {
    joinNumber(val) {
      let max = this.balanceObj.cce;
      if (Number(val) > Number(max)) {
        this.joinNumber = max;
        return;
      }
      if (val > 0 && val.toString().split('.').length > 1) {
        if (val.toString().split('.')[1].length > 4) {
          this.joinNumber = (Math.floor(Number(val) * 10000) / 10000).toFixed(
            4
          );
        }
      }
    },
  },
  mounted() {
    Global.contract().then((res) => {
      this.getBalance();
      this.getjoinrec();
      this.getrate();
      this.timer = setInterval(() => {
        this.getBalance();
        this.getjoinrec();
      }, 3000);
    });
  },
  methods: {
    async getBalance() {
      let res = await userbalanceFn(1);
      if (res) {
        // console.log(res)
        this.balanceObj.cce = (
          Math.floor(Number(Global.numberUtil(res.ccebal, 6)) * 10000) / 10000
        ).toFixed(4);
      }
    },
    async getrate() {
      let res = await getrateFn(0);
      if (res) {
        this.rate = (
          Math.floor(Number(Global.numberUtil(res._rate, 1)) * 10) / 10
        ).toFixed(1);
      }
    },
    async join() {
      let res = await joinFn(0, Number(this.joinNumber) * 1000000);
      if (res) {
        this.$toast('参与成功');
      }
    },
    async out(id) {
      let res = await outFn(0, id);
      if (res) {
        this.$toast('取出成功');
      }
    },
    async getjoinrec() {
      let res = await getjoinrecFn(1);
      console.log(res);
      if (res) {
        let obj = [];
        res.id.forEach((itme, key) => {
          // console.log(res.status[key])
          if (res.status[key]) {
            obj.push({
              id: Number(Global.toBigNumber(res.id[key])),
              number: Number(Global.numberUtil(res.number[key], 6)).toFixed(2),
              profit: Number(Global.numberUtil(res.profit[key], 6)).toFixed(2),
              time: Number(Global.toBigNumber(res.time[key])),
            });
          }
          this.recordArr = obj;
        });
      }
    },
  },
  beforeDestroy() {
    const _this = this;
    clearInterval(_this.timer);
  },
};
</script>

<style scoped lang="scss">
@import '../assets/css/financial.scss';
</style>
