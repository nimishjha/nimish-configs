// ==UserScript==
// @name         WebsiteCustomizer--Work
// @namespace    https://www.nimishjha.com
// @version      0.1
// @description  Whatever
// @author       You
// @match        *
// @include        *
// @grant        none
// ==/UserScript==

(function() {
	'use strict';

	function deleteElementsContainingText(selector, str)
	{
		if(!(typeof selector === "string" && selector.length))
			return;
		if(!(typeof str === "string" && str.length))
		{
			del(selector);
			return;
		}

		switch(selector)
		{
			case "img": deleteImagesBySrcContaining(str); return;
			case "a": deleteLinksContainingText(str); return;
		}

		const e = get(selector);
		if(e.length)
		{
			let i = e.length;
			while(i--)
			{
				const elem = e[i];
				if(elem.querySelector(selector))
					continue;
				if(~elem.textContent.indexOf(str))
					elem.remove();
			}
		}
		else if(e.parentNode)
		{
			if(~e.textContent.indexOf(str))
				e.remove();
		}
	}

	function deleteElementsWithClassContaining(str)
	{
		const e = get("*");
		let i = e.length;
		while(i--)
		{
			const node = e[i];
			if(~node.className.toString().indexOf(str))
				del(node);
		}
	}

	function deleteLinksContainingText(str)
	{
		const links = get("a");
		let i = links.length;
		while(i--)
		{
			const link = links[i];
			if(~link.textContent.indexOf(str) || ~link.href.indexOf(str))
				del(link);
		}
	}

	function deleteImagesBySrcContaining(str)
	{
		const elems = document.getElementsByTagName("img");
		let i = elems.length;
		while(i--)
		{
			const elem = elems[i];
			if(~elem.src.indexOf(str))
			{
				xlog("Deleting image with src " + elem.src);
				elem.remove();
			}
		}
	}


	const Nimbus = {
		logString: "",
		messageTimeout: null,
	};

	function get(s)
	{
		try
		{
			const isValid = document.querySelector(s);
		}
		catch(error)
		{
			console.log("Invalid selector: " + s);
			return -1;
		}
		if(s.indexOf("#") === 0 && !~s.indexOf(" ") && !~s.indexOf("."))
			return document.querySelector(s);
		const nodes = document.querySelectorAll(s);
		if(nodes.length)
			return Array.from(nodes);
		return false;
	}

	function getOne(s)
	{
		return document.querySelector(s);
	}

	function del(arg)
	{
		if(!arg)
			return;
		let i, ii;
		if(arg.nodeType)
			arg.parentNode.removeChild(arg);
		else if(arg.length)
			if(typeof arg === "string")
				del(get(arg));
			else
				for(i = 0, ii = arg.length; i < ii; i++)
					del(arg[i]);
	}

	function insertStyle(str, identifier, important)
	{
		if(identifier && identifier.length && get("#" + identifier))
			del("#" + identifier);
		if(important)
			str = str.replace(/;/g, " !important;");
		const head = getOne("head");
		const style = document.createElement("style");
		const rules = document.createTextNode(str);
		style.type = "text/css";
		if(style.styleSheet)
			style.styleSheet.cssText = rules.nodeValue;
		else
			style.appendChild(rules);
		if(identifier && identifier.length)
			style.id = identifier;
		head.appendChild(style);
	}

	function showMessage(messageText, msgClass, persist)
	{
		clearTimeout(Nimbus.messageTimeout);
		let messageContainer;
		msgClass = msgClass || "";
		const strStyle = 'message { display: block; background: #111; font: 12px Verdcode, Verdana; color: #555; padding: 0 1em; height: 30px; line-height: 30px; position: fixed; bottom: 0; left: 0; width: 100%; z-index: 2000000000; text-align: left; }' +
		'message.messagebig { font: 32px "Swis721 cn bt"; color: #FFF; height: 60px; line-height: 60px; font-weight: 500; }' +
		'message.messageerror { color: #F00; background: #500; }';

		if(!get("message"))
		{
			messageContainer = createElement("message", { className: msgClass });
			document.body.insertBefore(messageContainer, document.body.firstChild);
			if(!getOne("#styleMessage"))
				insertStyle(strStyle, "styleMessage", true);
		}
		else
		{
			messageContainer = getOne("message");
			messageContainer.className = msgClass;
		}
		messageContainer.textContent = messageText;
		if(!persist)
			Nimbus.messageTimeout = setTimeout(deleteMessage, 2000);
	}

	function showMessageBig(messageText)
	{
		showMessage(messageText, "messagebig");
	}

	function showMessageError(messageText)
	{
		showMessage(messageText, "messagebig messageerror");
	}

	function deleteMessage()
	{
		del("message");
		del(".xalert");
		del("#styleMessage");
	}

	function createElement(tag, props)
	{
		const elem = document.createElement(tag);
		if(props && typeof props === "object")
		{
			const keys = Object.keys(props);
			let i = keys.length;
			const settableProperties = ["id", "className", "textContent", "innerHTML", "value"];
			while(i--)
			{
				const key = keys[i];
				if(settableProperties.includes(key))
					elem[key] = props[key];
				else
					elem.setAttribute(key, props[key]);
			}
			return elem;
		}
		return elem;
	}

	function replaceElementsBySelector(selector, tagName)
	{
		const toReplace = get(selector);
		if(toReplace.length)
		{
			showMessageBig("Replacing " + toReplace.length + " " + selector);
			let i = toReplace.length;
			if(tagName === "hr")
			{
				while(i--)
				{
					const elem = toReplace[i];
					elem.parentNode.replaceChild(createElement(tagName), elem);
				}
			}
			else
			{
				while(i--)
				{
					const elem = toReplace[i];
					const elemId = elem.id;
					if(elemId)
						elem.parentNode.replaceChild(createElement(tagName, { id: elemId, innerHTML: elem.innerHTML }), elem);
					else
						elem.parentNode.replaceChild(createElement(tagName, { innerHTML: elem.innerHTML }), elem);
				}
			}
		}
		else if(toReplace && toReplace.parentNode)
		{
			showMessageBig("Replacing one " + selector);
			toReplace.parentNode.replaceChild(createElement(tagName, { innerHTML: toReplace.innerHTML }), toReplace);
		}
	}

	//
	//
	//

	function doSlack()
	{
		const s = 'body, body[class] {background-color: #000; font-family: Helvetica; font-size: 16px; }' +
		'*, *[class] { background-color: transparent; color: #CCC; border-color: transparent; }' +
		'h1, h2, h3, h4, h5, h6, b, strong, em, i {color: #FFF; }' +
		'mark {color: #FF0; }' +
		'a, a[class] *, * a[class] {color: #09F; }' +
		'a:hover, a:hover *, a[class]:hover *, * a[class]:hover {color: #FFF; }' +
		'a:visited, a:visited *, a[class]:visited *, * a[class]:visited {color: #048; }' +
		'a.c-message__sender_link { color: #FFF; }' +
		'.p-channel_sidebar__channel span { color: #CCC; }' +
		'a i.c-icon { color: #FFF; }' +
		'.c-mrkdwn__code { color: #0F0; background: #030; font-size: 12px; font-weight: bold; }' +
		'.c-mrkdwn__pre { color: #0F0; background: #030; font-size: 12px; font-weight: bold; }' +
		'.c-pillow_file_container, .c-pillow_file_container * { background: #030; color: #0F0; }' +
		'.p-channel_sidebar__channel--unread { color: #FFF; border-right: 26px solid #FF0; }' +
		'.p-channel_sidebar__channel--mpim { color: #FFF; }' +
		'.popover { background: #000; border: 1px solid #FFF; }' +
		'button.c-avatar { display: none; }';
		insertStyle(s, "styleSlack", true);
	}

	function doVsts()
	{
		const s = '.code-line { font-family: Helvetica; color: #AAA; }' +
			'.content-original { color: #F00; }' +
			'.content-modified { color: #0F0; }' +
			'.deleted-content-fullrow, .deleted-content, .deleted-content span { color: #F66; background: #600; }' +
			'.added-content-fullrow, .added-content, .added-content span { color: #8F8; background: #060; }';
		insertStyle(s, "styleVsts", true);
	}

	function doYoutube()
	{
		const s = 'HTML,' +
		'YTD-APP,' +
		'YTD-MASTHEAD#masthead.masthead-finish,' +
		'DIV#skip-navigation.style-scope.ytd-masthead,' +
		'DIV#container.style-scope.ytd-searchbox,' +
		'BUTTON#search-icon-legacy.style-scope.ytd-searchbox,' +
		'DIV.masthead-skeleton-icon,' +
		'DIV.masthead-skeleton-icon,' +
		'DIV.masthead-skeleton-icon,' +
		'DIV.masthead-skeleton-icon,' +
		'YTD-MINI-GUIDE-RENDERER.style-scope.ytd-app,' +
		'YTD-MINI-GUIDE-ENTRY-RENDERER.style-scope.ytd-mini-guide-renderer,' +
		'YTD-MINI-GUIDE-ENTRY-RENDERER.style-scope.ytd-mini-guide-renderer,' +
		'YTD-MINI-GUIDE-ENTRY-RENDERER.style-scope.ytd-mini-guide-renderer,' +
		'YTD-MINI-GUIDE-ENTRY-RENDERER.style-scope.ytd-mini-guide-renderer,' +
		'YTD-MINI-GUIDE-ENTRY-RENDERER.style-scope.ytd-mini-guide-renderer,' +
		'DIV.badge.badge-style-type-ad.style-scope.ytd-badge-supported-renderer,' +
		'DIV.badge.badge-style-type-ad.style-scope.ytd-badge-supported-renderer,' +
		'YTD-BUTTON-RENDERER#cta-button.style-scope.ytd-video-masthead-ad-advertiser-info-renderer.style-primary.size-default,' +
		'YTD-PLAYLIST-SIDEBAR-RENDERER.style-scope.ytd-browse,' +
		'YTD-SETTINGS-SIDEBAR-RENDERER.style-scope.ytd-browse,' +
		'YTD-BUTTON-RENDERER.style-scope.yt-horizontal-list-renderer.arrow.style-default.size-default,' +
		'YTD-BUTTON-RENDERER.style-scope.yt-horizontal-list-renderer.arrow.style-default.size-default,' +
		'YTD-BUTTON-RENDERER.style-scope.yt-horizontal-list-renderer.arrow.style-default.size-default,' +
		'YTD-BUTTON-RENDERER.style-scope.yt-horizontal-list-renderer.arrow.style-default.size-default,' +
		'YTD-BUTTON-RENDERER.style-scope.ytd-shelf-renderer.style-destructive.size-default,' +
		'YTD-BUTTON-RENDERER.style-scope.yt-horizontal-list-renderer.arrow.style-default.size-default,' +
		'YTD-BUTTON-RENDERER.style-scope.yt-horizontal-list-renderer.arrow.style-default.size-default' +
		'{' +
		'	background: #000; color: #FFF;' +
		'}';
		insertStyle(s, "styleYoutube", true);
	}

	function redirectReddit()
	{
		if(~location.href.indexOf("www.reddit.com"))
			location.href = location.href.replace(/www\./, "old.");
	}

	function cleanupReddit()
	{
		if(~location.href.indexOf("/comments/"))
		{
			replaceElementsBySelector(".thing", "comment");
			deleteElementsContainingText("ul", "permalink");
		}
	}

	function doBupaDevEnvironments()
	{
		if(get(".cover-detail"))
		{
			const elementCoverDetail = angular.element(document.querySelector(".cover-detail"));
			window.scopeCoverDetail = elementCoverDetail.scope();
			console.log({ scopeCoverDetail: window.scopeCoverDetail });
		}
		if(get(".quote-criteria"))
		{
			const elementQuoteCriteria = angular.element(document.querySelector(".quote-criteria"));
			window.scopeQuoteCriteria = elementQuoteCriteria.scope();
			console.log({ scopeQuoteCriteria: window.scopeQuoteCriteria });
		}
	}

	function doBupaMyWork()
	{
		if(location.href === "https://mywork.bupa.com.au/vpn/index.html")
		{
			const inputs = get("input");
			inputs[0].value = "njha";
			let i = inputs.length;
			while(i--)
			{
				const input = inputs[i];
				if(input.type && input.type === "checkbox")
				{
					input.click();
				}
			}
		}
	}

	function main()
	{
		switch (location.hostname)
		{
			case 'app.slack.com': doSlack(); break;
			case 'bupaaunz.visualstudio.com': doVsts(); break;
			case 'youtube.com':
			case 'www.youtube.com':
				doYoutube();
				break;
			case 'www.reddit.com':
				redirectReddit();
				break;
			case 'old.reddit.com':
				cleanupReddit();
				break;
			case 'mywork.bupa.com.au':
				setTimeout(doBupaMyWork, 1000);
				break;
		}
		if(~location.href.indexOf("dotcom-"))
		{
			doBupaDevEnvironments();
		}
	}

	main();

})();
