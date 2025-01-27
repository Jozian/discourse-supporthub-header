const base = require("@discourse/lint-configs/template-lint");
module.exports = {
  ...base,
  rules: {
    ...base.rules,
    'no-triple-curlies': false
  },
};
