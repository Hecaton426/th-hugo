# th-hugo
Docker build for hugo static site generator


The version number is based on <source hugo version>-<our version of build>. The Hugo version is set by
`HUGO_VERSION` in the Dockerfile (official upstream release, not the Alpine package), so keep the tag in step with it.
```bash
docker buildx prune
docker buildx build --platform linux/amd64,linux/arm64 -t davidcluer/hugo:0.170.1-1.2.0 . --push
```
