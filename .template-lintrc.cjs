// `no-triple-curlies` used to be disabled here for the two connector
// templates' `{{{site.supporthub_*}}}`. Both are now `.gjs` using an
// explicit, documented `htmlSafe`, so the rule has nothing to suppress
// and the base config stands on its own.
module.exports = require("@discourse/lint-configs/template-lint");
