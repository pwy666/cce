<template>
  <div class="home allFlex column">
    <h2 class="allTitle">流动挖矿</h2>
    <div class="pool">
      <div class="top allFlex">
        <span class="Wcolor font-Eight">算力池{{ poolNum }}</span>
        <span class="Wcolor five-Eight">细则说明</span>
        <img src="../assets/img/icon_wfsm.png" />
      </div>
      <div class="bottom allFlex ztBj">
        <img src="../assets/img/icon_usdt.png" />
        <ul class="allFlex column">
          <li class="Wcolor">{{ balanceObj.myusdt }}</li>
          <li class="textColor">钱包余额</li>
        </ul>
        <ul class="allFlex column">
          <li class="Wcolor">{{ balanceObj.usdt }}</li>
          <li class="textColor">可用余额</li>
        </ul>

        <div
          class="btn blueColor font-Five center"
          @click="
            show = true;
            type = 4;
          "
        >
          存入
        </div>
      </div>
    </div>
    <!--    参与    -->
    <div class="join allFlex column ztBj">
      <p>已参与数量（USDT）</p>
      <div class="Wcolor font-Eight">{{ balanceObj.enUsdt }}</div>
      <!-- <ul class="allFlex">
        <li class="allFlex column">
          <p>基础贷款额度</p>
          <p class="Wcolor center">30%</p>
        </li>
        <li class="allFlex column">
          <p>年化收益率</p>
          <p class="Wcolor center">30%</p>
        </li>
        <li class="allFlex column">
          <p>已累计收益</p>
          <p class="Wcolor center">30%</p>
        </li>
      </ul> -->
      <input type="number" v-model="number" />
      <div class="btn Wcolor font-Five center" @click="enjoy">立即参与</div>
    </div>

    <!-- 贷款 -->
    <div v-for="(item, key) in getdeprecArr" :key="'getdeprec' + key">
      <div class="mining allFlex column ztBj" v-if="item.status">
        <div class="top allFlex">
          <div class="Wcolor center blueBg">{{ key + 1 }}</div>
          <p class="title Wcolor font-Six">流动挖矿</p>
          <p class="textColor">2020/12/12 12:12</p>
        </div>
        <ul class="allFlex">
          <li class="allFlex column">
            <p class="textColor">参与数量(U)</p>
            <p class="Wcolor center">{{ item.number1 }}</p>
          </li>
          <li class="allFlex column">
            <p class="textColor">可贷数量(CCE)</p>
            <p class="Wcolor center">
              {{ item.loanstatus == false ? 0 : item.number3 }}
            </p>
          </li>
          <li class="allFlex column">
            <p class="textColor">已贷数量(CCE)</p>
            <p class="Wcolor center">{{ item.number2 }}</p>
          </li>
        </ul>
        <div class="allFlex btns">
          <div class="font-Five center Wcolor blueBg" @click="loan(item, key)">
            贷款
          </div>
          <div class="font-Five center Wcolor Ybg" @click="backFn(item, key)">
            赎回
          </div>
          <div
            class="font-Five center Wcolor greenBg"
            @click="loanFn(item, key)"
          >
            还贷
          </div>
        </div>
      </div>
    </div>

    <div class="more center ztBj textColor">查看更多记录</div>
    <!--    算力池排行榜-->
    <h2 class="allTitle">算力池排行榜</h2>
    <p class="ts Wcolor">排行榜每两周刷新一次</p>
    <ul class="ranking allFlex column ztBj">
      <li class="allFlex Wcolor">
        <span>排名</span>
        <span>名称</span>
        <span>总算力(USDT)</span>
      </li>
      <li
        class="allFlex Wcolor"
        v-for="(item, key) in ranking"
        :key="'rank' + key"
      >
        <img src="../assets/img/icon_one.png" v-if="key == 0" />
        <img src="../assets/img/icon_two.png" v-if="key == 1" />
        <img src="../assets/img/icon_three.png" v-if="key == 2" />
        <span class="Wcolor">算力池{{ item.index }}</span>
        <span class="blueColor">{{ item.value }}</span>
      </li>
    </ul>

    <van-popup
      v-model="show"
      round
      :style="{ height: '225px', width: '330px' }"
    >
      <!-- 存入 -->
      <div class="dailog allFlex column" v-if="type == 4">
        <p class="titleColor Bold">存入</p>
        <div class="input">
          <input type="number" v-model="number4" />
          <div class="right allFlex centerAll">
            <span class="blueColor" @click="number4 = balanceObj.myusdt"
              >全部</span
            >
            <div></div>
            <span class="titleColor Bold">USDT</span>
          </div>
        </div>
        <div class="btn center Wcolor" @click="toApprove">确认</div>
      </div>

      <!-- 还贷 -->
      <div class="dailog allFlex column" v-if="type == 3">
        <p class="titleColor">
          <span class="Bold">还贷数量</span>
          <span class="blueColor">（需还 : {{ recObj.number2 }} CCE)</span>
        </p>
        <p class="textColor">
          可用余额： <span class="blueColor">{{ balanceObj.cce }}</span> CCE
        </p>
        <div class="btn center Wcolor" @click="repayment">确认还款</div>
      </div>

      <!-- 贷款 -->
      <div class="dailog allFlex column" v-if="type == 1">
        <p class="titleColor"><span class="Bold">借贷数量</span></p>
        <div class="input">
          <input type="number" v-model="number1" />
          <div class="right allFlex centerAll">
            <span class="blueColor" @click="number1 = recObj.number3"
              >全部</span
            >
            <div></div>
            <span class="titleColor Bold">CCE</span>
          </div>
        </div>
        <p class="textColor">
          可贷余额： <span class="blueColor">{{ recObj.number3 }}</span> CCE
        </p>
        <div class="btn center Wcolor" @click="loan">确认贷款</div>
      </div>

      <!-- 赎回 -->
      <div class="dailog2 allFlex column" v-if="type == 2">
        <p class="titleColor"><span class="Bold">赎回</span></p>
        <p class="titleColor">赎回前需结清借贷</p>
        <p class="titleColor">还贷数量：{{ recObj.number2 }} CCE</p>
        <div class="btns allFlex">
          <div class="btn center blueColor " @click="show = false">取消</div>
          <div class="btn center Wcolor titleBg" @click="repayment">确认</div>
        </div>
      </div>
    </van-popup>
  </div>
