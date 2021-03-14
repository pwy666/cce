<template>
  <div class="mining allFlex column">
    <h2 class="allTitle">IPFS矿池</h2>
    <div class="pool">
      <!--      <div class="top allFlex">-->
      <!--        <span class="Wcolor font-Eight">算力池3</span>-->
      <!--        <span class="Pcolor five-Eight">细则说明</span>-->
      <!--        <img src="../assets/img/icon_wfsm.png">-->
      <!--      </div>-->
      <div class="bottom allFlex ztBj">
        <img src="../assets/img/icon_cce.png" />
        <ul class="allFlex column ">
          <li class="Wcolor">CCE</li>
          <li class="textColor">Cancrie</li>
        </ul>
        <ul class="allFlex column">
          <li class="Wcolor">{{ balanceObj.cce }}</li>
          <li class="textColor">钱包余额</li>
        </ul>
      </div>
    </div>
    <!--    参与    -->
    <div class="join allFlex column ztBj">
      <p>已购买算力（T）</p>
      <div class="Wcolor font-Eight">{{ userpower }}</div>
      <div class="input">
        <input type="text" v-model="buyNumber" class="Wcolor" />
        <div class="right allFlex centerAll">
          <span class="blueColor" @click="all">全部</span>
          <div></div>
          <span class="Wcolor Bold">T</span>
        </div>
      </div>
      <div class="allFlex ts">
        <span
          >可购买
          {{
            (
              Math.floor((this.balanceObj.cce / this.powerprice) * 10000) /
              10000
            ).toFixed(4)
          }}T</span
        ><span class="Wcolor">算力价格：{{ powerprice }}cce/1T</span>
      </div>
      <p class="textColor">
        需支付：{{ (buyNumber * powerprice).toFixed(4) }} CCE
      </p>
      <div class="btn  font-Five center Wcolor" @click="toBuy">立即购买</div>
    </div>
    <!-- 购买记录 -->
    <div class="padding titleNav record-title  allFlex">
      <span class="font-Eight Wcolor">购买记录</span>
    </div>

    <!-- 记录 -->
    <ul class="record-ul">
      <li
        v-for="(item, key) in recordArr"
        :key="'record' + key"
        class="allFlex   ztBj"
        :class="key !== 0 && 'li'"
      >
        <div class="allFlex column">
          <span class="Wcolor font-Six">购买算力</span>
          <span class="textColor font-Four">{{ item.time | formatDates }}</span>
        </div>

        <span class="font-Eight blueColor">+{{ item.number }} T</span>
      </li>
    </ul>
  </div>
</template>

<script>
import {
  buypowerFn,
  getpowerrecFn,
  getPriceFn,
  getrankingFn,
  userbalanceFn,
  ipfspoolPage,
} from '@/api/axios';
import Global from '@/api';

export default {
  name: 'mining',
  data() {
    return {
      type: 1,
      recordArr: [],
      balanceObj: {
        cce: 0,
        usdt: 0,
      },
      userpower: 0,
      powerprice: 0,
      buyNumber: '',
      timer: '',
    };
  },
  watch: {
    buyNumber(val) {
      let max = (
        Math.floor((this.balanceObj.cce / this.powerprice) * 10000) / 10000
      ).toFixed(4);
      if (Number(val) > Number(max)) {
        this.buyNumber = max;
        return;
      }
      if (val > 0 && val.toString().split('.').length > 1) {
        if (val.toString().split('.')[1].length > 4) {
          this.buyNumber = Number(val).toFixed(4);
        }
      }
    },
  },
  mounted() {
    Global.contract().then((res) => {
      this.init();
      this.timer = setInterval(() => {
        this.init();
      }, 10000);
      this.getBalance();
      this.getranking();
    });
  },
  methods: {
    async init() {
      let res = await ipfspoolPage();
      this.getpowerrec(res);
      this.getPrice(res);
      this.balanceObj.cce = (
        Math.floor(Number(Global.numberUtil(res.walletcce, 6)) * 10000) / 10000
      ).toFixed(4);
    },
    async toBuy() {
      let res = await buypowerFn(0, Number(this.buyNumber) * 1000000);
      if (res) {
        this.$toast('购买成功');
      }
    },
    getpowerrec(res) {
      if (res) {
        let obj = [];
        res.number.forEach((itme, key) => {
          obj.push({
            ccenumber: Number(Global.numberUtil(res.ccenumber[key], 6)).toFixed(
              4
            ),
            number: Number(Global.numberUtil(res.number[key], 6)).toFixed(4),
            time: Number(Global.toBigNumber(res.time[key])),
          });
        });
        this.recordArr = obj;
      }
    },
    all() {
      this.buyNumber = (
        Math.floor((this.balanceObj.cce / this.powerprice) * 10000) / 10000
      ).toFixed(4);
    },
    getPrice(res) {
      if (res) {
        this.powerprice = Number(Global.numberUtil(res.powerprice, 6));
      }
    },
    async getranking() {
      let res = await getrankingFn(1);
      if (res) {
        this.userpower = Number(Global.numberUtil(res._userpower, 6)).toFixed(
          4
        );
      }
    },
    async getBalance() {
      let res = await userbalanceFn(1);
      if (res) {
        this.balanceObj.usdt = (
          Math.floor(Number(Global.numberUtil(res.usdtbal, 6)) * 10000) / 10000
        ).toFixed(4);
      }
    },
  },
  beforeDestroy() {
    const _this = this;
    clearInterval(_this.timer);
  },
};
</script>

<style scoped="scoped" lang="scss">
@import '../assets/css/mining.scss';
</style>
