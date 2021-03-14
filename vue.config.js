const path = require('path');

const resolve = (dir) => path.join(__dirname, dir);
module.exports = {
  publicPath: './',
  productionSourceMap: false,
  devServer: {
    host: '0.0.0.0',
    // assetsSubDirectory: 'public',
    port: 9090,
    proxy: {
      '/exchange': {
        target: 'https://exchange.peex.pro/exchange/',
        // target: "http://192.168.10.110:8035/exchange/",
        changeOrigin: true,
        pathRewrite: {
          '^/exchange': '', // 这里理解成用‘/api’代替target里面的地址，后面组件中我们掉接口时直接用api代替
        },
      },
      '/peex': {
        target: 'https://www.peex.pro/peex/',
        changeOrigin: true,
        pathRewrite: {
          '^/peex': '', // 这里理解成用‘/api’代替target里面的地址，后面组件中我们掉接口时直接用api代替
        },
      },
    },
  },
  chainWebpack: (config) => {
    // 别名 alias
    config.resolve.alias
      .set('@', resolve('src'))
      .set('@img', resolve('src/assets/img'));
  },

  css: {
    sourceMap: false,
    loaderOptions: {
      postcss: {
        plugins: [
          require('postcss-pxtorem')({
            // 把px单位换算成rem单位
            rootValue: 37.5, // 换算的基数(设计图750的根字体为32)
            propList: ['*'],
          }),
        ],
      },
    },
  },
};
