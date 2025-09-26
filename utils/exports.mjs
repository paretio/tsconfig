#!/usr/bin/env node

import { readFileSync } from "node:fs";
import { stdin } from "node:process";
import { resolve } from "node:path";

function readInput() {
  if (!stdin.isTTY) {
    // Data is being piped in
    return readFileSync(0, "utf-8");
  } else {
    // No stdin, read package.json
    return readFileSync(resolve("package.json"), "utf-8");
  }
}

let file = readInput()
let json = JSON.parse(file);
let name = json.name;
let exports = Object.keys(json.exports).map(v => v.replace(".", name))
for (let ex of exports) {
  console.log(ex);
}
