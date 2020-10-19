const { environment } = require("@rails/webpacker");
const webpack = require("webpack");

const customConfig = require("./alias");

environment.plugins.append(
  "Provide",
  new webpack.ProvidePlugin({
    $: "jquery",
    jQuery: "jquery",
    Popper: ["popper.js", "default"],
  })
);

environment.config.merge(customConfig);

module.exports = environment;
