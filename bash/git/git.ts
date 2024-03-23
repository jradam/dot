#!/usr/bin/env -S npx ts-node

// TODO: https://www.codejam.info/2023/04/zx-typescript-esm.html

// TODO: add zx to install script?
// TODO: add ts-node to install script?
// TODO: implement git script

void (async function () {
  const { $ } = await import('zx')

  await $`echo ok`
})()

import { LogEntry, log } from 'zx/core'

// $.log = (entry: LogEntry) => {
//   switch (entry.kind) {
//     case 'cmd':
//       process.stderr.write(masker(entry.cmd))
//       break
//     default:
//       log(entry)
//   }
// }
//
// const current = await $`git branch --show-current`
//
// $`echo ${current}`
