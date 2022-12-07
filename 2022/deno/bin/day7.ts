import { Answer, inputFromLines, runDay } from "../lib.ts";

runDay(7, day, [{
  input: `
$ cd /
$ ls
dir a
14848514 b.txt
8504156 c.dat
dir d
$ cd a
$ ls
dir e
29116 f
2557 g
62596 h.lst
$ cd e
$ ls
584 i
$ cd ..
$ cd ..
$ cd d
$ ls
4060174 j
8033020 d.log
5626152 d.ext
7214296 k`,
  answer: [95437, 24933642],
}]);

interface Folder {
  path: string;
  files: { name: string; size: number }[];
  subDirs: Record<string, Folder>;
}

function folderSize(f: Folder, pathCache: Record<string, number>): number {
  if (pathCache[f.path] !== undefined) return pathCache[f.path];

  const size = f.files.reduce((total, x) => total + x.size, 0) +
    Object.values(f.subDirs).reduce(
      (total, x) => total + folderSize(x, pathCache),
      0,
    );

  pathCache[f.path] = size;
  return size;
}

function day(input: string): Answer {
  const root: Folder = { path: "/", files: [], subDirs: {} };
  let dir: Folder = root;
  let parents: Folder[] = [];

  const lines = inputFromLines(input).reverse();
  while (lines.length > 0) {
    const command = lines.pop()!;
    if (command === "$ ls") {
      while ((lines.length > 0) && !(lines[lines.length - 1].startsWith("$"))) {
        const entry = lines.pop()!;
        if (entry.startsWith("dir ")) {
          const name = entry.slice(4);
          dir.subDirs[name] = {
            path: `${dir.path}${name}/`,
            files: [],
            subDirs: {},
          };
        } else {
          const [size, name] = entry.split(" ");
          dir.files.push({ name, size: parseInt(size) });
        }
      }
    } else if (command === "$ cd ..") {
      dir = parents.pop()!;
    } else if (command === "$ cd /") {
      dir = root;
      parents = [];
    } else if (command.startsWith("$ cd ")) {
      parents.push(dir);
      dir = dir.subDirs[command.slice(5)];
    } else {
      console.log(`Error: unexpected command: ${command}`);
    }
  }

  // console.log(JSON.stringify(root, null, 2));
  const allSizes: Record<string, number> = {};
  const rootSize = folderSize(root, allSizes);
  const partOne = Object.values(allSizes)
    .filter((x) => x <= 100000)
    .reduce((a, b) => a + b);

  const neededSpace = 30000000 - (70000000 - rootSize);
  const partTwo = Object.values(allSizes)
    .filter((x) => x >= neededSpace)
    .sort().at(0)!;
  return [partOne, partTwo];
}
