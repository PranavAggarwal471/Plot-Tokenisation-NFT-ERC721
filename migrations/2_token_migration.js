const PlotToken = artifacts.require("PlotToken");

module.exports = function (deployer) {
  deployer.deploy(PlotToken);
};