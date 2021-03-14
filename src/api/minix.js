export default {
  data() {
    return {
      minBlance: {}, //usdt, cce余额
      minPrice: {},
      minGetralation: {}, //上级地址， 直推记录
    };
  },
  methods: {
    //更新余额
    minGetBalance(obj) {
      this.minBlance = obj;
    },

    //更新价格
    minGetPrice(obj) {
      this.minPrice = obj;
    },

    minGetralationFn(obj) {
      this.minGetralation = obj;
    },
  },
};
