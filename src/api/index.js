import Vue from 'vue';
const Global = {
  contract() {
    return new Promise((resolve, reject) => {
      let count = null;
      let tron = null;
      let timer = setInterval(() => {
        tron = window.tronWeb;
        if (tron) {
          Vue.prototype.$tronWeb = tron;
          resolve(tron);
          clearInterval(timer);
        }
        if (count > 100) {
          clearInterval(timer);
          reject('error');
        }
        count++;
      }, 100);
    });
  },
  // 精度处理
  numberUtil(value, decimal) {
    // decimal = 18;
    if (!value) return '--';
    value=window.tronWeb.toBigNumber(value).toString(10)
    // console.log(value)
    let i = value.length;
    if (i <= decimal) {
      while (true) {
        if (i < decimal) {
          value = '0' + value;
          i++;
        } else {
          break;
        }
      }
      return '0.' + value;
    }
    const value1 = value.substr(0, value.length - decimal);
    const value2 = value.substr(value.length - decimal, value.length);
    return value1 + '.' + value2;
  },
  toBigNumber(value) {
    value=window.tronWeb.toBigNumber(value).toString(10)
    return value
  },
};

export default Global;
