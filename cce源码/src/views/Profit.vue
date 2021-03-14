<template>
  <div class="profit padding">
    <div class="font-Tt Wcolor profit-title">收益</div>

    <!-- 余额 -->
    <ul>
      <!-- cce -->
      <li class="allFlex profit-assets boxBg border radius">
        <img src="@img/icon_cce.png" alt="" />
        <div class="allFlex column profit-assets_value">
          <span class="Wcolor font-Five">CCE</span>
          <span class="textColor font-Four">Cancrie</span>
        </div>
        <div class="allFlex column">
          <span class="Wcolor font-Four">{{ balanceObj.cce }}</span>
          <span class="textColor font-Four">钱包余额</span>
        </div>
      </li>

      <!-- usdt -->
      <li class="allFlex profit-assets boxBg border radius">
        <img src="@img/icon_usdt.png" alt="" />
        <div class="allFlex column profit-assets_value">
          <span class="Wcolor font-Five">USDT</span>
          <span class="textColor font-Four">TetherUS</span>
        </div>
        <div class="allFlex column">
          <span class="Wcolor font-Four">{{ balanceObj.usdt }}</span>
          <span class="textColor font-Four">钱包余额</span>
        </div>
      </li>
    </ul>

    <!-- 累计收益 -->
    <ul class="border boxBg profit-balance allFlex column radius">
      <li class="f1 allFlex column center">
        <span class="textColor font-Four">累计收益（CCE）</span>
        <span class="Wcolor font-Four">{{ balanceObj.all }}</span>
      </li>
      <li class="allFlex f1">
        <div class="allFlex column center">
          <span class="textColor font-Four">挖矿收益（CCE）</span>
          <span class="Wcolor font-Four">{{ balanceObj.miningAll }}</span>
        </div>

        <div class="allFlex column center">
          <span class="textColor font-Four">理财收益（USDT）</span>
          <span class="Wcolor font-Four">{{ balanceObj.financialAll }}</span>
        </div>
      </li>
    </ul>

    <!-- 领取 -->
    <ul class="border boxBg profit-balance2 allFlex column radius">
      <li class="f1 allFlex column center">
        <span class="textColor font-Four">待领取收益（CCE）</span>
        <span class="Wcolor font-Four">{{ balanceObj.allNo }}</span>
      </li>
      <li class="allFlex f1">
        <div class="allFlex column center">
          <span class="textColor font-Four">挖矿收益（CCE）</span>
          <span class="Wcolor font-Four">{{ balanceObj.mining }}</span>
        </div>

        <div class="allFlex column center">
          <span class="textColor font-Four">理财收益（USDT）</span>
          <span class="Wcolor font-Four">{{ balanceObj.financial }}</span>
        </div>
      </li>
      <li>
        <div class="redBg Wcolor font-Five get-btn center" @click="receive">
          一键领取
        </div>
      </li>
    </ul>

    <!-- 挖矿， 理财， 推广 -->
    <div class="padding titleNav record-title blueBg allFlex">
      <span
        v-for="(item, key) in navArr"
        :key="key"
        class="font-Eight"
        @click="changeRecordArr(key)"
        :class="index == key ? 'titleColor' : 'navColor'"
        >{{ item }}</span
      >
    </div>

    <!-- 记录 -->
    <ul class="record-ul">
      <li
        v-for="(item, key) in recordArr"
        :key="'record' + key"
        class="allFlex border  boxBg"
        :class="key !== 0 && 'li'"
      >
        <div class="allFlex column">
          <span class="Wcolor font-Six">挖矿</span>
          <span class="textColor font-Four">{{ item.time | formatDates }}</span>
        </div>

        <span class="font-Eight PFcolor">+{{ item.number }} CCE</span>
      </li>
    </ul>
  </div>
</template>
<script>
import {
  getprofitFn,
  getprofitresFn,
  receiveFn,
  userbalanceFn,
} from '@/api/axios';
import Global from '@/api';

