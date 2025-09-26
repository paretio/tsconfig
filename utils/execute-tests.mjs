#!/usr/bin/env node

import { exec } from 'node:child_process';
import { mkdtemp, cp, writeFile } from "fs/promises";
import { readFile } from "node:fs/promises";
import { readFileSync } from "node:fs";
import { fileURLToPath } from "url";
import { dirname, resolve, join } from "path";
import { tmpdir } from "os";

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

const root = join(__dirname, '..')

const configs = [
  'tests/example-project-01-simple/',
  'tests/example-project-02-type-module/'
];

const pkgJson = readFileSync(resolve("package.json"), "utf-8");
const pkgJsonName = JSON.parse(pkgJson).name;
const pkgExports = Object.keys(JSON.parse(pkgJson).exports).filter(exp => exp !== "./package.json").map(v => v.replace(".", pkgJsonName))

async function execPromise(command, opt) {
  return new Promise((res, rej) => {
    function execResolve(error, stdout, stderr) {
      if (error !== null) {
        rej(error);
        return;
      }
      res(stdout);
    }
    exec(command, opt, execResolve);
  })
}

async function runTest(source, pkgExport) {
  const sourceString = source.replace(/(@|-|\/)/g, '-').toString();
  const pkgExportString = pkgExport.replace(/(@|-|\/)/g, '-').toString();
  const prefix = join(tmpdir(), `${sourceString}-${pkgExportString}`);


  return new Promise(async (res1, rej1) => {
    console.log(`Running against for ${pkgExport} against ${source}`)
    const folder = await mkdtemp(prefix);
    const execOptions = {
      cwd: folder
    };
    console.log(`${pkgExport} | ${source} | Using folder: ${folder}`);

    await cp(source, folder, { recursive: true })
    console.log(`${pkgExport} | ${source} | npm i --save-dev ${root}`);
    await execPromise(`npm i --save-dev ${root}`, execOptions)
    await writeFile(join(folder, 'tsconfig.json'), `{ "extends": "${pkgExport}" }\n`)
    // console.log(`${pkgExport} | ${source} | npm i`);
    // await execPromise(`npm i`, execOptions)
    console.log(`${pkgExport} | ${source} | npm run build`);
    const res = await execPromise(`npm run build`, execOptions);
    res1(res);
  })
}
const allConfigs = configs.flatMap(config => {
  return pkgExports.flatMap((pkgExport) => {
    return runTest(config, pkgExport)
  })
});

await Promise.all(allConfigs);
