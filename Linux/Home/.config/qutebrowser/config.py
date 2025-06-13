config.load_autoconfig()
# config.set("colors.webpage.darkmode.enabled", True)
config.source('themes/gray.py')
c.fonts.default_family="Swis721 Cn BT"
c.fonts.default_size="16pt"
c.fonts.contextmenu = "Swis721 Cn BT"
c.fonts.web.size.minimum = 12
c.content.user_stylesheets = ["userstyles/simpleNegative.css"]
c.content.blocking.enabled = True
c.content.blocking.method = "hosts"
c.content.blocking.hosts.lists = ["/etc/hosts"]
c.url.default_page = "about:blank"
c.url.start_pages = "about:blank"
c.tabs.max_width = 300
c.tabs.favicons.show = "never"
c.auto_save.session = False
c.zoom.levels = ["75%", "80%", "85%", "90%", "95%", "100%", "110%", "120%", "130%", "140%", "150%"]
config.set("bindings.default", {})

config.set("bindings.commands", {
	"normal": {
		"<Escape>": "clear-keychain ;; search ;; fullscreen --leave",
		"go": "cmd-set-text :open -t -r ",
		"gO": "cmd-set-text :open ",
		"<Ctrl-O>": "cmd-set-text :open ",
		"<Ctrl-Shift-O>": "cmd-set-text :open -t ",
		":": "cmd-set-text :",
		"<Ctrl-R>": 'config-cycle content.user_stylesheets "userstyles/userContent.css" ""',
		"mp": "mode-enter passthrough",
		"<Ctrl-P>": "mode-enter passthrough",
		"rc": "config-source",
		"<F12>": "devtools",
		"<Ctrl-W>": "tab-close",
		"<Ctrl-T>": "open -t",
		"<Ctrl-Q>": "quit",
		"<Ctrl-F>": "cmd-set-text /",
		"<Ctrl-F5>": "reload -f",
		"u": "undo",
		"bb": "back",
		"dt": "devtools",
		"rc": "config-source",
		"rp": "reload",
		"h": "hint",
		"H": "hint all tab",
		"i": "hint images",
		"/": "cmd-set-text /",
		"n": "search-next",
		"N": "search-prev",
		"<Ctrl-PgDown>": "tab-next",
		"<Ctrl-PgUp>": "tab-prev",
		"<Ctrl-->": "zoom-out",
		"<Ctrl-=>": "zoom-in",
		"<Ctrl-0>": "zoom",
	},
	"insert": {
		"<Escape>": "mode-leave"
	},
	"command": {
		"<Return>": "command-accept",
		"<Escape>": "mode-leave",
		"<Up>": "completion-item-focus --history prev",
		"<Down>": "completion-item-focus --history next"
	},
	"passthrough": {
		"<Shift-Escape>": "mode-leave",
	},
	"hint": {
		"<Ctrl-F>": "hint links",
		"<Escape>": "mode-leave"
	},
	"prompt": {
		"<Return>": "prompt-accept",
		"<Up>": "prompt-item-focus prev",
		"<Down>": "prompt-item-focus next",
		"<Escape>": "mode-leave"
	},
	"yesno": {
		"<Return>": "prompt-accept",
		"y": "prompt-accept yes",
		"n": "prompt-accept no",
		"Y": "prompt-accept --save yes",
		"N": "prompt-accept --save no",
		"<Escape>": "mode-leave"
	}
})
