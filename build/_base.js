const webpack = require('webpack')

const { VueLoaderPlugin } = require('vue-loader')
const HtmlWebpackPlugin = require('html-webpack-plugin')
const CopyWebpackPlugin = require('copy-webpack-plugin')
const MiniCssExtractPlugin  = require('mini-css-extract-plugin')

const fs = require('fs');
const ldJson = fs.readFileSync('assets/schema/forwit.json', 'utf8');
// console.log(ldJson)

module.exports = {
    entry: [
        './src/app.js',
    ],
    output: {
        filename: 'app.min.[fullhash].js'
    },
    module: {
        rules: [
            {
                test: /\.vue$/,
                use: 'vue-loader',
            }, {
                test: /\.js$/,
                use: 'babel-loader'
            }, {
                test: /\.css$/,
                use: [
                    MiniCssExtractPlugin.loader,
                    'css-loader',
                ]
            }, {
                test: /\.s[ac]ss$/i,
                use: [
                    // Creates `style` nodes from JS strings
                    MiniCssExtractPlugin.loader,
                    // Translates CSS into CommonJS
                    "css-loader",
                    {
                        // Run postcss actions
                        loader: 'postcss-loader',
                        options: {
                            // `postcssOptions` is needed for postcss 8.x;
                            // if you use postcss 7.x skip the key
                            postcssOptions: {
                                // postcss plugins, can be exported to postcss.config.js
                                plugins: function () {
                                    return [
                                        require('autoprefixer')
                                    ];
                                }
                            }
                        }
                    },
                    // Compiles Sass to CSS
                    "sass-loader",
                ],
            }, {
                test: /\.svg$/,
                use: [
                    'vue-loader',
                    'vue-svg-loader',
                ],
            },
        ]
    },
    plugins: [
        new VueLoaderPlugin(),
        new HtmlWebpackPlugin({
            filename: 'index.html',
            template: 'index.html',
            inject: true,
            publicPath: '/',
            ldJson: ldJson,
        }),
        new CopyWebpackPlugin({
            patterns: [
              { from: "assets/data", to: "data" },
              { from: "assets/img", to: "img" },
              { from: "assets/docs/pdf", to: "docs/pdf" },
              { from: "assets/docs/img", to: "docs/img" },
              { from: "assets/docs/indicators", to: "docs/ind" },
              { from: "assets/docs/md", to: "md" },
              { from: "assets/geo", to: "data" },
              { from: "assets/fonts", to: "fonts" },
              { from: "assets/.htaccess", to: "" },
              { from: "assets/favicon", to: "icon" },
              { from: "assets/schema", to: "" },
            ],
        }),
        new MiniCssExtractPlugin({
            filename: 'main.[fullhash].css'
        })
    ],
}
