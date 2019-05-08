module.exports = {
    "env": {
        "browser": true,
        "es6": true,
    },
    "globals": {
        MyGlobal: true,
    },
    "parserOptions": {
        "ecmaVersion": 6,
    },
    "rules": {
        "no-cond-assign": 2,
        "no-empty": 2,
        "no-extra-parens": 2,
        "no-extra-semi": 2,
        "no-irregular-whitespace": 2,
        "no-redeclare": 2,
        "no-undef-init": 2,
        "no-undef": 2,
        "no-unused-vars": [2, { "vars": "local" }],
        "no-use-before-define": 0,
        "semi": [2, "always"]
    }
};
