// ==UserScript==
// @name         Form Filler
// @namespace    https://www.nimishjha.com
// @version      0.1
// @description  Fill out forms automatically
// @author       nimish.jha@gmail.com
// @include        *
// @match        *
// @grant        none
// ==/UserScript==

(function() {
    'use strict';

	const KEYCODES = {
		ZERO: 48,
		ONE: 49,
		TWO: 50,
		THREE: 51,
		FOUR: 52,
		FIVE: 53,
		SIX: 54,
		SEVEN: 55,
		EIGHT: 56,
		NINE: 57,
		A: 65,
		B: 66,
		C: 67,
		D: 68,
		E: 69,
		F: 70,
		G: 71,
		H: 72,
		I: 73,
		J: 74,
		K: 75,
		L: 76,
		M: 77,
		N: 78,
		O: 79,
		P: 80,
		Q: 81,
		R: 82,
		S: 83,
		T: 84,
		U: 85,
		V: 86,
		W: 87,
		X: 88,
		Y: 89,
		Z: 90,
		F1: 112,
		F2: 113,
		F3: 114,
		F4: 115,
		F5: 116,
		F6: 117,
		F7: 118,
		F8: 119,
		F9: 120,
		F10: 121,
		F11: 122,
		F12: 123,
		NUMPAD0: 96,
		NUMPAD1: 97,
		NUMPAD2: 98,
		NUMPAD3: 99,
		NUMPAD4: 100,
		NUMPAD5: 101,
		NUMPAD6: 102,
		NUMPAD7: 103,
		NUMPAD8: 104,
		NUMPAD9: 105,
		NUMPAD_MULTIPLY: 106,
		NUMPAD_ADD: 107,
		NUMPAD_SUBTRACT: 109,
		NUMPAD_DECIMAL_POINT: 110,
		NUMPAD_DIVIDE: 111,
		FORWARD_SLASH: 191,
		TILDE: 192,
		SPACE: 32,
		UPARROW: 38,
		DOWNARROW: 40,
		LEFTARROW: 37,
		RIGHTARROW: 39,
		TAB: 9,
		ENTER: 13,
		ESCAPE: 27,
		SQUARE_BRACKET_OPEN: 219,
		SQUARE_BRACKET_CLOSE: 221
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
		//
		//	Inputs
		//
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

		//
		//	Textareas
		//
		e = get("textarea");
		i = e.length;
		while(i--)
		{
			e[i].value = "Line 1\r\nLine 2";
		}

		//
		//	Selects
		//
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

		//
		//	Focus submit button
		//
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

	function handleKeyDown(e)
	{
		let shouldPreventDefault = true;
		let ctrlOrMeta = "ctrlKey";
		if(navigator.userAgent.indexOf("Macintosh") !== -1)
			ctrlOrMeta = "metaKey";
		if(!(e.altKey || e.shiftKey || e[ctrlOrMeta]))
		{
			return;
		}
		if(e.altKey && e[ctrlOrMeta] && e.shiftKey)
		{
			e.preventDefault();
			const k = e.keyCode;
			switch(k)
			{
				case KEYCODES.F: fillForms(); break;
			}
		}
	}

	function main()
	{
		document.addEventListener("keydown", handleKeyDown, false);
		console.log("Form filler userscript active");
	}

	main();

})();
