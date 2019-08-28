javascript:(function(){

	function get(s)
	{
		let nodes;
		try
		{
			nodes = document.querySelectorAll(s);
		}
		catch(error)
		{
			showMessageBig("Invalid selector: " + s);
			return null;
		}
		if(s.indexOf("#") === 0 && !~s.indexOf(" ") && !~s.indexOf("."))
			return document.querySelector(s);
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

	function showMessage(s)
	{
		let e;
		const strStyle = 'message { display: block; background: #111; font: 32px Helvetica, Arial, sans-serif; color: #FFF; padding: 0 1em; height: 60px; line-height: 60px; position: fixed; bottom: 0; left: 0; width: 100%; z-index: 2000000000; text-align: left; }';

		if(!getOne("message"))
		{
			e = document.createElement("message");
			document.body.insertBefore(e, document.body.firstChild);
			if(!getOne("#styleMessage"))
			{
				insertStyle(strStyle, "styleMessage", true);
			}
		}
		else
		{
			e = getOne("message");
		}
		e.textContent = s;
	}

	function annotateElement(elem, message)
	{
		const annotation = document.createElement("annotation");
		annotation.textContent = message;
		elem.insertBefore(annotation, elem.firstChild);
	}

	function normalizeText(s)
	{
		return s.replace(/[^a-zA-Z]/g, "");
	}

	function showInaccessibleLinks()
	{
		del("annotation");
		insertStyle("annotation { font: 24px helvetica, arial, sans-serif; background: #A00; padding: 2px 5px; color: #FFF; border-radius: 0; } }", "styleAnnotateElement", true);
		const links = get("a");
		let i = links.length;
		let countBadLinks = 0;
		while(i--)
		{
			const link = links[i];
			let needsAriaLabel = false;
			if(link.textContent)
			{
				switch(normalizeText(link.textContent.toLowerCase()))
				{
					case "readmore": needsAriaLabel = true; break;
					case "clickhere": needsAriaLabel = true; break;
					case "learnmore": needsAriaLabel = true; break;
					default: break;
				}
			}
			if(!needsAriaLabel) continue;
			if(link.hasAttribute("aria-label"))
			{
				const ariaLabel = link.getAttribute("aria-label");
				if(ariaLabel && ariaLabel.length && link.textContent && ariaLabel !== link.textContent)
					continue;
			}
			if(!link.hasAttribute("title") || !link.getAttribute("title").length || link.getAttribute("title") === link.textContent)
			{
				countBadLinks++;
				annotateElement(link, "Needs descriptive title");
				continue;
			}
		}
		showMessage(countBadLinks + " inaccessible links found");
	}

	showInaccessibleLinks();

})();
