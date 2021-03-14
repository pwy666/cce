import { Message } from 'element-ui';
import store from '@/store';

var usdt_contract = 'TAaoabkZKqPFuET1ex1DwzNb3akSCTxWQz';
var cce_contract = 'TXEDfrpTnUJZxbSLVKMEWjnHnpFjgiW57y';
// var cce_contract = 'TNddedjvfyqKX5vcyiqDByKJBFhbat72sV';

async function getMethodsCall(name, type, ...params) {
  let contract = await window.tronWeb.contract().at(cce_contract);
  let defaultAddress = window.tronWeb.defaultAddress.base58;
  // console.log(defaultAddress)
  if (type) {
    return await contract[name](defaultAddress, ...params).call();
  } else {
    return await contract[name](...params).call();
  }
}

async function getMethodsCall2(name) {
  let contract = await window.tronWeb.contract().at(cce_contract);
  let defaultAddress = window.tronWeb.defaultAddress.base58;
  let res = await contract[name](defaultAddress).call();
  return res;
}

async function getMethodsSend(name, type, ...params) {
  let contract = await window.tronWeb.contract().at(cce_contract);
  let defaultAddress = window.tronWeb.defaultAddress.base58;
  // console.log(defaultAddress);
  if (type) {
    return await contract[name](defaultAddress, ...params).send({
      feeLimit: 100000000,
      callValue: 0,
      shouldPollResponse: false,
    });
  } else {
    return await contract[name](...params).send({
      feeLimit: 100000000,
      callValue: 0,
      shouldPollResponse: false,
    });
  }
}

async function getMethodsSend2(name, valueNumber, ...params) {
  let contract = await window.tronWeb.contract().at(cce_contract);
  let defaultAddress = window.tronWeb.defaultAddress.base58;
  let res = await contract[name](defaultAddress, ...params).send({
    feeLimit: 100000000,
    callValue: valueNumber,
    shouldPollResponse: false,
  });
  return res;
}

async function approve(number) {
  let contract = await window.tronWeb.contract().at(usdt_contract);

  let res = await contract.approve(cce_contract, number * 1000000).send({
    feeLimit: 100000000,
    callValue: 0,
    shouldPollResponse: false,
  });
  return res;
}

//取款
const withdrawFn = (...params) => getMethodsSend('withdraw', 0, ...params);

//还款
const repaymentFn = (...params) => getMethodsSend('repayment', 0, ...params);

//余额
const userbalanceFn = () => getMethodsCall('userbalance', 1);

//存入
const approveFn = (number) => approve(number);

//户已参与
const getrankingFn = () => getMethodsCall('getranking', 1);

//参与
const depositFn = (...params) => getMethodsSend('deposit', 0, ...params);

//获取上级地址
const getralationFn = () => getMethodsCall('getralation', 1);

//查询贷款记录
const getloanrecFn = () => getMethodsCall('getloanrec', 1);

//查询存款记录
const getdeprecFn = () => getMethodsCall('getdeprec', 1);

//贷款
const loanFn = (...params) => getMethodsSend('loan', 0, ...params);

//usdt cce价格
const getPriceFn = () => getMethodsCall('getprice', 0);

//待领取收益
const getprofitFn = (type, ...params) =>
  getMethodsCall('getprofit', type, ...params);
//收益记录
const getprofitresFn = (type, ...params) =>
  getMethodsCall('getprofitres', type, ...params);
//闪兑记录
const getflashcashrecFn = (type, ...params) =>
  getMethodsCall('getflashcashrec', type, ...params);
//理财记录
const getjoinrecFn = (type, ...params) =>
  getMethodsCall('getjoinrec', type, ...params);
//购买算力记录
const getpowerrecFn = (type, ...params) =>
  getMethodsCall('getpowerrec', type, ...params);
//日利率
const getrateFn = (type, ...params) =>
  getMethodsCall('getrate', type, ...params);
//矿池前三的总算力
const getpoolachievementFn = (type, ...params) =>
  getMethodsCall('getpoolachievement', type, ...params);

//领取收益
const receiveFn = (type, ...params) =>
  getMethodsSend('receive', type, ...params);
//闪兑
const flashcashFn = (type, ...params) =>
  getMethodsSend('flashcash', type, ...params);
//购买算力
const buypowerFn = (type, ...params) =>
  getMethodsSend('buypower', type, ...params);
//加入理财
const joinFn = (type, ...params) => getMethodsSend('join', type, ...params);
//退出理财
const outFn = (type, ...params) => getMethodsSend('out', type, ...params);

export {
  userbalanceFn,
  approveFn,
  getrankingFn,
  depositFn,
  getralationFn,
  getloanrecFn,
  loanFn,
  getdeprecFn,
  getPriceFn,
  getprofitFn,
  getprofitresFn,
  receiveFn,
  flashcashFn,
  buypowerFn,
  withdrawFn,
  repaymentFn,
  getflashcashrecFn,
  getpowerrecFn,
  getjoinrecFn,
  joinFn,
  outFn,
  getrateFn,
  getpoolachievementFn,
};
