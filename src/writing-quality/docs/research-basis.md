# 科学的根拠 — 検証済み文献レポート

[principles.md](./principles.md) のチェックリストの根拠となる文献一覧。

2026-07-04 時点で、deep-research ワークフロー（5 検索アングル → 23 ソース取得 → 108 主張抽出 → 上位 25 件に 3 票の敵対的検証 → 23 件確認・2 件棄却）と追加検証エージェントにより、**全文献の DOI/URL・書誌・主要数値を実在確認済み**（例外は個別に「未確認」と明記）。査読論文 / プレプリント / 企業調査を明確に区別する。

## 全体像 — 読みづらさを説明する 3 系統のメカニズム

1. **認知負荷理論**: extraneous load は内容の難しさではなく「提示のされ方」で決まり、無関連・冗長情報は処理コストを増やす（メタ分析 2 本で確認）。
2. **談話理解**: 読み手はテキストではなく状況モデルを構築しており、結束性の低いテキストは橋渡し推論を強制し、その負担は低知識読者に非対称に落ちる。
3. **情報過多**: 情報量が処理容量を超えると意思決定パフォーマンスは逆 U 字で悪化する。

これに加えて、AI テキストが実際に「高名詞化・高語彙密度・低語彙多様性」の重い文体を持つことが実証されている（領域 4）。

**最重要の限界**: 領域 1〜3 の証拠は教育・物語読解・組織研究の文脈で得られたもので、「AI 生成ビジネス文書の読みづらさ」を直接検証した査読研究は存在しない（2026-07 時点）。理論と AI 文書の接続は類推的橋渡しである。

## 領域 1: 認知負荷理論 / extraneous cognitive load（すべて査読済み）

- **Sweller, van Merriënboer & Paas (1998). Cognitive Architecture and Instructional Design.** Educational Psychology Review 10(3):251–296. DOI: 10.1023/A:1022193728205. レビュー。理論土台: 容量制限のあるワーキングメモリ + 事実上無制限の長期記憶。提示形式が処理負荷を左右する。限界: 教育文脈由来。優先度: 高。
- **Sweller, van Merriënboer & Paas (2019). Cognitive Architecture and Instructional Design: 20 Years Later.** Educational Psychology Review 31:261–292. DOI: 10.1007/s10648-019-09465-5. レビュー。「extraneous load は情報の内在的複雑さではなく提示のされ方で決まる」（verbatim 確認済み）。redundancy effect の説明もここで確認。優先度: 高。
- **Sweller (2010). Element Interactivity and Intrinsic, Extraneous, and Germane Cognitive Load.** Educational Psychology Review 22(2):123–138. DOI: 10.1007/s10648-010-9128-5. 理論。認知負荷は要素間相互作用性で決まる。相互作用性は読み手の既有知識に相対的。優先度: 中。
- **Sweller (2023). The Development of Cognitive Load Theory: Replication Crises and Incorporation of Other Theories…** Educational Psychology Review 35(95). DOI: 10.1007/s10648-023-09817-2. 理論レビュー。CLT の現代的定式化。優先度: 中。
- **Sundararajan & Adesope (2020). Keep it Coherent: A Meta-Analysis of the Seductive Details Effect.** Educational Psychology Review 32:707–734. DOI: 10.1007/s10648-020-09522-4. メタ分析（68 効果量）。無関連情報は学習を有意に阻害（g=−0.33）。限界: 学習文脈からビジネス文書への拡張は橋渡し。優先度: 高。
- **Cheng, Wu, Wang & Wang (2026). Seductive Details, Cognitive Load, and Learning Outcomes: A Multi-level Meta-analysis and MASEM.** Educational Psychology Review 38(1), Article 28. DOI: 10.1007/s10648-025-10099-z（DOI 中の「2025」は登録年）。メタ分析（177 効果量）。負の効果を再現（総合 g=−0.16、理解 g=−0.19）。MASEM により効果が主に extraneous load を媒介することを示した。優先度: 高。
- **Skulmowski & Xu (2022). Understanding Cognitive Load in Digital and Online Learning.** Educational Psychology Review 34. DOI: 10.1007/s10648-021-09624-7. レビュー。「extraneous load は常に最小化すべき」という前提への挑戦。過度な単純化の防止に使う。優先度: 中。
- **Noetel et al. (2022). Multimedia Design for Learning: An Overview of Reviews With Meta-Meta-Analysis.** Review of Educational Research 92(3):413–454. DOI: 10.3102/00346543211052329. 29 のシステマティックレビューの統合。「提示設計が理解と負荷を左右する」ことの最大規模の証拠。⚠️ coherence principle / verbal redundancy の個別裏付けとしての引用は敵対的検証で否決（0-3）— 使用禁止。優先度: 中。

