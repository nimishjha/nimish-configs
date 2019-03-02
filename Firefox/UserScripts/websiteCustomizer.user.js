// ==UserScript==
// @id             website customizer
// @name           website customizer
// @version        1.0
// @namespace      nimishjha.com
// @author         Nimish Jha
// @description    Website-specific enhancements
// @include        *
// @include        file:///*
// @run-at         document-end
// @grant		none
// ==/UserScript==

function get(s)
{
	if(s.indexOf("#") === 0 && !~s.indexOf(" ") && !~s.indexOf("."))
		return document.querySelector(s);
	var nodes = document.querySelectorAll(s);
	if(nodes.length)
		return Array.from(nodes);
	return false;
}

function containsAnyOfTheStrings(s, arrStrings)
{
	if(!s || typeof(s) !== "string") return false;
	var i = arrStrings.length;
	var found = false;
	while(i--)
	{
		if(~s.indexOf(arrStrings[i]))
		{
			found = true;
			break;
		}
	}
	return found;
}

function insertStyle(str, identifier, important)
{
	if(identifier && get("#" + identifier))
		del("#" + identifier);
	if(important)
		str = str.replace(/;/g, " !important;");
	var head = get("head")[0], style = document.createElement("style"), rules = document.createTextNode(str);
	style.type = "text/css";
	if(style.styleSheet)
		style.styleSheet.cssText = rules.nodeValue;
	else
		style.appendChild(rules);
	if(identifier && identifier.length)
		style.id = identifier;
	head.appendChild(style);
}

function trim(str1)
{
	return str1.replace(/^\s+/, '').replace(/\s+$/, '');
}

function isArray(o)
{
	return Object.prototype.toString.call(o) === '[object Array]';
}

function del(arg)
{
	if(!arg)
		return;
	if(arg.nodeType)
		arg.parentNode.removeChild(arg);
	else if(arg.length)
		if(typeof arg === "string")
			del(get(arg));
		else
			for(var i = 0, ii = arg.length; i < ii; i++)
				del(arg[i]);
}

function log(str)
{
	var d = document.createElement("h6");
	d.innerHTML = str;
	document.body.appendChild(d);
}

function createElement(tag, props)
{
	var elem = document.createElement(tag);
	if(props && typeof props === "object")
	{
		var key, keys = Object.keys(props);
		var i = keys.length;
		var settableProperties = ["id", "className", "textContent", "innerHTML", "value"];
		while(i--)
		{
			key = keys[i];
			if(settableProperties.includes(key))
				elem[key] = props[key];
			else
				elem.setAttribute(key, props[key]);
		}
		return elem;
	}
	return elem;
}

//

function doGfycat()
{
	var e, s;
	e = get("#mp4Source");
	if(!e)
	{
		log("no mp4Source");
		return;
	}
	s = e.src;
	e.src = '';
	e = get("#webmSource");
	log(e.src);
	e.src = '';
	del('video');
	//location.href = s;
	e = document.createElement("a");
	e.href = e.textContent = s;
	log(s);
	document.body.appendChild(e);
	e.focus;
}

function deleteElementsContainingText(selector, str)
{
	var sel, text;
	if (! (selector && str))
	{
		sel = prompt("Delete elements containing text");
		text = prompt("Containing text");
		if (sel.length)
		{
			if(text.length)
			{
				if (sel === "img") deleteImagesBySrcContaining(text);
				else deleteElementsContainingText(sel, text);
			}
			else
			{
				del(sel);
			}
		}
		return;
	}
	var e = get(selector);
	if (!e) return;
	if (e.length)
	{
		var i = e.length;
		while (i--)
		{
			if (e[i].querySelector(selector)) continue;
			if (e[i].textContent.indexOf(str) >= 0)
				e[i].parentNode.removeChild(e[i]);
		}
	}
	else if (e.parentNode)
	{
		e.parentNode.removeChild(e);
	}
}

function deleteImagesBySrcContaining(str)
{
	var elems = document.getElementsByTagName("img");
	var i = elems.length;
	while (i--)
	{
		if(elems[i].src.indexOf(str) >= 0)
		{
			log("Deleting image with src " + elems[i].src);
			elems[i].parentNode.removeChild(elems[i]);
		}
	}
}

function removeAttributeOf(selector, attribute)
{
	var e = document.querySelectorAll(selector);
	var i = e.length;
	while(i--)
		e[i].removeAttribute(attribute);
}

function replaceElementsBySelector(selector, tagName)
{
	if(!(selector && tagName))
	{
		selector = prompt("Element to replace (querySelectorAll)");
		tagName = prompt("Tag to replace with");
	}
	var replacement, e, toreplace, i, ii;
	e = document.querySelectorAll(selector);
	if(e.length)
	{
		toreplace = [];
		for (i = 0, ii = e.length; i < ii; i++)
		{
			toreplace.push(e[i]);
		}
		for (i = toreplace.length - 1; i >= 0; i--)
		{
			replacement = createElement(tagName, { innerHTML: toreplace[i].innerHTML });
			toreplace[i].parentNode.replaceChild(replacement, toreplace[i]);
		}
	}
	else if(e && e.parentNode)
	{
		replacement = createElement(tagName, { innerHTML: e.innerHTML });
		e.parentNode.replaceChild(replacement, e);
	}
}

function highlightWithinPreformattedBlocks(str)
{
	var reg = new RegExp('([^\n]*' + str + '[^\n]+)', 'gi');
	var pres = get("pre");
	var i = pres.length;
	while(i--)
	{
		pres[i].innerHTML = pres[i].innerHTML.replace(reg, "<mark>$1</mark>");
	}
}

