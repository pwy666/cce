<template>
  <div class="allFlex column manager">
    <div class="box">
      <h2 class="Wcolor">修改usdt价格</h2>
      <input type="number" v-model="usdtprice" />
      <div class="btn">
        <el-button @click="updateusdtprice">提交</el-button>
      </div>
    </div>
    <div class="box">
      <h2 class="Wcolor">修改cce价格</h2>
      <input type="number" v-model="cceprice" />
      <div class="btn"><el-button @click="updatecceprice">提交</el-button></div>
    </div>
    <div class="box">
      <h2 class="Wcolor">修改日利率</h2>
      <input type="number" v-model="rate" />
      <div class="btn"><el-button @click="updaterate">提交</el-button></div>
    </div>
    <div class="box">
      <h2 class="Wcolor">修改算力价格</h2>
      <input type="number" v-model="powerprice" />
      <div class="btn">
        <el-button @click="updatepowerprice">提交</el-button>
      </div>
    </div>
    <div class="box">
      <h2 class="Wcolor">更新池子排名</h2>
      <div class="btn"><el-button @click="updateranking">更新</el-button></div>
    </div>
    <div class="box">
      <h2 class="Wcolor">取出USDT</h2>
      <input type="number" placeholder="金额" v-model="value1" />
      <input type="text" placeholder="地址" v-model="address1" />
      <div class="btn"><el-button @click="withdrawusdt">提交</el-button></div>
    </div>
    <div class="box">
      <h2 class="Wcolor">取出cce</h2>
      <input type="number" placeholder="金额" v-model="value2" />
      <input type="text" placeholder="地址" v-model="address2" />
      <div class="btn"><el-button @click="withdrawcce">提交</el-button></div>
    </div>
  </div>
</template>

<script>
import {
  updateccepriceFn,
  updatepowerpriceFn,
  updaterankingFn,
  updaterateFn,
  updateusdtpriceFn,
  withdrawcceFn,
  withdrawusdtFn,
} from '@/api/axios';

export default {
  name: 'manager',
  data() {
    return {
      usdtprice: '',
      cceprice: '',
      rate: '',
      powerprice: '',
      value1: '',
      address1: '',
      value2: '',
      address2: '',
    };
  },
  methods: {
    async updateusdtprice() {
      if (!this.usdtprice) {
        this.$toast('请输入参数');
        return;
      }
      let res = await updateusdtpriceFn(Number(this.usdtprice) * 1000000);
      if (res) {
        this.$toast('成功');
      }
    },
    async updatecceprice() {
      if (!this.cceprice) {
        this.$toast('请输入参数');
        return;
      }
      let res = await updateccepriceFn(Number(this.cceprice) * 1000000);
      if (res) {
        this.$toast('成功');
      }
    },
    async updaterate() {
      if (!this.rate) {
        this.$toast('请输入参数');
        return;
      }
      let res = await updaterateFn(Number(this.rate) * 10000);
      if (res) {
        this.$toast('成功');
      }
    },
    async updatepowerprice() {
      if (!this.powerprice) {
        this.$toast('请输入参数');
        return;
      }
      let res = await updatepowerpriceFn(Number(this.powerprice) * 1000000);
      if (res) {
        this.$toast('成功');
      }
    },
    async updateranking() {
      let res = await updaterankingFn();
      if (res) {
        this.$toast('成功');
      }
    },
    async withdrawusdt() {
      if (!this.value1 || !this.address1) {
        this.$toast('请输入参数');
        return;
      }
      let res = await withdrawusdtFn(
        Number(this.value1) * 1000000,
        this.address1
      );
      if (res) {
        this.$toast('成功');
      }
    },
    async withdrawcce() {
      if (!this.value2 || !this.address2) {
        this.$toast('请输入参数');
        return;
      }
      let res = await withdrawcceFn(
        Number(this.value2) * 1000000,
        this.address2
      );
      if (res) {
        this.$toast('成功');
      }
    },
  },
};
</script>

<style scoped>
.box {
  display: flex;
  flex-direction: column;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
}
.btn {
  display: flex;
  justify-content: center;
}
input {
  height: 45px;
  line-height: 45px;
  padding: 0 110px 0 10px;
  border: 0;
  background: #1d233d;
  border: 1px solid #5d5f82;
  border-radius: 10px;
  color: #fff;
}
.btn {
  width: 200px;
}
</style>
