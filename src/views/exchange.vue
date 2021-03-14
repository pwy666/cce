<template>
  <div class="exchange allFlex column">
    <h2 class="allTitle">闪兑</h2>
    <p class="ts Wcolor">一键即可兑换USDT</p>
    <div class="pool">
      <!--      <div class="top allFlex">-->
      <!--        <span class="Wcolor font-Eight">算力池3</span>-->
      <!--        <span class="Pcolor five-Eight">细则说明</span>-->
      <!--        <img src="../assets/img/icon_wfsm.png">-->
      <!--      </div>-->
      <div class="bottom allFlex ztBj Wcolor">
        <img src="../assets/img/icon_cce.png" v-if="type" />
        <img src="../assets/img/icon_usdt.png" v-if="!type" />
        <p>{{ type ? 'CCE' : 'USDT' }}</p>
        <img
          src="../assets/img/exchange.png"
          class="jh"
          @click="
            type = !type;
            buyNumber = 0;
          "
        />
        <img src="../assets/img/icon_cce.png" v-if="!type" />
        <img src="../assets/img/icon_usdt.png" v-if="type" />
        <p>{{ type ? 'USDT' : 'CCE' }}</p>
      </div>
    </div>
    <!--    参与    -->
    <div class="join allFlex column ztBj">
      <div class="allFlex ts">
        <span class="Wcolor">兑换的数量</span>
        <span class="blueColor" v-if="!type"
          >当前汇率：1 USDT={{ ccetousdt }} CCE</span
        >
        <span class="blueColor" v-if="type"
          >当前汇率：1 CCE={{ usdttocce }} USDT</span
        >
      </div>
      <div class="input">
        <input type="number" v-model="buyNumber" class="Wcolor" />
        <div class="right allFlex centerAll">
          <span class="blueColor" @click="all">全部</span>
          <div></div>
          <p class="Wcolor Bold">{{ type ? 'CCE' : 'USDT' }}</p>
        </div>
      </div>

      <p class="balance">
        可用余额：<span class="blueColor">{{
          type ? balanceObj.cce : balanceObj.usdt
        }}</span>
        {{ type ? 'CCE' : 'USDT' }}
      </p>
      <div class="btn Wcolor font-Five center" @click="flashcash">
        立即兑换
      </div>
    </div>
    <!-- 兑换记录 -->
    <div class="padding titleNav record-title  allFlex">
      <span class="font-Eight Wcolor">兑换记录</span>
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
          <span class="Wcolor font-Six"
            >兑换{{ item.type === 1 ? 'CCE' : 'USDT' }}</span
          >
          <span class="textColor font-Four">{{ item.time | formatDates }}</span>
        </div>

        <div class="allFlex column">
          <span class="font-Eight blueColor right"
            >+{{ item.type === 1 ? item.ccenumber : item.usdtnumber }}
            {{ item.type === 1 ? 'CCE' : 'USDT' }}</span
          >
          <span class="Wcolor font-Four right"
            >消耗{{ item.type === 1 ? item.usdtnumber : item.ccenumber
            }}{{ item.type === 0 ? 'CCE' : 'USDT' }}</span
          >
        </div>
      </li>
    </ul>
  </div>
</template>

<script>
import {
  flashcashFn,
  getflashcashrecFn,
  getPriceFn,
  getrankingFn,
  userbalanceFn,
  flashcashPage,
} from '@/api/axios';
import Global from '@/api';

export default {
  name: 'exchange',
  data() {
    return {
      type: true,
      recordArr: [],
      cceprice: 0,
      usdtprice: 0,
      ccetousdt: 0,
      usdttocce: 0,
      balanceObj: {
        cce: 0,
        usdt: 0,
      },
      timer: '',
      buyNumber: '',
    };
  },
  watch: {
    buyNumber(val) {
      let max = 0;
      if (this.type) {
        max = this.balanceObj.cce;
      } else {
        max = this.balanceObj.usdt;
      }
      if (Number(val) > Number(max)) {
        this.buyNumber = max;
        return;
      }
      if (val > 0 && val.toString().split('.').length > 1) {
        if (val.toString().split('.')[1].length > 4) {
          this.buyNumber = (Math.floor(Number(val) * 10000) / 10000).toFixed(4);
        }
      }
    },
  },

  mounted() {
    Global.contract().then((res) => {
      this.init();
      this.getBalance();
      this.timer = setInterval(() => {
        this.init();
        this.getBalance();
      }, 10000);
      // this.getPrice();
      // this.getBalance();
      // this.getflashcashrec();
    });
  },
  methods: {
    async init() {
      let res = await flashcashPage();
      this.getPrice(res);
      this.getflashcashrec(res);
      console.log(res);
    },
    all() {
      if (this.type) {
        // this.buyNumber = (this.balanceObj.cce / this.ccetousdt).toFixed(4)
        this.buyNumber = this.balanceObj.cce;
      } else {
        // this.buyNumber = (this.balanceObj.usdt / this.usdttocce).toFixed(4)
        this.buyNumber = this.balanceObj.usdt;
      }
    },
    async getPrice(res) {
      // let res = await getPriceFn(0);
      if (res) {
        // console.log(res)
        this.cceprice = Number(Global.numberUtil(res._cceprice, 6));
        this.usdtprice = Number(Global.numberUtil(res._usdtprice, 6));
        this.ccetousdt = (this.usdtprice / this.cceprice).toFixed(4);
        this.usdttocce = (this.cceprice / this.usdtprice).toFixed(4);
      }
    },
    async getBalance() {
      let res = await userbalanceFn(1);
      if (res) {
        // console.log(res)
        this.balanceObj.cce = (
          Math.floor(Number(Global.numberUtil(res.ccebal, 6)) * 10000) / 10000
        ).toFixed(4);
        this.balanceObj.usdt = (
          Math.floor(Number(Global.numberUtil(res.enusdtbal, 6)) * 10000) /
          10000
        ).toFixed(4);
      }
    },
    async flashcash() {
      if (this.buyNumber <= 0) {
        this.$toast('请输入兑换金额');
        return;
      }
      let paramType = this.type ? 0 : 1;
      let res = await flashcashFn(
        0,
        paramType,
        Number(this.buyNumber) * 1000000
      );
      if (res) {
        this.$toast('兑换成功');
      }
    },
    async getflashcashrec(res) {
      // let res = await getflashcashrecFn(1);
      if (res) {
        let obj = [];
        res._type.forEach((itme, key) => {
          obj.push({
            type: Number(Global.toBigNumber(res._type[key])),
            cceprice: Number(Global.numberUtil(res.cceprice[key], 6)).toFixed(
              2
            ),
            ccenumber: Number(Global.numberUtil(res.ccenumber[key], 6)).toFixed(
              4
            ),
            usdtprice: Number(Global.numberUtil(res.usdtprice[key], 6)).toFixed(
              2
            ),
            usdtnumber: Number(
              Global.numberUtil(res.usdtnumber[key], 6)
            ).toFixed(4),
            time: Number(Global.toBigNumber(res.time[key])),
          });
        });
        this.recordArr = obj;
        // console.log(this.recordArr)
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
@import '../assets/css/exchange.scss';
</style>
