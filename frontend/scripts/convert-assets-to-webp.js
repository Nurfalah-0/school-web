import fs from 'fs';
import path from 'path';
import sharp from 'sharp';

const root = process.cwd();
const assetsDirectory = path.resolve(root, 'src/assets');
const sourceExtensions = new Set(['.png', '.jpg', '.jpeg', '.gif', '.bmp', '.tif', '.tiff']);

function findImageFiles(directory) {
  return fs.readdirSync(directory, { withFileTypes: true }).flatMap((entry) => {
    const entryPath = path.join(directory, entry.name);

    if (entry.isDirectory()) {
      return findImageFiles(entryPath);
    }

    return sourceExtensions.has(path.extname(entry.name).toLowerCase()) ? [entryPath] : [];
  });
}

async function convertImage(inputPath) {
  const outputPath = inputPath.replace(/\.[^.]+$/, '.webp');

  await sharp(inputPath)
    .webp({ quality: 82, effort: 6 })
    .toFile(outputPath);

  fs.unlinkSync(inputPath);
  console.log(`Converted ${path.relative(root, inputPath)} -> ${path.relative(root, outputPath)}`);
}

(async () => {
  try {
    const assets = findImageFiles(assetsDirectory);
    await Promise.all(assets.map(convertImage));
    console.log(`Converted ${assets.length} image${assets.length === 1 ? '' : 's'} to WebP.`);
  } catch (error) {
    console.error('Image conversion failed:', error);
    process.exit(1);
  }
})();
