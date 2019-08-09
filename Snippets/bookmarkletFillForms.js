javascript:(function(){

	const KEYCODES = {
		F: 70,
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

	function fillForms()
	{
		let i, j, jj, e, f, inputType, inputName;
		e = get("input");
		i = e.length;
		while(i--)
		{
			if(e[i].hasAttribute("type"))
			{
				inputType = e[i].type;
				if(inputType !== "button" && inputType !== "submit" && inputType !== "image" && inputType !== "hidden" && inputType !== "checkbox" && inputType !== "radio")
				{
					inputName = e[i].getAttribute("name") || e[i].getAttribute("id");
					inputName = inputName.toLowerCase();
					if(inputName)
					{
						if(inputName === "companyname") e[i].value = "";
						else if(inputName.indexOf("first") >= 0) e[i].value = "John";
						else if(inputName.indexOf("last") >= 0) e[i].value = "Doe";
						else if(inputName.indexOf("name") >= 0) e[i].value = "John Doe";
						else if(inputName.indexOf("email") >= 0) e[i].value = "test@test.com";
						else if(inputName.indexOf("day") >= 0) e[i].value = Math.floor(Math.random() * 28);
						else if(inputName.indexOf("year") >= 0) e[i].value = 1980 + Math.floor(Math.random() * 20);
						else if(inputName.indexOf("phone") >= 0) e[i].value = "(00) 0000 0000";
						else if(inputName.indexOf("mobile") >= 0) e[i].value = "0400222333";
						else if(inputName.indexOf("date") >= 0) e[i].value = "23/08/1991";
						else if(inputName.indexOf("suburb") >= 0) e[i].value = "Melbourne";
						else if(inputName.indexOf("postcode") >= 0) e[i].value = "3000";
						else if(inputName.indexOf("state") >= 0) e[i].value = "VIC";
						else if(inputType === "number") e[i].value = 42;
						else if(inputType === "text") e[i].value = e[i].name.replace(/_/g, ' ');
						else if(inputType === "checkbox") e[i].checked = true;
						else if(inputType === "radio") e[i].checked = true;
						else if(inputType !== 'file') e[i].value = inputName.replace(/_/g, ' ');
					}
				}
			}
		}

		e = get("textarea");
		i = e.length;
		while(i--)
		{
			e[i].value = "Line 1\r\nLine 2";
		}

		e = get("select");
		i = e.length;
		while(i--)
		{
			f = e[i].getElementsByTagName("option");
			for(j = 0, jj = f.length; j < jj; j++)
			{
				f[j].removeAttribute("selected");
			}
			const optionIndex = 1 + Math.floor(Math.random() * (j-1));
			if(f[optionIndex])
				f[optionIndex].setAttribute("selected", "selected");
		}

		e = document.getElementsByTagName("input");
		i = e.length;
		while(i--)
		{
			if(e[i].getAttribute("type") === "submit")
			{
				e[i].focus();
				break;
			}
		}
	}

	fillForms();

})();
