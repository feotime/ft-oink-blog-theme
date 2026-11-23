# ft-oink-blog-theme

English | [简体中文](README.zh-cn.md)

A minimal personal blog theme built as a **thin layer** on [OINK](https://github.com/pgsty/oink) — a local-first, Hugo-only documentation framework. The layer turns OINK's docs-first shell into a writing-first blog:

- **List-first home**: a one-line intro on top, then a minimal timeline grouped by year (tabular dates · titles · #tags), paginated
- **Single-column reading**: no sidebar, no breadcrumbs; a 46rem centered measure with 17px/1.85 line-height tuned for long-form Chinese; optional floating TOC on wide screens (hidden below xl)
- **Offline full-text search**: build-time JSON index; CJK matches by literal substring, IME-safe, with keyword highlighting and section deep links; searchable from every page (`Cmd+K` / `/`)
- **Archives & tags**: a full timeline archive page; a quiet text list for the tag index, and each tag page is a filtered timeline
- **Dark mode**: follows the system, manually switchable; every color goes through CSS tokens
- **Localized UI**: theme strings ship in English, Simplified Chinese and Traditional Chinese — follow your Hugo language config and everything (greetings, counters, links, article meta) is translated
- **AI-friendly**: every page also emits `.md`; the home page emits `llms.txt` (inherited from OINK)

Warm-paper visual基调 on OINK's `paper` preset, Apache-2.0. The word "thin" is literal: the theme overrides about ten templates and one stylesheet, so upstream upgrades flow through the module chain automatically.

## Requirements

- Hugo Extended ≥ 0.168.0 (`brew install go hugo`), Go ≥ 1.21
- No Node.js / npm

## Quick start

```bash
hugo new site my-blog && cd my-blog
hugo mod init github.com/you/my-blog
```

Minimal `hugo.yaml`:

```yaml
title: My Blog
baseURL: https://example.org/        # change to your production URL
defaultContentLanguage: zh           # en for an English site
enableGitInfo: true
timeZone: Asia/Shanghai

languages:
  zh:
    label: 简体中文
    locale: zh-CN
    weight: 1
    title: My Blog
    hasCJKLanguage: true
    params:
      description: One-line introduction.

params:
  copyright:
    authors: Your Name               # footer credit + home identity line ("Hi, I'm …")

# OINK's Markdown components rely on these Goldmark settings — keep them.
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

# Every page additionally emits .md; the home page emits llms.txt (optional)
outputs:
  home: [HTML, RSS, markdown, LLMS]
  page: [HTML, markdown]
  section: [HTML, RSS, print, markdown]

module:
  imports:
    - path: github.com/feotime/ft-oink-blog-theme
```

> Note: `copyright` above must live **under `params`** — OINK reads `params.copyright.authors`. Hugo's root-level `copyright` key is a plain string and will fail type validation with a map.

Content layout (the key part: the post section's `_index.md` declares `type: blog` via cascade):

```
content/
├── _index.md          # home: title + description (the one-line intro)
├── about.md           # about page (menus.main)
├── archives.md        # archive page: layout: archives + menus.main
├── tags/_index.md     # tag index: title + menus.main
└── post/
    ├── _index.md      # cascade: type: blog / sidebar_enabled: false / breadcrumb: false …
    └── my-first-post.md
```

Copy the full cascade from [exampleSite/content/post/_index.md](exampleSite/content/post/_index.md). Then:

```bash
hugo server
```

## Internationalization

The theme follows Hugo's language configuration — there is no theme-specific language switch. Set `defaultContentLanguage: en` with English content and all theme strings come out in English (built-in: `en`, `zh`, `zh-cn`, `zh-tw`). The identity line on the home page is derived as `Hi, I'm <copyright.authors>` (localized) unless you set `params.ui.intro_identity` explicitly.

## Configuration reference

Theme defaults live in [hugo.yaml](hugo.yaml); site config keys win. The common ones:

| Param | Default | Notes |
|---|---|---|
| `ui.preset` | `paper` | Visual baseline (warm paper), overridden by the design layer |
| `ui.preset_menu` | `false` | Hides the preset switcher; dark-mode toggle stays in the appearance menu |
| `ui.dark_mode` | `true` | Dark mode + toggle |
| `ui.home_intro` | `identity` | Home intro layout: `title` (site name as heading) / `identity` (greeting heading, recommended) / `slogan` (description as the heading) / `compact` (single quiet line) |
| `ui.intro_identity` | derived from `copyright.authors` | Identity line text used by identity/slogan/compact |
| `ui.blog_section` | `post` | Section that holds the posts |
| `ui.blog_index` / `blog_index_size` | `list` / `12` | `/post/` listing form and page size |
| `ui.footer_style` | `slim` | Footer variant |
| `ui.featured_image` | unset | Featured image mode: `banner / wash / hero` |
| `offline_search` | `true` | Offline full-text search (build-time index) |

The full OINK parameter surface (giscus comments, share buttons, code copy, galleries…) is documented at [oink.pgsty.com](https://oink.pgsty.com/).

## Customization

- **Site name / logo / favicon**: put files at `assets/icons/logo.svg` and `static/favicon.svg` in your site — same-path files shadow the theme and upstream.
- **Extra styles**: create `assets/scss/_styles_project.scss` in your site (the last import of OINK's stylesheet, applied after this theme's design layer).
- **Template tweaks**: create same-path files under your site's `layouts/**` to shadow this theme; shadow upstream the same way.
- **Accent color**: set `params.ui.theme_color: "#hex"` in your site (an OINK mechanism with contrast checks).

## Preview the theme itself

```bash
make example        # serves exampleSite at http://127.0.0.1:1314
```

The committed exampleSite config resolves modules by path (via the module proxy), so a fresh clone just works; `make example` additionally injects local replacements for maintainer preview.

## Directory layout

```
layouts/                 # template overrides over OINK (home / archives / tags / article head / flat shells / timeline)
i18n/                    # theme UI strings (en, zh, zh-cn, zh-tw)
assets/scss/_styles_project.scss   # design layer: token tuning + CJK typography + ft-* components
exampleSite/             # minimal example site
hugo.yaml                # depends on upstream OINK + default params
```

## Upgrading upstream

The theme depends on OINK through the Hugo module chain, so upgrading is one command; each override file carries a header comment describing what to re-check:

```bash
hugo mod get -u github.com/pgsty/oink
```

## Release notes (maintainers)

The theme source lives in the `ft-oink-blog-theme/` subdirectory of the blog repository (plain files — the site build and CI depend on it directly). The public repo keeps a **linear, append-only** history: it was initialized as a single root commit (a one-time cleanup of the internal history) and each release appends one commit on top, never force-pushed.

```bash
# 0. Create an empty PUBLIC repo on GitHub (do not initialize README/LICENSE).

# 1. Publish main (run inside the theme directory; appends a release commit
#    whose parent is the remote main):
make publish                              # or: make publish MSG="feat: what changed"

# 2. Tag the release (the tag points at remote main's current commit):
SHA=$(git ls-remote git@github.com:feotime/ft-oink-blog-theme.git refs/heads/main | cut -f1)
git tag v0.1.3 "$SHA"
git push git@github.com:feotime/ft-oink-blog-theme.git v0.1.3

# 3. For every theme change afterwards: commit into the blog repo → make publish → repeat step 2 with a new version.
```

Do **not** move a published tag — the module proxy permanently caches the "version → commit" mapping and moving it breaks consumers; publish a new version instead.
`feotime` is a placeholder GitHub username; when the repo address changes, update `THEME_REPO` in the Makefile plus the links in theme.toml and this README. This blog's own build never depends on publishing (local-directory import, see the blog repo's AGENTS.md); external users follow "Quick start" via the module path and never see the subdirectory.

## Acknowledgements & license

[Docsy](https://github.com/google/docsy) → [OINK](https://github.com/pgsty/oink) → this theme. The whole chain is Apache-2.0; see [LICENSE](LICENSE) and [NOTICE](NOTICE).
