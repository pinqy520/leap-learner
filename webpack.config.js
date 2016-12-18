/* Configure HTMLWebpack plugin */
const HtmlWebpackPlugin = require('html-webpack-plugin')
const HTMLWebpackPluginConfig = new HtmlWebpackPlugin({
    template: __dirname + '/src/index.html',
    filename: 'index.html',
    inject: 'body'
})

/* Configure ProgressBar */
const ProgressBarPlugin = require('progress-bar-webpack-plugin')
const ProgressBarPluginConfig = new ProgressBarPlugin()

/* Export configuration */
module.exports = {
    devtool: 'source-map',
    entry: [
        './src/index.coffee'
    ],
    output: {
        path: __dirname + '/dist',
        filename: 'index.js'
    },
    module: {
        loaders: [
            { test: /\.coffee$/, exclude: /node_modules/, loader: "coffee-loader" },
            { test: /\.(coffee\.md|litcoffee)$/, loader: "coffee-loader?literate" },
            { test: /\.json$/, loader: "json-loader" },
        ]
    },
    resolve: { extensions: ["", ".web.coffee", ".web.js", ".coffee", ".js"] },
    plugins: [HTMLWebpackPluginConfig, ProgressBarPluginConfig]
}