## 領域 2: 談話理解 / 状況モデル（すべて査読済み）

- **Zwaan & Radvansky (1998). Situation Models in Language Comprehension and Memory.** Psychological Bulletin 123(2):162–185. DOI: 10.1037/0033-2909.123.2.162. レビュー。文章理解 = 状況モデル（時間・空間・因果・意図・主人公の 5 次元）の構築。「読みづらさ = 表層の流暢さではなく状況モデル構築の困難」という枠組み。優先度: 高。
- **Ehrlich & Johnson-Laird (1982). Spatial descriptions and referential continuity.** Journal of Verbal Learning and Verbal Behavior 21(3):296–306. DOI: 10.1016/S0022-5371(82)90626-0. 実験。参照的に不連続な記述は理解に時間がかかる（モデル更新不能 → 再構築）。注意: 測度は聴取時間であり「読み時間」は二次レビューの言い換え。優先度: 中。
- **McNamara & Kintsch (1996). Learning from texts: Effects of prior knowledge and text coherence.** Discourse Processes 22(3):247–288. DOI: 10.1080/01638539609544975. 実験。低結束テキストは橋渡し推論を強制し、成功するのは高知識読者のみ。reverse cohesion effect も検出 —「滑らかな文 = 常に良い」は不成立。優先度: 高。
- **O'Reilly & McNamara (2007). Reversing the Reverse Cohesion Effect.** Discourse Processes 43(2):121–152. DOI: 10.1080/01638530709336895. 実験。reverse cohesion effect を読解スキルで限定。「低知識読者は結束性ギャップで不利」という中核は一貫して再現。優先度: 中。
- **Graesser, Singer & Trabasso (1994). Constructing inferences during narrative text comprehension.** Psychological Review 101(3):371–395. PMID: 7938337（https://pubmed.ncbi.nlm.nih.gov/7938337/）。理論。読み手は「意味の探索」原理に従い、各内容の言及理由を説明する表象を構築しようとする。存在理由を説明できない内容は推論コストを課すか理解放棄を招く。優先度: 高。

## 領域 3: 情報過多（すべて査読済み）

- **Eppler & Mengis (2004). The Concept of Information Overload.** The Information Society 20(5):325–344. DOI: 10.1080/01972240490507974. レビュー（被引用 1,441）。情報過多 =「情報量が受け手の処理能力を超えた状態」。情報量と意思決定パフォーマンスは逆 U 字。優先度: 高。
- **Roetzel (2019). Information overload in the information age.** Business Research 12(2):479–522. DOI: 10.1007/s40685-018-0069-z. レビュー。経営学系の統合とフレームワーク開発。優先度: 中。
- **Arnold, Goldschmitt & Rigotti (2023). Dealing with information overload: a comprehensive review.** Frontiers in Psychology 14:1122200. DOI: 10.3389/fpsyg.2023.1122200. レビュー。枠組みの 2020 年代での再確認。優先度: 中。

## 領域 4: AI 生成テキストの言語特徴（実証研究）

- **Zou, Kuek, Ng & Cheng (2026). Comparative analysis of text readability and writing styles in AI-generated vs. Human-written academic abstracts.** PLOS ONE 21(4):e0343163. DOI: 10.1371/journal.pone.0343163. 査読済コーパス比較。AI 生成は Flesch Reading Ease が有意に低く（11.50 vs 17.00）、語彙密度が高く、語彙多様性が低い。限界: 単一 AI モデル（Kimi）・2 分野のみ。優先度: 高。
- **Reinhart et al. (2025). Do LLMs write like humans? Variation in grammatical and rhetorical styles.** PNAS 122(8):e2422455122. DOI: 10.1073/pnas.2422455122. 査読済（並列コーパス + Biber 多次元分析）。LLM は現在分詞節を人間の 2〜5 倍、名詞化を 1.5〜2 倍使用。特徴語を 100 倍以上使用。instruction tuning が乖離を拡大。限界: 読み手の理解・負荷は未測定。優先度: 高。
- **Muñoz-Ortiz, Gómez-Rodríguez & Vilares (2024). Contrasting Linguistic Patterns in Human and LLM-Generated News Text.** Artificial Intelligence Review 57:265. DOI: 10.1007/s10462-024-10903-2. 査読済。人間の方が語彙が豊かで文長分布が広い。LLM は感情的に中立〜肯定寄り。優先度: 中。
- **Herbold et al. (2023). A large-scale comparison of human-written versus ChatGPT-generated essays.** Scientific Reports 13:18617. DOI: 10.1038/s41598-023-45644-9. 査読済。⚠️ **逆方向の知見**: 教師評価では ChatGPT-4 エッセイの方が高評価。「AI 文書 = 読みにくい」の単純化への反証。「よく書けている」評価と「読み手の処理負荷」は別次元である点に注意。優先度: 中。
- **Rodrigues, Sturm & Pinheiro (2026). A linguistic comparison between human- and AI-generated content.** iScience 29(3):114976. DOI: 10.1016/j.isci.2026.114976. 査読済（LIWC 分析）。AI は形式的で、肯定的感情表現が 114〜133% 増、認知的確実性マーカー増。限界: ポルトガル語ニュースのみ。優先度: 中。
- **Ilyas et al. (2025). Reading the Readers Mind through Eye Tracking: Can AI Generated Texts Match Human Authors?** ACM ETRA '25. DOI: 10.1145/3715669.3726846. 査読済会議録（視線計測）。AI テキストではスキミング傾向。限界: n=12 の小規模。**内容詳細は一部未確認**（実在は 3 経路で確認済みだが数値詳細は二次ソース経由）。優先度: 中。
- **Bolliger et al. (2025). EMTeC: A corpus of eye movements on machine-generated texts.** Behavior Research Methods. DOI: 10.3758/s13428-025-02677-4. 査読済リソース論文（107 名の眼球運動コーパス）。知見主張の根拠としては引用不可。優先度: 低。
- **Nkhobo & Chaka (2023). Student-Written versus ChatGPT-Generated Discursive Essays.** IJEDICT 19(3):69–84. ERIC: EJ1413432（DOI 未確認）。査読済・小規模。結束性の比較で統計的有意差なし —「AI の結束性劣位」の根拠としては使えない。優先度: 低。

