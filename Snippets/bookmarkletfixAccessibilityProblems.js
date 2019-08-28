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

	function addTextToButtons()
	{
		const buttons = get("button");
		let i = buttons.length;
		while(i--)
		{
			buttons[i].setAttribute("aria-label", "Placeholder button text");
		}
	}

	function fixAriaSelectedExpanded()
	{
		const elems = Array.from(document.getElementsByTagName("*"));
		let i = elems.length;
		while(i--)
		{
			const elem = elems[i];
			if(elem.hasAttribute("aria-selected") && !["true", "false"].includes(elem.getAttribute("aria-selected")) )
				elem.setAttribute("aria-selected", "false");
			if(elem.hasAttribute("aria-expanded") && !["true", "false"].includes(elem.getAttribute("aria-expanded")) )
				elem.setAttribute("aria-expanded", "false");
		}
	}

	addTextToButtons();
	fixAriaSelectedExpanded();
})();

