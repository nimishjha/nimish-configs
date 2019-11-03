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
		}
		if(~location.href.indexOf("dotcom-"))
		{
			doBupaDevEnvironments();
		}
	}

	main();

})();
