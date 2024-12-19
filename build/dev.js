const baseConfig = require('./_base.js');
const { merge } = require('webpack-merge');

module.exports = merge(baseConfig, {
    mode: 'development',
    devServer: {
        open: true,
        historyApiFallback: {
            disableDotRule: true
        },
        liveReload: true,
        hot: false,
        port: 8890,
        allowedHosts: "all",
        // client: {
        //     webSocketURL: 'ws://pugsley.int.wsr.at:11281/ws',
        // },
    },
    devtool: 'source-map',
});
