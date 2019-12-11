prepare:
	cd ./src && npm install --pure-lockfile

build: build.light build.light.audio build.light.audio-eme build.light.eme build.light.subs build.light.subs-audio build.light.subs-eme build.full

build.full:
	cd ./src && npm run build -- --env.dist
	cd ./src && npm run build -- --env.debug

	mkdir -p ./dist

	cp -f ./src/dist/hls.js ./dist/hls.js
	cp -f ./src/dist/hls.js.map ./dist/hls.js.map
	cp -f ./src/dist/hls.min.js ./dist/hls.min.js
	cp -f ./src/dist/hls.min.js.map ./dist/hls.min.js.map

	rm -rf ./src/dist

build.light:
	$(call build,,)

build.light.subs:
	$(call build,.subs,USE_SUBTITLES=true)

build.light.audio:
	$(call build,.audio,USE_ALT_AUDIO=true)

build.light.eme:
	$(call build,.eme,USE_EME_DRM=true)

build.light.subs-audio:
	$(call build,.subs-audio,USE_SUBTITLES=true USE_ALT_AUDIO=true)

build.light.subs-eme:
	$(call build,.subs-eme,USE_SUBTITLES=true USE_EME_DRM=true)

build.light.audio-eme:
	$(call build,.audio-eme,USE_ALT_AUDIO=true USE_EME_DRM=true)

define build
	mkdir -p ./dist

	cd ./src && $(2) npm run build -- --env.light
	cd ./src && $(2) npm run build -- --env.light-dist

	cp -f ./src/dist/hls.light.js ./dist/hls.light$(1).js
	cp -f ./src/dist/hls.light.js.map ./dist/hls.light$(1).js.map
	cp -f ./src/dist/hls.light.min.js ./dist/hls.light$(1).min.js
	cp -f ./src/dist/hls.light.min.js.map ./dist/hls.light$(1).min.js.map

	sed -i 's/hls.light.js.map/hls.light$(1).js.map/g' ./dist/hls.light$(1).js
	sed -i 's/hls.light.min.js.map/hls.light$(1).min.js.map/g' ./dist/hls.light$(1).min.js

	rm -rf ./src/dist
endef