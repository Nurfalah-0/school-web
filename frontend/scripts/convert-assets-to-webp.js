import fs from 'fs';
import path from 'path';
import sharp from 'sharp';

const root = process.cwd();
const assets = [
  'src/assets/logo.png',
  'src/assets/hero-lab.jpg',
  'src/assets/hero-bintang.jpg',
  'src/assets/profile-penobatan.jpg',
  'src/assets/profile-bintang.jpg'
];

async function convertImage(filePath) {
  const inputPath = path.resolve(root, filePath);
  const outputPath = inputPath.replace(/\.(png|jpe?g)$/i, '.webp');

  if (!fs.existsSync(inputPath)) {
    console.warn(`Skip missing file: ${filePath}`);
    return;
  }

  await sharp(inputPath)
    .webp({ quality: 80, effort: 6 })
    .toFile(outputPath);

  console.log(`Converted ${filePath} → ${path.relative(root, outputPath)}`);
}

(async () => {
  try {
    await Promise.all(assets.map(convertImage));
    console.log('All images converted to WebP.');
  } catch (error) {
    console.error('Image conversion failed:', error);
    process.exit(1);
  }
})();
