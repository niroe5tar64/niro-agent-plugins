/**
 * decision-support プラグインのビルドスクリプト
 *
 * テンプレートファイル内の {{include:path/to/file.md}} プレースホルダーを
 * 実際のファイル内容に展開し、commands/ ディレクトリに出力する。
 */

import { readdir, readFile, writeFile, mkdir } from "node:fs/promises";
import { join, dirname } from "node:path";

const PLUGIN_ROOT = dirname(dirname(import.meta.path));
const SRC_DIR = join(PLUGIN_ROOT, "src", "commands");
const OUT_DIR = join(PLUGIN_ROOT, "commands");
const TEMPLATE_EXT = ".template.md";
const INCLUDE_PATTERN = /\{\{include:(.+?)\}\}/g;

async function expandIncludes(
	content: string,
	basePath: string,
): Promise<string> {
	const matches = content.matchAll(INCLUDE_PATTERN);
	let result = content;

	for (const match of matches) {
		const [placeholder, relativePath] = match;
		const filePath = join(basePath, relativePath);

		try {
			const fileContent = await readFile(filePath, "utf-8");
			result = result.replace(placeholder, fileContent.trim());
		} catch (error) {
			console.error(`Failed to include: ${filePath}`);
			throw error;
		}
	}

	return result;
}

async function build(): Promise<void> {
	console.log("Building decision-support commands...");

	// 出力ディレクトリを作成
	await mkdir(OUT_DIR, { recursive: true });

	// テンプレートファイルを取得
	const files = await readdir(SRC_DIR);
	const templates = files.filter((f) => f.endsWith(TEMPLATE_EXT));

	for (const template of templates) {
		const inputPath = join(SRC_DIR, template);
		const outputName = template.replace(TEMPLATE_EXT, ".md");
		const outputPath = join(OUT_DIR, outputName);

		console.log(`  ${template} -> ${outputName}`);

		// テンプレートを読み込み
		const content = await readFile(inputPath, "utf-8");

		// インクルードを展開
		const expanded = await expandIncludes(content, PLUGIN_ROOT);

		// 出力
		await writeFile(outputPath, expanded, "utf-8");
	}

	console.log("Build complete!");
}

build().catch((error) => {
	console.error("Build failed:", error);
	process.exit(1);
});
