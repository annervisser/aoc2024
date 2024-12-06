import * as fs from 'node:fs/promises';

const input = await fs.readFile(`${import.meta.dirname}/day04.sample.txt`, {encoding: 'utf-8'});

const grid = input.trim().split('\n').map(line => line.split(''));
const height = grid.length;
const width = grid[0].length;

function part1() {
    let count = 0;

    for (let y = 0; y < height; y++) {
        for (let x = 0; x < width; x++) {
            const letter = grid[y][x];
            if (letter === 'X') {
                count += findMAS(y, x)
            }
        }
    }

    console.log('part 1: ', count);
}

type Offset = readonly [number, number];
const onesidedDirections = [
    [[-1, 1], [-2, 2], [-3, 3]], // ↗
    [[0, 1], [0, 2], [0, 3]], // →
    [[1, 1], [2, 2], [3, 3]], // ↘
    [[1, 0], [2, 0], [3, 0]], // ↓
] satisfies ([Offset, Offset, Offset][]);
const directions = [
    ...onesidedDirections,
    ...onesidedDirections.map(dir => dir.map(([x, y]): Offset => [x * -1, y * -1])),
];

const MAS = 'MAS';

function findMAS(y: number, x: number) {
    return directions.filter(
        direction => direction.every(([dy, dx], i) => {
            return (grid[y + dy]?.[x + dx] ?? '') === MAS[i];
        })
    ).length;
}


function part2() {
    let count = 0;

    for (let y = 0; y < height; y++) {
        for (let x = 0; x < width; x++) {
            const letter = grid[y][x];
            if (letter === 'A') {
                count += (findCrossMAS(y, x) ? 1 : 0)
            }
        }
    }

    console.log('Part 2: ', count);
}

const cross = [
    [[-1, -1], [1, 1]],
    [[1, 1], [-1, -1]],
    [[1, -1], [-1, 1]],
    [[-1, 1], [1, -1]],
] satisfies ([Offset, Offset][]);

function findCrossMAS(y: number, x: number) {
    return cross.filter(
        ([[mdy, mdx], [sdy, sdx]]) => {
            return (grid[y + mdy]?.[x + mdx] ?? '') === 'M' && (grid[y + sdy]?.[x + sdx] ?? '') === 'S';
        }
    ).length === 2;
}

part1();
part2();