## 領域 5: 職場ライティングと生成 AI・workslop

### 査読論文

- **Noy & Zhang (2023). Experimental evidence on the productivity effects of generative artificial intelligence.** Science 381(6654):187–192. DOI: 10.1126/science.adh2586. 事前登録 RCT（n=453）。ChatGPT 利用で所要時間 −40%・品質 +18%。「AI で文書が速く大量に作られる」という受け手側過負荷議論の前提。受け手側のコストは未測定。優先度: 高。
- **Brynjolfsson, Li & Raymond (2025). Generative AI at Work.** Quarterly Journal of Economics 140(2):889–942（初出 NBER WP 31161）。準実験（n=5,172）。生産性平均 +15%、低スキル層ほど向上。優先度: 中。
- **Dell'Acqua et al. (2026). Navigating the Jagged Technological Frontier.** Organization Science 37(2). DOI: 10.1287/orsc.2025.21838（初出 HBS WP 24-013, 2023）。フィールド実験（BCG コンサルタント n=758）。AI 能力範囲内では速度 +25.1%・品質向上、範囲外では正答確率 19pt **低下** — workslop 発生条件の示唆。優先度: 中。

### プレプリント（未査読）

- **Kosmyna et al. (2025). Your Brain on ChatGPT.** arXiv:2506.08872. **プレプリント・未査読**。EEG 比較で LLM 使用時は脳内結合が最弱（「認知的負債」）。限界: 小規模（鍵となる条件交差は n=18）・方法論的批判あり。引用時は必ずプレプリントと明記。優先度: 中。

### 企業調査・実務誌記事（査読研究と混同しないこと）

- **Niederhoffer, Kellerman, Lee, Liebscher, Rapuano & Hancock (2025). AI-Generated "Workslop" Is Destroying Productivity.** Harvard Business Review, 2025-09-22. https://hbr.org/2025/09/ai-generated-workslop-is-destroying-productivity — **実務誌記事（査読なし）**。workslop 概念の一次出典。
- **BetterUp Labs × Stanford Social Media Lab (2025). Workslop 調査.** https://www.betterup.com/workslop — **企業調査（非査読サーベイ、n=1,150）**。受領率 40%（直近 1 ヶ月）・1 件あたり対処約 2 時間・1 人あたり月 $186 と推計。限界: 方法論詳細非公開・BetterUp に利益相反の可能性。

## 引用時の注意（敵対的検証の結果）

1. **否決された主張（0-3）— 使用禁止**: (a) Noetel et al. 2022 を coherence principle / verbal redundancy の「頑健なメタ分析的証拠」として引くこと。(b) Mandler (1986) の語順不一致の読み時間例（Zwaan & Radvansky 内の引用）。
2. **redundancy effect は 2-1 の split vote**: 原パラダイムは「図 + テキストの二重ソース」であり、単一文書内の水増し散文への適用は類推。reverse redundancy effect と expertise reversal という境界条件を併記すること。
3. **転移ギャップ**: 「AI テキストの言語特徴の差 → 読み手の認知負荷増」の連結を直接実証した研究は 2026-07 時点で存在しない。この 2 段階は分けて主張する。
4. **数値の出所**: workslop 関連の数値（40%・2 時間・$186）はすべて企業サーベイ由来で、査読研究には存在しない。
