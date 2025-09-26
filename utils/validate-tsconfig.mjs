#!/usr/bin/env node

const [,, arg1, arg2] = process.argv;

import { readConfigFile, sys, flattenDiagnosticMessageText, parseJsonConfigFileContent } from 'typescript';
const configPath = arg1;
const configFile = readConfigFile(configPath, sys.readFile);

if (configFile.error) {
  console.error(flattenDiagnosticMessageText(configFile.error.messageText, '\n'));
} else {
  const result = parseJsonConfigFileContent(
    configFile.config,
    sys,
    arg2
  );
  console.log(result.errors);
}
