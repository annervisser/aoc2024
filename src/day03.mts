import * as fs from 'node:fs/promises';

const code = await fs.readFile(`${import.meta.dirname}/day03.sample.txt`, {encoding: 'utf-8'});
const open = 'mul(';

const numbers = new Set(Array.from({length: 10}).map((_, i) => `${i}`));

let index = 0;
let total = 0;

const iterator = Iterator.from(code);
for (const char of iterator) {
    // console.log(char, index)
    if (char !== open[index]) {
        index = 0;
        continue;
    }
    index++;
    if (index !== open.length) {
        continue;
    }
    index = 0;
    const a = readNumber(iterator, ',');
    if (a === '') continue;
    const b = readNumber(iterator, ')');
    if (b === '') continue;
    const result = Number.parseInt(a) * Number.parseInt(b);
    console.log(`adding ${a}*${b}=${result}`);
    total += result;
}

console.log('total: ', total);

function readNumber(iterator: Iterable<string>, end: string) {
    let a = '';
    for (const char of iterator) {
        if (char === end) return a;

        // reach maxLength, next char wasn't end char
        if (a.length === 3) break;

        // @TODO are numbers allowed to start with 0?
        if (!numbers.has(char)) break;

        a += char;
    }
    return '';
}