</template>

<script>
import {
  userbalanceFn,
  approveFn,
  getrankingFn,
  depositFn,
  getralationFn,
  getloanrecFn,
  loanFn,
  getdeprecFn,
  getPriceFn,
  withdrawFn,
  repaymentFn,
} from '../api/axios';
import Global from '../api';
import Minix from '../api/minix.js';
import { getpoolachievementFn, homePage } from '@/api/axios';

export default {
  name: 'home',
  data() {
    return {
      show: false,
      type: 1,
      number4: '',
      number1: '',
      number3: '',
      number: '',
      balanceObj: {
        usdt: '',
        cce: '',
        myusdt: '',
      },
      parents: 'TFHiBPFuLXZxkjKvDFq8fHxjYfVnw968Zh',
      getdeprecArr: [],
      allPrice: {
        usdt: '',
        cce: '',
        power: '',
      },
      ranking: [],
      recid: '',
      index: 0,
      poolNum: '',
      timer: '',
    };
  },
  computed: {
    recObj() {
      return this.getdeprecArr[this.index] || { number3: '' };
    },
  },
  mixins: [Minix],
  watch: {
    show(val) {
      if (val) {
        this.number4 = '';
      }
    },
    number4(val) {
      let max = this.balanceObj.myusdt;
      if (Number(val) > Number(max)) {
        this.number4 = max;
        return;
      }
      if (val > 0 && val.toString().split('.').length > 1) {
        if (val.toString().split('.')[1].length > 4) {
          this.number4 = (Math.floor(Number(val) * 10000) / 10000).toFixed(4);
        }
      }
    },
    number(val) {
      let max = this.balanceObj.usdt;
      if (Number(val) > Number(max)) {
        this.number = max;
        return;
      }
      if (val > 0 && val.toString().split('.').length > 1) {
        if (val.toString().split('.')[1].length > 4) {
          this.number = (Math.floor(Number(val) * 10000) / 10000).toFixed(4);
        }
      }
    },
    number1(val) {
      let max = this.recObj.number3;
      if (Number(val) > Number(max)) {
        this.number1 = max;
        return;
      }
      if (val > 0 && val.toString().split('.').length > 1) {
        if (val.toString().split('.')[1].length > 4) {
          this.number1 = (Math.floor(Number(val) * 10000) / 10000).toFixed(4);
        }
      }
    },
  },
  methods: {
    loanFn(item, key) {
      if (item.loanstatus) {
        this.$toast('已结清');
        return;
      }
      this.getBalancecce();
      this.show = true;
      this.type = 3;
      this.index = key;
    },
    //赎回
    async backFn(item, key) {
      if (!item.loanstatus) {
        this.$toast('请先还款');
        return;
      }
      this.type = 2;
      // this.show = true;

      this.index = key;
      let res = await withdrawFn(item.id);
      if (res) {
        this.init();
        this.$toast('赎回成功');
        this.show = false;
      }
    },

    //还款
    async repayment() {
      let res = await repaymentFn(this.recObj.id);
      if (res) {
        this.$toast('还款成功');
        this.show = false;
        this.number3 = '';
      }
    },

    //获取价格
    async getPrice() {
      let res = await getPriceFn();
      if (res) {
        this.allPrice.usdt = Number(
          Global.numberUtil(res._usdtprice, 6)
        ).toFixed(2);
        this.allPrice.cce = Number(Global.numberUtil(res._cceprice, 6)).toFixed(
          2
        );
        this.allPrice.power = Number(
          Global.numberUtil(res._powerprice, 6)
        ).toFixed(2);
        this.minGetPrice(this.allPrice);
      }
    },

    //贷款
    async loan(item, key) {
      if (!item.loanstatus) {
        this.$toast('已无贷款数量');
        return;
      }
      this.index = key;
      let res = await loanFn(this.recObj.id);
      if (res) {
        this.$toast('贷款成功');
      }
    },
    //存款记录
    getdeprec(res) {
      let objArr = [];
      res.usdtnumber.forEach((item, key) => {
        let obj = {};
        obj.number1 = Number(Global.numberUtil(item, 6)).toFixed(2); //参与数量
        obj.number2 = Number(Global.numberUtil(res.ccenumber[key], 6)).toFixed(
          2
        );
        //已贷
        let usdt =
          (obj.number1 *
            this.allPrice.usdt *
            Number(Global.numberUtil(res.prop, 0))) /
          100;
        let cce = obj.number2 * this.allPrice.cce;

        obj.number3 = (
          Math.floor(Number((usdt - cce) / this.allPrice.cce) * 100) / 100
        ).toFixed(2);
        obj.status = res.status[key];
        obj.loanstatus = res.loanstatus[key];
        obj.id = Global.toBigNumber(res.id[key]);
        objArr.push(obj);
      });
      console.log(objArr);
      this.getdeprecArr = objArr;
    },
    //获取上级
    async getParents() {
      let res = await getralationFn();
      if (res) {
        if (res[0] !== '410000000000000000000000000000000000000000') {
          this.parents = res[0];
        } else {
          if (this.$route.query.tgm) {
            this.parents = this.$route.query.tgm;
          }
        }
        this.minGetralationFn(res);
      }
    },
    async getBalancecce() {
      let res = await userbalanceFn();
      this.balanceObj.cce = (
        Math.floor(Number(Global.numberUtil(res.ccebal, 6)) * 100) / 100
      ).toFixed(2);
    },
    //获取余额
    getBalance(res) {
      if (res) {
        this.balanceObj.usdt = (
          Math.floor(Number(Global.numberUtil(res.enusdt._hex, 6)) * 100) / 100
        ).toFixed(2);
        this.balanceObj.myusdt = (
          Math.floor(Number(Global.numberUtil(res.walletusdt._hex, 6)) * 100) /
          100
        ).toFixed(2);
        this.minGetBalance(this.balanceObj);
        //已参与USDT数量
        this.balanceObj.enUsdt = Number(
          Global.numberUtil(res.inpoolusdt[1], 6)
        ).toFixed(2);
      }
    },

    //存入
    async toApprove() {
      if (this.number4 <= 0) {
        this.$toast('请输入存入数量');
        return;
      }
      let res = await approveFn(this.number4);
      if (res) {
        this.$toast('成功');
        // this.getBalance();
        this.number4 = '';
        this.show = false;
      }
    },

    //矿池信息
    getHasEnjoy(res) {
      let objArr = [];
      if (res) {
        // console.log(res,111)
        this.poolNum = Global.toBigNumber(res.inpoolusdt[0]);
        res.pool.forEach((item, key) => {
          let obj = {
            index: Number(Global.toBigNumber(item)),
            value: Number(
              Global.numberUtil(res.pools_achievement[key], 6)
            ).toFixed(2),
          };
          objArr.push(obj);
        });
      }
      this.ranking = objArr;
    },

    //参与
    async enjoy() {
      if (this.number <= 0 || this.number > +this.balanceObj.usdt) {
        this.$toast('请输入余额内的数量');
        return;
      }
      let res = await depositFn(this.parents, this.number * 1000000);
      if (res) {
        this.$toast('成功');
        this.init();
        // this.getBalance();
        // this.getHasEnjoy();
        this.number = '';
      }
    },
    async init() {
      let res = await homePage();
      // console.log(res)
      this.getdeprec(res);
      this.getBalance(res); //可用usdt余额  ，可用cce余额
      this.getHasEnjoy(res);
      // console.log(res);
    },
  },
  mounted() {
    Global.contract().then((res) => {
      // console.log(res);
      this.getPrice();
      this.init();
      this.timer = setInterval(() => {
        this.init();
      }, 10000);
      // this.getBalance();
      // this.getHasEnjoy();
      this.getParents();
    });
  },
  beforeDestroy() {
    const _this = this;
    clearInterval(_this.timer);
  },
};
</script>

<style scoped="scoped" lang="scss">
@import '../assets/css/home.scss';
</style>