export default {
  data() {
    return {
      balanceObj: {
        cce: '0',
        usdt: '0',
        all: '0.0000',
        mining: '0.000',
        financial: '0.0000',
        miningAll: '0.00',
        financialAll: '0.00',
        allNo: '0.00',
      },
      navArr: ['挖矿', '理财', '推广'],
      index: 0,
      recordArr: [],
      recordArr1: [],
      recordArr2: [],
      recordArr3: [],
    };
  },
  methods: {
    async changeRecordArr(key) {
      this.index = key;
      if (key == 0) {
        this.recordArr = this.recordArr1;
      } else if (key == 1) {
        this.recordArr = this.recordArr2;
      } else {
        this.recordArr = this.recordArr3;
      }
    },
    async getBalance() {
      let res = await userbalanceFn(1);
      if (res) {
        // console.log(res)
        this.balanceObj.cce = Number(Global.numberUtil(res.ccebal, 6)).toFixed(
          2
        );
        this.balanceObj.usdt = Number(
          Global.numberUtil(res.usdtbal, 6)
        ).toFixed(2);
      }
    },
    async getprofitres() {
      let res = await getprofitresFn(1);
      console.log(res);
      if (res) {
        let obj = [];
        res._type.forEach((itme, key) => {
          obj.push({
            type: Number(Global.toBigNumber(res._type[key])),
            number: Number(Global.numberUtil(res._number[key], 6)).toFixed(2),
            time: Number(Global.toBigNumber(res._time[key])),
          });
        });
        this.recordArr1 = obj.filter((item) => item.type == 0);
        this.recordArr = this.recordArr1;
        this.recordArr2 = obj.filter((item) => item.type == 1);
        this.recordArr3 = obj.filter(
          (item) => item.type == 2 || item.type == 3
        );
        // console.log(obj)
        let sum1 = 0;
        let sum2 = 0;
        let sum3 = 0;
        // console.log(this.recordArr1)
        sum1 = this.recordArr1.reduce(
          (sum1, item) => sum1 + Number(item.number),
          0
        );
        sum2 = this.recordArr2.reduce(
          (sum2, item) => sum2 + Number(item.number),
          0
        );
        sum3 = this.recordArr3.reduce(
          (sum3, item) => sum3 + Number(item.number),
          0
        );
        // console.log(sum1)
        // console.log(sum2)
        // console.log(sum3)
        this.balanceObj.all = (sum1 + sum2 + sum3).toFixed(2);
        this.balanceObj.miningAll = sum1.toFixed(2);
        this.balanceObj.financialAll = sum2.toFixed(2);
      }
    },
    async getprofit() {
      let res = await getprofitFn(1);
      // console.log(res)
      if (res) {
        this.balanceObj.mining = Number(
          Global.numberUtil(res._depprofit, 6)
        ).toFixed(2);
        this.balanceObj.financial = Number(
          Global.numberUtil(res._finprofit, 6)
        ).toFixed(2);
        this.balanceObj.allNo = (
          Number(Global.numberUtil(res._depprofit, 6)) +
          Number(Global.numberUtil(res._finprofit, 6))
        ).toFixed(2);
        console.log(this.balanceObj.financial);
        // this.balanceObj.cce = Number(Global.numberUtil(res.ccebal,6)).toFixed(2)
        // this.balanceObj.usdt = Number(Global.numberUtil(res.usdtbal,6)).toFixed(2)
      }
    },
    async receive() {
      let res = await receiveFn(0);
      console.log(res);
      if (res) {
        this.$toast('领取成功');
      }
    },
  },
  created() {},
  mounted() {
    Global.contract().then((res) => {
      this.getBalance();
      this.getprofit();
      this.getprofitres();
    });
  },
};
</script>
<style scoped lang="scss">
.profit {
  padding-bottom: 10px;
}
.profit-title {
  margin: 10px 0;
}

.profit-assets {
  height: 70px;
  padding: 15px 10px;
  justify-content: flex-start;
  margin-bottom: 10px;
  img {
    width: 40px;
    height: 40px;
  }
  &_value {
    width: 100px;
    margin: 0 20px 0 20px;
  }
}

.profit-balance {
  height: 150px;
  padding: 10px;
  margin-bottom: 10px;
  li,
  div {
    padding: 4px 0;
  }
}
.profit-balance2 {
  height: 220px;
  padding: 10px;
  margin-bottom: 10px;
  li,
  div {
    padding: 4px 0;
  }
}
.get-btn {
  height: 40px;
  line-height: 40px;
  border-radius: 25px;
  width: 40%;
  margin: 10px auto 0;
}

.record-title span {
  transition: ease-in-out 0.1s;
}

.record-ul li {
  height: 70px;
  padding: 15px 10px;

  align-items: center;
  &.li {
    margin-top: 20px;
    border-radius: 10px;
  }
  &:first-child {
    border-radius: 0 0 10px 10px !important;
  }
}
</style>
