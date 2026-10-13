#include "fs.h"

#ifdef __EMSCRIPTEN__
#include <emscripten.h>

EM_ASYNC_JS(void, js_fs_init, (), {
	try {
		FS.mkdirTree("/home/web_user");
	} catch (_) {
	}

	try {
		FS.mount(IDBFS, {}, "/home/web_user");

		await new Promise((resolve) => {
			FS.syncfs(true, err => {
				if (err) { console.warn("failed to load filesystem", err); }
				resolve();
			});
		});
	} catch (e) {
		console.warn("failed to init filesystem", e);
	}
});

EM_ASYNC_JS(void, js_fs_sync, (), {
	await new Promise((resolve) => {
		FS.syncfs(false, err => {
			if (err) { console.warn("failed to save filesystem", err); }
			resolve();
		});
	});
});

void fs_init(void) {
	js_fs_init();
}

void fs_sync(void) {
	js_fs_sync();
}

#else
void fs_init(void) {}
void fs_sync(void) {}
#endif
