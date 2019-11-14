javascript: (function () {
	const Nimbus = {};
	const KEYCODES = {
		TAB: 9,
		ENTER: 13,
		ESCAPE: 27,
	};

	function get(s) {
		let nodes;
		try {
			nodes = document.querySelectorAll(s);
		} catch (error) {
			console.error("Invalid selector: " + s);
			return null;
		}
		if(s.indexOf("#") === 0 && !~s.indexOf(" ") && !~s.indexOf(".")) return document.querySelector(s);
		if(nodes.length) return Array.from(nodes);
		return false;
	}

	function getOne(s) {
		return document.querySelector(s);
	}

	function del(arg) {
		if(!arg) return;
		let i, ii;
		if(arg.nodeType) arg.parentNode.removeChild(arg);
		else if(arg.length)
			if(typeof arg === "string") del(get(arg));
			else
				for(i = 0, ii = arg.length; i < ii; i++) del(arg[i]);
	}

	function insertStyle(str, identifier, important) {
		if(identifier && identifier.length && get("#" + identifier)) del("#" + identifier);
		if(important) str = str.replace(/;/g, " !important;");
		const head = getOne("head");
		const style = document.createElement("style");
		const rules = document.createTextNode(str);
		style.type = "text/css";
		if(style.styleSheet) style.styleSheet.cssText = rules.nodeValue;
		else style.appendChild(rules);
		if(identifier && identifier.length) style.id = identifier;
		head.appendChild(style);
	}

	function createElement(tag, props) {
		const elem = document.createElement(tag);
		if(props && typeof props === "object") {
			const keys = Object.keys(props);
			let i = keys.length;
			const settableProperties = ["id", "className", "textContent", "innerHTML", "value"];
			while(i--) {
				const key = keys[i];
				if(settableProperties.includes(key)) elem[key] = props[key];
				else elem.setAttribute(key, props[key]);
			}
			return elem;
		}
		return elem;
	}

	function handleConsoleInput(evt, consoleType) {
		const userInputElement = getOne("#userInput");
		if(!userInputElement) return;
		const inputText = userInputElement.value;
		if(!inputText || !inputText.length) return;
		if(consoleType === "js") Nimbus.jsConsoleText = inputText;
		else if(consoleType === "css") Nimbus.cssConsoleText = inputText;
		const ctrlOrMeta = ~navigator.userAgent.indexOf("Macintosh") ? "metaKey" : "ctrlKey";
		switch (evt.keyCode) {
		case KEYCODES.ENTER:
			if(evt[ctrlOrMeta]) {
				if(consoleType === "js") eval(inputText);
				else if(consoleType === "css") insertStyle(inputText, "userStyle", true);
			}
			break;
		case KEYCODES.TAB:
			insertTab(evt);
			return false;
			break;
		case KEYCODES.ESCAPE:
			toggleConsole();
			break;
		}
	}

	function insertTab(evt) {
		const targ = evt.target;
		evt.preventDefault();
		evt.stopPropagation();
		const iStart = targ.selectionStart;
		const iEnd = targ.selectionEnd;
		targ.value = targ.value.substr(0, iStart) + '\t' + targ.value.substr(iEnd, targ.value.length);
		targ.setSelectionRange(iStart + 1, iEnd + 1);
	}

	function getConsoleHistory(consoleType) {
		switch (consoleType) {
		case "css":
			if(Nimbus.cssConsoleText) return Nimbus.cssConsoleText;
			break;
		case "js":
			if(Nimbus.jsConsoleText) return Nimbus.jsConsoleText;
			break;
		}
		return "";
	}

	function toggleConsole(consoleType) {
		if(get("#userInputWrapper")) {
			del("#userInputWrapper");
			del("#styleUserInputWrapper");
			return;
		}
		if(!consoleType || !["css", "js"].includes(consoleType)) {
			console.error("toggleConsole needs a consoleType");
			return;
		}
		let dialogStyle;
		const consoleBackgroundColor = consoleType === "css" ? "#036" : "#000";
		dialogStyle = '#userInputWrapper { position: fixed; bottom: 0; left: 0; right: 0; height: 30vh; z-index: 1000000000; }' + '#userInput { background: ' + consoleBackgroundColor + '; color: #FFF; font: bold 18px Consolas, monospace; width: 100%; height: 100%; padding: 10px; border: 0; outline: 0; }';
		insertStyle(dialogStyle, "styleUserInputWrapper", true);
		const inputTextareaWrapper = createElement("div", {
			id: "userInputWrapper"
		});
		const inputTextarea = createElement("textarea", {
			id: "userInput",
			value: getConsoleHistory(consoleType)
		});
		const handleKeyDown = function (event) {
			handleConsoleInput(event, consoleType);
		};
		inputTextarea.addEventListener("keydown", handleKeyDown);
		inputTextareaWrapper.appendChild(inputTextarea);
		document.body.appendChild(inputTextareaWrapper);
		inputTextarea.focus();
	}

	function handleKeyDown(e) {
		let shouldPreventDefault = true;
		let ctrlOrMeta = "ctrlKey";
		if(navigator.userAgent.indexOf("Macintosh") !== -1) ctrlOrMeta = "metaKey";
		if(!(e.altKey || e.shiftKey || e[ctrlOrMeta])) {
			return;
		}
		const k = e.keyCode;
		if(e.altKey && !e.shiftKey && !e[ctrlOrMeta]) {
			switch (k) {
			case KEYCODES.I:
				toggleConsole("css");
				break;
			case KEYCODES.K:
				toggleConsole("js");
				break;
			}
		}
	}
	document.addEventListener("keydown", handleKeyDown, false);
})();
