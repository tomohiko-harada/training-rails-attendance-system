module.exports = function (api) {
  api.cache(true);
  return {
    presets: [
      ["@babel/preset-env", { modules: false, useBuiltIns: "usage", corejs: 3 }]
    ],
    plugins: [
      ["@babel/plugin-proposal-class-properties", { loose: true }],
      ["@babel/plugin-proposal-object-rest-spread", { useBuiltIns: true }]
    ]
  }
}
