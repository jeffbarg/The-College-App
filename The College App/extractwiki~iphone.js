var a = document.getElementById("mw-content-text");
var b=a.getElementsByTagName("p"); 

var y=document.getElementsByTagName("sup");
if (y != []) {
	while (y.length != 0) {
		n = y[0];
		n.parentNode.removeChild(n);
	}
}
y=document.getElementsByTagName("span");
if (y != []) {
	for (var i = 0; i < y.length; i++) {
		n = y[i];
		n.parentNode.removeChild(n);
	}
}

d = document.createElement('div');
d.style.fontFamily = "\"Paletino\", serif";
d.style.height = "210px";
d.style.margin = "auto";
d.style.padding = "0px";
d.style.lineHeight = "20px";
d.style.overflow = "hidden";

var images = document.getElementsByClassName("image");
var img = images[0];
img.style.float = "right";
img.style.float.maxHeight = "200px";
img.style.float.maxWidth = "200px";
d.appendChild(img);

for (var i = 0; i < 3 && i < b.length; i++) {
    var n = b[0];
    n.style.backgroundColor = "rgba(0,0,0,0)";
    n.style.textOverflow = "ellipsis";
    n.style.padding = "0px";

    d.appendChild(n);
}

body = document.createElement('body');



body.appendChild(d);

body.innerHTML;
