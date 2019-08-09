forAll("img", addAlt);
forAll("form", addRole);
forAll("select, input", addLabel);
forAll("button", addText);
forAll(".c-footer-social__link", addText);
fixAriaAttributes();

function addAlt(image)
{
	if(!image.hasAttribute("alt"))
		image.setAttribute("alt", "Placeholder alt text");
}

function addRole(form)
{
	if(!form.hasAttribute("role"))
		form.setAttribute("role", "search");
}

function addLabel(formElement)
{
	formElement.setAttribute("aria-label", "Placeholder label");
}

function addText(button)
{
	button.setAttribute("aria-label", "Placeholder button text");
}

function removeTabRoles(elem)
{
	elem.removeAttribute("role");
}

function fixAriaSelectedExpanded(elem)
{
	if(elem.hasAttribute("aria-selected") && !["true", "false"].includes(elem.getAttribute("aria-selected")) )
		elem.setAttribute("aria-selected", "false");
	if(elem.hasAttribute("aria-expanded") && !["true", "false"].includes(elem.getAttribute("aria-expanded")) )
		elem.setAttribute("aria-expanded", "false");
}

function fixAriaLabelledBy(elem)
{
	if(elem.hasAttribute("aria-labelledby"))
	{
		elem.classList.add("hl");
		const labelledById = "#" + elem.getAttribute("aria-labelledby");
		const labelElement = get(labelledById);
		console.log(labelledById, labelElement);
		if(!labelElement || labelElement === -1)
		{
			elem.removeAttribute("aria-labelledby");
			elem.setAttribute("aria-label", "labelledById");
		}
	}
}

function fixAriaDescribedBy(elem)
{
	if(elem.hasAttribute("aria-describedby"))
	{
		elem.classList.add("hl");
		const labelledById = "#" + elem.getAttribute("aria-describedby");
		const labelElement = get(labelledById);
		if(!labelElement || labelElement === -1)
		{
			elem.removeAttribute("aria-describedby");
			elem.setAttribute("aria-label", "labelledById");
		}
	}
}

function fixAriaAttributes()
{
	const elems = get("*");
	let i = elems.length;
	while(i--)
	{
		const elem = elems[i];
		removeTabRoles(elem);
		fixAriaSelectedExpanded(elem);
		fixAriaLabelledBy(elem);
		fixAriaDescribedBy(elem);
	}
}
