const f = function(x)
{
	console.log("Clicking", x.getAttribute("for"));
	x.className = "hl";
	x.click();
};

const e = document.querySelectorAll("label");
let i = -1;
let len = e.length;
while(++i < len)
{
	const x = e[i];
	setTimeout(function(){ f.call(null, x); }, 1000 + Math.random() * 20000);
}
