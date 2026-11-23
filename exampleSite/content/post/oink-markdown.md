---
title: OINK 写作组件速查
linkTitle: 写作组件速查
date: 2026-10-31
description: 写文章时常用的 OINK Markdown 扩展写法：提示块、标签页、步骤、技术表、图表。保留这页当速查手册。
tags: [OINK, Markdown]
---

这页汇总写文章时最常用的扩展写法。所有写法在 GitHub 或普通 Markdown 阅读器中都会退化成普通表格、列表或代码块，内容不丢失。完整组件列表见 [OINK 文档](https://oink.pgsty.com/zh/docs/components/)。

## 提示块 {#callouts}

直接写块引用加语义标记，共十种类型（`NOTE` `TIP` `IMPORTANT` `WARNING` `CAUTION` 等）：

> [!NOTE]
> 普通提示，补充说明用。

> [!WARNING]
> 警告读者别做某件事。

## 标签页 {#tabs}

相邻的代码围栏各带一个 `{tab=}` 属性，自动合并成一组标签页：

```bash {tab=macOS}
brew install hugo
```

```bash {tab=Linux}
snap install hugo
```

## 步骤 {#steps}

有序列表加一行 `{.steps}`，渲染成带编号的流程：

1. 新建文件
1. 写好 front matter
1. 本地预览，然后发布
{.steps}

## 技术表 {#fields}

GFM 表格加一行 `{.fields}`，渲染成参数说明表，窄屏自动适配：

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `title` | string | — | 站名，显示在导航栏与标题栏 |
| `date` | date | — | 发布日期，决定列表顺序与 RSS 时间 |
| `draft` | bool | `false` | `true` 时默认不构建 |
{.fields}

## 图表 {#diagrams}

Mermaid 围栏直接写图表，资源本地分发：

```mermaid
graph LR
    A[写 Markdown] --> B[hugo server 预览]
    B --> C[git push]
    C --> D[CI 自动发布]
```

## 代码块增强 {#code}

围栏属性控制标题、行号、折叠与高亮：

```yaml {title="hugo.yaml" linenos=table}
baseURL: https://example.org/
```

## 图片 {#image}

图片下一行写属性即可获得图注与缩放：

![占位图](https://placehold.co/900x450/eee/999?text=Your+Image)
{width="720" caption="写 caption 属性就有图注，点击可放大"}
