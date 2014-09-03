var set=false;
var v=0;
var a;
function loadStars()
{
   star1 = new Image();
   star1.src = "images/star1.gif";
   star2 = new Image();
   star2.src= "images/star2.gif";
}

function highlight(x)
{
   if (set==false)
   {
   y=x*1+1
   switch(x)
   {
   case "1": document.getElementById(x).src= star2.src;
   document.getElementById('vote').innerHTML="Highly Negtive";
   break;
   case "2":for (i=1;i<y;i++)
   {
   document.getElementById(i).src= star2.src;
   }
   document.getElementById('vote').innerHTML="Negtive"
   break;
   case "3":for (i=1;i<y;i++)
   {
   document.getElementById(i).src= star2.src;
   }
   document.getElementById('vote').innerHTML="Neutral"
   break;
   case "4":for (i=1;i<y;i++)
   {
   document.getElementById(i).src= star2.src;
   }
   document.getElementById('vote').innerHTML="Positve"
   break;
   case "5":for (i=1;i<y;i++)
   {
   document.getElementById(i).src= star2.src;
   }
   document.getElementById('vote').innerHTML="Highly Positive"
   break;
   }
   }
}
function losehighlight(x)
{
   if (set==false)
   {
   for (i=1;i<6;i++)
   {
   document.getElementById(i).src=star1.src;
   document.getElementById('vote').innerHTML=""
   }
   }
   }

function setStar(x)
   {
   y=x*1+1
   if (set==false)
   {
   switch(x)
   {
   case "1": a="1"
   flash(a);
   break;
   case "2": a="2"
   flash(a);
   break;
   case "3": a="3"
   flash(a);
   break;
   case "4":a="4"
   flash(a);
   break;
   case "5":a="5"
   flash(a);
   break;
   }
   set=true;
   document.getElementById('vote').innerHTML=" Press Submit to give ratings!";   
   document.getElementById('rate').value=a;         
   }
}
function flash()
{
   y=a*1+1
   switch(v)
   {
   case 0:
   for (i=1;i<y;i++)
   {
   document.getElementById(i).src= star1.src;
   }
   v=1
   setTimeout(flash,200)
   break;
   case 1:
   for (i=1;i<y;i++)
   {
   document.getElementById(i).src= star2.src;
   }
   v=2
   setTimeout(flash,200)
   break;
   case 2:
   for (i=1;i<y;i++)
   {
   document.getElementById(i).src= star1.src;
   }
   v=3
   setTimeout(flash,200)
   break;
   case 3:
   for (i=1;i<y;i++)
   {
   document.getElementById(i).src= star2.src;
   }
   v=4
   setTimeout(flash,200)
   break;
   case 4:
   for (i=1;i<y;i++)
   {
   document.getElementById(i).src= star1.src;
   }
   v=5
   setTimeout(flash,200)
   break;
   case 5:
   for (i=1;i<y;i++)
   {
   document.getElementById(i).src= star2.src;
   }
   v=6
   setTimeout(flash,200)
   break;
   }
}
