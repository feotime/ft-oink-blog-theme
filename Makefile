HUGO ?= hugo
BIND ?= 127.0.0.1
PORT ?= 1314

# 主题发布仓库（`make publish` 用 git subtree 把本子目录推成独立仓库）。
THEME_REPO ?= git@github.com:feotime/ft-oink-blog-theme.git
# 本主题在站点仓库内的子目录前缀（相对站点仓库根）。
SUBTREE_PREFIX ?= ft-blog/ft-oink-blog-theme

# 维护者离线预览：exampleSite 发布形态按 module path 走模块代理；
# 这里用环境变量把两个模块替换到本地目录（站点仓库的 vendored 上游副本
# 与主题自身），因此无网络也能预览。注意替换目标必须是绝对路径。
.PHONY: example build-example publish
example:
	HUGO_MODULE_REPLACEMENTS='github.com/pgsty/oink -> $(abspath ../oink),github.com/feotime/ft-oink-blog-theme -> $(abspath .)' \
		$(HUGO) server --source exampleSite --bind $(BIND) --port $(PORT)

build-example:
	HUGO_MODULE_REPLACEMENTS='github.com/pgsty/oink -> $(abspath ../oink),github.com/feotime/ft-oink-blog-theme -> $(abspath .)' \
		$(HUGO) --source exampleSite --cleanDestinationDir --gc --minify --environment production

# 发布：公开仓库永远保持"单一根提交"——每次发布用 commit-tree 从当前
# 子目录树整体生成一个全新根提交，强推覆盖（在站点仓库根执行）。
# 打 tag 见 README「发布说明」。
publish:
	@cd "$(shell git rev-parse --show-toplevel)" && \
	 TREE=$$(git rev-parse $(SUBTREE_PREFIX)^{tree}) && \
	 NEW=$$(git commit-tree $$TREE -m "feat: ft-oink-blog-theme —— 基于 OINK 的极简中文博客主题") && \
	 git push -f $(THEME_REPO) "$$NEW":refs/heads/main && \
	 echo "已发布根提交 $$NEW → $(THEME_REPO) main"
