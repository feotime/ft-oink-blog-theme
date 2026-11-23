---
title: 你好，世界
date: 2026-10-31
description: 博客的第一篇文章：这个站点从 OINK Starter 裁剪而来，只保留博客与中文。
tags: [博客, OINK]
---

这是博客的第一篇文章。站点基于 [OINK](https://oink.pgsty.com/zh/)——一个本地优先、仅依赖 Hugo 的文档主题——裁剪而来，只保留了博客栏目和中文。

## 为什么是 Hugo + OINK {#why}

- 一条 `hugo` 命令完成构建，不需要 Node 工具链；
- 字体、搜索、图表运行时全部随主题本地分发，没有 CDN 依赖；
- 写作就是写 Markdown，在任何编辑器里都能进行。

## 日常写作流程 {#workflow}

1. 在 `content/post/` 下新建一个 `.md` 文件；
2. 填好 front matter（至少 `title` 和 `date`）；
3. `hugo server` 边写边看；
4. 写完提交推送，CI 自动构建发布。

## 接下来 {#next}

把首页和「关于」页里的占位内容换成自己的，然后开始写第一篇正式文章。
