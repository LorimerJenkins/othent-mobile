import commonjs from "@rollup/plugin-commonjs";
import { nodeResolve } from "@rollup/plugin-node-resolve";
import terser from "@rollup/plugin-terser";

export default {
  input: "contentScript.js",
  output: {
    file: "../content.js",
    format: "iife",
    name: "OthentMobile",
  },
  plugins: [
    nodeResolve({
      browser: true,
    }),
    commonjs(),
    terser(),
  ],
};
