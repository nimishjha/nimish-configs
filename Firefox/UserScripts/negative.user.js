// ==UserScript==
// @name	Negative
// @namespace	https://www.nimishjha.com
// @version	  0.1
// @description  Apply a minimal dark style to all websites
// @author	   Nimish Jha
// @match		*
// @include        *
// @include        file:///*
// @run-at         document-start
// @grant		none
// ==/UserScript==

(function() {
	'use strict';

	function get(s)
	{
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
		if(arg.nodeType)
			arg.remove();
		else if(arg.length)
			if(typeof arg === "string")
				del(get(arg));
			else
				for(let i = 0, ii = arg.length; i < ii; i++)
					del(arg[i]);
	}

	function insertStyle(str, identifier, important)
	{
		if(identifier && identifier.length && getOne("#" + identifier))
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

	function main()
	{
		const s = `html, body, body[class] {background: #000; }
			*, *[class] { background-color: rgba(0,0,0,0.4); color: #CCC; border-color: transparent; }
			h1, h2, h3, h4, h5, h6, b, strong, em, i {color: #FFF; }
			mark {color: #FF0; }
			a, a[class] *, * a[class] {color: #09F; }
			a:hover, a:hover *, a[class]:hover *, * a[class]:hover {color: #FFF; }
			a:visited, a:visited *, a[class]:visited *, * a[class]:visited {color: #048; }
			button[class], input[class], textarea[class] { border: 2px solid #09F; }
			button[class]:focus, input[class]:focus, textarea[class]:focus, button[class]:hover, input[class]:hover, textarea[class]:hover { border: 2px solid #FFF; }`;
		insertStyle(s, "styleSimpleNegative", true);
	}

	main();
})();