function deleteElementsWithExactText(selector, str)
{
	var e = document.querySelectorAll(selector);
	console.log(e.length + " elements found");
	var i = e.length;
	var elem;
	var count = 0;
	while(i--)
	{
		elem = e[i];
		if(elem.textContent && elem.textContent === str)
		{
			count++;
			elem.parentNode.removeChild(elem);
		}
	}
	console.log("Deleted " + count);
}

function githubAddButton(config)
{
	var e = document.createElement("button");
	e.textContent = config.buttonText;
	e.className = "btn btn-primary";
	e.addEventListener("click", config.clickHandler, false);
	var wrapper = get("#njGithubButtonWrapper");
	wrapper.appendChild(e);
}

function githubClick(button)
{
	button.click();
}

function githubToggleAllFiles()
{
	var e = document.querySelectorAll(".file-actions .js-details-target");
	var i = e.length;
	while(i--)
		githubClick(e[i]);
}

function githubCollapseAllFiles()
{
	var e = document.querySelectorAll(".file-actions .js-details-target");
	var i = e.length;
	while(i--)
		if(e[i].getAttribute("aria-expanded") === "true")
			githubClick(e[i]);
}

function githubToggleTestFiles()
{
	var e = document.querySelectorAll(".file-actions .js-details-target");
	var parent, fileInfo;
	var i = e.length;
	while(i--)
	{
		parent = e[i].closest(".file-header");
		if(parent)
		{
			fileInfo = parent.querySelector(".file-info a");
			if(isTestFile(fileInfo.textContent))
			githubClick(e[i]);
		}
	}
}

function githubToggleTemplateFiles()
{
	var e = document.querySelectorAll(".file-actions .js-details-target");
	var parent, fileInfo;
	var i = e.length;
	while(i--)
	{
		parent = e[i].closest(".file-header");
		if(parent)
		{
			fileInfo = parent.querySelector(".file-info a");
			if(fileInfo && isTemplateFile(fileInfo.textContent))
			githubClick(e[i]);
		}
	}
}

function isTemplateFile(s)
{
	return containsAnyOfTheStrings(s, ["styl", "css", "pug"]);
}

function isLogicFile(s)
{
	return containsAnyOfTheStrings(s, [".coffee", ".js", ".jsx"]);
}

function isTestFile(s)
{
	return containsAnyOfTheStrings(s, ["/test/", "/__test__/", "/unit/", ".snap", ".spec"]);
}

function githubToggleLogicFiles()
{
	var e = document.querySelectorAll(".file-actions .js-details-target");
	var parent, fileInfo;
	var i = e.length;
	while(i--)
	{
		parent = e[i].closest(".file-header");
		if(parent)
		{
			fileInfo = parent.querySelector(".file-info a");
			if(fileInfo && isLogicFile(fileInfo.textContent) && !isTestFile(fileInfo.textContent))
			githubClick(e[i]);
		}
	}
}

function doMDN()
{
	setTimeout(function(){ deleteElementsWithExactText("a", "Section"); }, 1000);
}

function doWikipedia()
{
	replaceElementsBySelector("h1", "h6");
	replaceElementsBySelector("h2", "h6");
	replaceElementsBySelector("h3", "h6");
	replaceElementsBySelector("h4", "h6");
	replaceElementsBySelector("h5", "h6");
}

function doGithub()
{
	var style = '.sticky-content, .js-sticky h1, .js-sticky h2 { display: none; }' +
		'#njGithubButtonWrapper { display: none; padding: 10px; background: #000; }' +
		'#njGithubButtonWrapper button { margin: 0 10px 0 0; }' +
		'body.full-width #njGithubButtonWrapper { display: block; }';
	insertStyle(style, "style_github", true);
	var wrapper = document.createElement("div");
	wrapper.id = "njGithubButtonWrapper";
	document.body.insertBefore(wrapper, document.body.firstChild);
	githubAddButton({ buttonText: "Collapse all files", clickHandler: githubCollapseAllFiles });
	githubAddButton({ buttonText: "Toggle all files", clickHandler: githubToggleAllFiles });
	githubAddButton({ buttonText: "Toggle logic files", clickHandler: githubToggleLogicFiles });
	githubAddButton({ buttonText: "Toggle test files", clickHandler: githubToggleTestFiles });
	githubAddButton({ buttonText: "Toggle template files", clickHandler: githubToggleTemplateFiles });
	var s = document.title;
	s = s.replace(/\[.+\]/, '');
	document.title = s;
	replaceElementsBySelector(".commit-title", "h1");
}

function doSlack()
{
	var s = 'html span[class] { color: #AAA !important; font: 12px verdana !important; }' +
	'.light_theme ts-message .message_content .member { color: #09F !important; font: 12px verdana !important;}' +
	'html span[class] b {color: #FFF !important; }' +
	'.message_content { background: #222 !important; }';
	insertStyle(s, "styleSlack", true);
}

//

if(~location.href.indexOf("ci.adslot.com/job"))
{
	highlightWithinPreformattedBlocks("passed");
	highlightWithinPreformattedBlocks("passing");
	highlightWithinPreformattedBlocks("fail");
	highlightWithinPreformattedBlocks("should add");
	highlightWithinPreformattedBlocks("Executed");
	highlightWithinPreformattedBlocks("Error:");
	highlightWithinPreformattedBlocks("Failed:");
	highlightWithinPreformattedBlocks("Re-running");
}

if(~location.href.indexOf("slack.com"))
{
	doSlack();
}

switch(location.hostname)
{
	case 'github.com': doGithub(); break;
	case 'developer.mozilla.org': doMDN(); break;
	case 'en.wikipedia.org': setTimeout(doWikipedia, 500); break;
}
