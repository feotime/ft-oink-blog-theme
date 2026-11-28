# ft-oink-blog-theme

[English](README.md) | 简体中文

基于 [OINK](https://github.com/pgsty/oink) 的极简个人博客主题。OINK 是本地优先、仅依赖 Hugo 的文档框架；本主题用一层薄薄的覆盖把它改造成「写作优先」的博客：

- **列表即首页**：顶部一句话简介 + 按年分组的极简时间线（日期等宽字体 · 标题 · #标签），分页
- **单栏沉浸阅读**：文章页无侧栏、无面包屑，46rem 栏宽居中，17px/1.85 行高的中文长文排版；宽屏右侧悬浮目录（窄屏自动隐藏）
- **中文全文检索**：构建时生成 JSON 索引，中文按连续子串匹配，拼音输入法安全，结果带关键词高亮与章节深链；导航栏每页可搜（`Cmd+K` / `/`）
- **归档与标签**：归档页全量时间线；标签总览是安静文本列表，单个标签页是过滤时间线
- **暗色模式**：跟随系统，可手动切换；全部颜色走 CSS 令牌，无硬编码
- **界面多语言**：主题文案内置英文、简体中文、繁體中文——跟随 Hugo 语言配置自动切换（问候语、篇数、链接、文章元信息全部本地化）
- **对 AI 友好**：每页输出 `.md` 纯文本，首页输出 `llms.txt`（继承自 OINK）
- 暖纸·墨色视觉基调（paper 预设 + 设计层令牌覆盖），Apache-2.0

架构上它是 OINK 的**薄封装**：只覆盖十来个模板文件和一个样式层，上游升级随模块链自动透传。

## 环境

- Hugo Extended ≥ 0.168.0（`brew install go hugo`），Go ≥ 1.21
- 不需要 Node.js / npm

## 快速开始

```bash
hugo new site my-blog && cd my-blog
hugo mod init github.com/you/my-blog
```

`hugo.yaml` 最小配置：

```yaml
title: 我的博客
baseURL: https://example.org/        # 上线时改成真实域名
defaultContentLanguage: zh           # 英文站改为 en
enableGitInfo: true
timeZone: Asia/Shanghai

languages:
  zh:
    label: 简体中文
    locale: zh-CN
    weight: 1
    title: 我的博客
    hasCJKLanguage: true
    params:
      description: 一句话介绍。

params:
  copyright:
    authors: 你的名字                 # 页脚版权 + 首页身份行（"你好，我是 <authors>"）

# OINK 的 Markdown 组件依赖这组 Goldmark 设置，不要删。
markup:
  goldmark:
    renderer:
      unsafe: true
    parser:
      attribute:
        block: true
      wrapStandAloneImageWithinParagraph: false
  highlight:
    noClasses: false

# 每个页面额外输出 .md，首页输出 llms.txt（可按需删减）
outputs:
  home: [HTML, RSS, markdown, LLMS]
  page: [HTML, markdown]
  section: [HTML, RSS, print, markdown]

module:
  imports:
    - path: github.com/feotime/ft-oink-blog-theme
```

> 注意：`copyright` 必须放在 **`params` 下面**——OINK 读取的是 `params.copyright.authors`；Hugo 根级 `copyright` 是纯字符串键，写 map 会报类型错误。

内容结构（关键：文章 section 的 `_index.md` 通过 cascade 声明 `type: blog`）：

```
content/
├── _index.md          # 首页：设 home_html: true 后，正文（任意 HTML）即整个首页
├── about.md           # 关于页（menus.main 挂主导航）
├── archives.md        # 归档页：layout: archives + menus.main
├── tags/_index.md     # 标签导航：title + menus.main
└── blog/
    ├── _index.md      # /blog/ 时间线；cascade: type: blog / sidebar_enabled: false …
    └── my-first-post.md   # /blog/my-first-post/
```

`blog/_index.md` 的完整 cascade 直接抄 [exampleSite/content/blog/_index.md](exampleSite/content/blog/_index.md)。跑起来：

```bash
hugo server
```

## 国际化

主题文案跟随 Hugo 的语言配置——没有主题专属的语言开关。英文站设 `defaultContentLanguage: en` 并写英文内容即可，问候语、篇数、链接、文章元信息全部自动英文（内置 `en`、`zh`、`zh-cn`、`zh-tw`）。首页身份行默认按 `copyright.authors` 生成本地化问候语（英文站为 "Hi, I'm …"），也可用 `params.ui.intro_identity` 显式指定。

## 配置参考

主题默认值在 [hugo.yaml](hugo.yaml)，站点配置同名键覆盖。常用的：

| 参数 | 默认 | 说明 |
|---|---|---|
| `ui.preset` | `paper` | 视觉基调（暖纸·墨色），设计层覆盖锚定它 |
| `ui.preset_menu` | `false` | 关闭预设切换器；暗色开关保留在外观菜单 |
| `ui.dark_mode` | `true` | 暗色模式与切换按钮 |
| `ui.home_intro` | `identity` | 首页简介区格局：`title`（站名大标题）/ `identity`（身份行大标题，推荐）/ `slogan`（description 大标题主张）/ `compact`（一行极简） |
| `ui.intro_identity` | 由 `copyright.authors` 生成 | 身份行文案（identity/slogan/compact 三种格局使用） |
| `ui.blog_section` | `blog` | 文章所在 section；时间线位于 `/blog/` |
| `ui.blog_index` / `blog_index_size` | `list` / `12` | `/post/` 区块列表形态与每页篇数 |
| `ui.footer_style` | `slim` | 页脚形态 |
| `ui.featured_image` | 未设置 | 题图模式：`banner / wash / hero` |
| `offline_search` | `true` | 中文全文检索（构建时索引） |

继承 OINK 的完整参数面（评论 giscus、分享、代码复制、图库等）见
[OINK 文档](https://oink.pgsty.com/zh/)。

## 自定义首页与自定义页面

三种方式超越默认页面——都不需要改主题：

1. **自定义首页**：`content/_index.md` 设 `home_html: true`，正文写任意 HTML 即整个首页
   （主题已开启 Goldmark `unsafe`）。导航、页脚、检索、暗色模式保留；内容区不限宽、
   无默认排版。文章时间线位于 `/blog/`。
2. **自定义 HTML 页面**：任意内容文件声明 `layout: custom`，正文原样输出在站点外壳内
   （保留导航 + 页脚），不限宽——见
   [exampleSite/content/custom-html-demo.md](exampleSite/content/custom-html-demo.md)。
3. **Landing 页面**：`layout: landing` + `sections` 列表，可组合 OINK 的 22 种区块
   （hero、卡片、时间线、FAQ、步骤、metrics、markdown……）。条目是自带数据的 map：

   ```yaml
   ---
   title: 我的小站
   layout: landing
   sections:
     - type: hero
       title_lines: [我的小站]
       lead: 仅凭 front matter 拼出的完全自定义页面。
     - type: cards
       title: 我在做的事
       columns: 2
       items:
         - title: 一
           desc: …
         - title: 二
           desc: …
   ---
   ```

   也可以把区块数据放到 `data/landing/<key>.yaml`（`sections: [hero, cards]` 加同级
   `hero:` / `cards:` 键），页面里用 `landing: <key>` 引用。

## 自定义

- **站名 / logo / favicon**：站点 `assets/icons/logo.svg`、`static/favicon.svg` 同路径覆盖本主题与上游。
- **追加样式**：站点建 `assets/scss/_styles_project.scss`（OINK 主样式表的最后导入位，比主题设计层更晚生效）。
- **改模板**：站点建同路径文件覆盖本主题的 `layouts/**`；再往上一层同理可覆盖 OINK。
- **换强调色**：站点 `params.ui.theme_color: "#hex"`（OINK 机制，会校验对比度）。

## 本地预览主题自身

```bash
make example        # exampleSite 起本地服务 http://127.0.0.1:1314
```

exampleSite 的提交形态按 module path 走模块代理（第三方克隆即用）；`make example`
会通过环境变量把主题与上游 OINK 替换到维护者机器的本地副本，因此无网络也能预览。
第三方克隆本仓库后直接 `hugo server --source exampleSite` 即可（首次会下载模块）。

## 目录结构

```
layouts/                 # 对 OINK 的模板覆盖（首页/归档/标签/文章头/扁平外壳/时间线）
i18n/                    # 主题界面文案（en、zh、zh-cn、zh-tw）
assets/scss/_styles_project.scss   # 设计层：令牌微调 + 中文排版 + ft-* 组件
exampleSite/             # 最小示例站
hugo.yaml                # 依赖上游 OINK + 默认参数
```

## 升级上游

本主题通过 Hugo 模块链依赖 OINK，升级只需更新依赖版本；覆盖文件的回归清单见各文件头注释：

```bash
hugo mod get -u github.com/pgsty/oink
```

## 发布说明（维护者）

主题源码随博客仓库放在 `ft-oink-blog-theme/` 子目录（普通文件，站点构建与 CI 直接依赖它）。
公开仓库的历史是**线性追加**的：初始化为一个单根提交（2026-11-23，一次性清洗内部历史），
之后每次发布在其上追加一个发布提交，不强推。

```bash
# 0. 首次在 GitHub 建一个空公共仓库（不要初始化 README/LICENSE）。

# 1. 发布（在主题目录执行；自动以远端 main 为父提交追加一个发布提交）：
make publish                                # 或 make publish MSG="feat: 本次更新说明"

# 2. 打版本 tag 并推送（指向远端 main 的当前提交）：
SHA=$(git ls-remote git@github.com:feotime/ft-oink-blog-theme.git refs/heads/main | cut -f1)
git tag v0.1.3 "$SHA"
git push git@github.com:feotime/ft-oink-blog-theme.git v0.1.3

# 3. 之后每次改主题：提交进博客仓库 → make publish → 换个版本号重复第 2 步。
```

注意：已发布的 tag **不要移动**——模块代理会永久缓存"版本 → 提交"的映射，
移动会导致使用者校验失败；有新改动就发新版本号。
`feotime` 为占位 GitHub 用户名，仓库地址变更时同步改 Makefile 的 `THEME_REPO` 与
theme.toml / README 里的链接。本博客自己的构建不依赖发布（本地目录导入，见博客仓库
AGENTS.md）；外部使用者按「快速开始」走 module path，不感知子目录的存在。

## 致谢与许可

[Docsy](https://github.com/google/docsy) → [OINK](https://github.com/pgsty/oink) → 本主题。整条链均为 Apache-2.0，详见 [LICENSE](LICENSE) 与 [NOTICE](NOTICE)。
