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

# 发布：向公开仓库追加一个发布提交（父提交 = 远端 main 当前指向；空仓库则建根提交），
# 历史线性追加，不强推。公开历史的基线是 2026-11-23 的一次性单根提交初始化。
MSG ?= 更新主题内容
publish:
	@cd "$(shell git rev-parse --show-toplevel)" && \
	 TREE=$$(git rev-parse "HEAD:$(SUBTREE_PREFIX)") && \
	 PARENT=$$(git ls-remote $(THEME_REPO) refs/heads/main | cut -f1) && \
	 if [ -n "$$PARENT" ]; then PFLAGS="-p $$PARENT"; else PFLAGS=""; fi && \
	 NEW=$$(git commit-tree $$TREE $$PFLAGS -m "$(MSG)") && \
	 git push $(THEME_REPO) "$$NEW":refs/heads/main && \
	 echo "已发布 $$NEW → $(THEME_REPO) main"
