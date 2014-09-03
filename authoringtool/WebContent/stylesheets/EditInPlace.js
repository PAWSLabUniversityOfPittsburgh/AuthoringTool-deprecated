EditInPlace = function ( element, lines, callback )
    {
    this.element = element;
    this.lines = lines;
    this.callback = callback;

    this.savedBackgroundColor = element.style.backgroundColor;
    if ( element.title == null || element.title == '' )
	element.title = 'Click to edit';
    else
	element.title += ' - click to edit';

    element.onmouseover = EditInPlace.MakeCaller( EditInPlace.Yellowfy, this );
    element.onmouseout = EditInPlace.MakeCaller( EditInPlace.DeYellowfy, this );
    element.onclick = EditInPlace.MakeCaller( EditInPlace.Edit, this );
    };


EditInPlace.yellow = '#ffffcc';


EditInPlace.Yellowfy = function ( eip )
    {
    eip.element.style.backgroundColor = EditInPlace.yellow;
    };


EditInPlace.DeYellowfy = function ( eip )
    {
    eip.element.style.backgroundColor = eip.savedBackgroundColor;
    };


EditInPlace.Edit = function ( eip )
    {
    if ( eip.editElement == null )
	{
	// Create editElement.  Structure is as follows:
	// <form>
	//   <table border="0">
	//     <tbody>
	//       <tr>
	//         <td>
	//           <input type="text">
	//         </td>
	//       </tr>
	//       <tr>
	//         <td align="right">
	//           <input type="submit" value="Sure">
	//           <span>&nbsp;</span>
	//           <input type="submit" value="Cancel">
	//         </td>
	//       </tr>
	//     </tbody>
	//   </table>
	// </form>

	eip.editElement = document.createElement( 'form' );
	eip.editElement.method = 'get';
	eip.editElement.action = 'javascript:void(0);';
	eip.editElement.style.marginTop = '0';
	eip.editElement.style.marginBottom = '0';
	eip.element.parentNode.insertBefore( eip.editElement, eip.element );

	var tableElement = document.createElement( 'table' );
	tableElement.border = 0;
	eip.editElement.appendChild( tableElement );

	var tbodyElement = document.createElement( 'tbody' );
	tableElement.appendChild( tbodyElement );

	var tr1Element = document.createElement( 'tr' );
	tbodyElement.appendChild( tr1Element );

	var td1Element = document.createElement( 'td' );
	tr1Element.appendChild( td1Element );

	if ( eip.lines == 1 )
	    {
	    eip.inputElement = document.createElement( 'input' );
	    eip.inputElement.type = 'text';
	    eip.inputElement.value = eip.element.innerHTML;
	    }
	else
	    {
	    eip.inputElement = document.createElement( 'textarea' );
	    eip.inputElement.value = eip.element.innerHTML;
	    }
	//eip.inputElement.style.cssText = eip.element.style.cssText;
	eip.inputElement.style.width = eip.element.style.width;
	eip.inputElement.style.height = ( eip.lines * 1.6 ).toFixed(1) + 'em';
	eip.inputElement.style.backgroundColor = EditInPlace.yellow;
	eip.inputElement.onkeypress = EditInPlace.MakeCaller( EditInPlace.KeyPress, eip );
	td1Element.appendChild( eip.inputElement );

	var tr2Element = document.createElement( 'tr' );
	tbodyElement.appendChild( tr2Element );

	var td2Element = document.createElement( 'td' );
	td2Element.align = "right";
	tr2Element.appendChild( td2Element );

	var saveElement = document.createElement( 'input' );
	saveElement.type = 'submit';
	saveElement.value = 'Save';
	saveElement.onclick = EditInPlace.MakeCaller( EditInPlace.Save, eip );
	td2Element.appendChild( saveElement );

	var spanElement = document.createElement( 'span' );
	spanElement.innerHTML = '&nbsp;';
	td2Element.appendChild( spanElement );

	var cancelElement = document.createElement( 'input' );
	cancelElement.type = 'submit';
	cancelElement.value = 'Cancel';
	cancelElement.onclick = EditInPlace.MakeCaller( EditInPlace.Cancel, eip );
	td2Element.appendChild( cancelElement );
	}
    eip.element.style.display = 'none';
    eip.editElement.style.display = '';
    eip.inputElement.select();
    };


EditInPlace.KeyPress = function ( eip )
    {
    // This only works in MSIE, but it's also only needed in MSIE.
    // In Firefox, hitting Enter in the input field automatically
    // triggers the onsubmit action of the first button.
    if ( window.event && window.event.keyCode == 13 )
      EditInPlace.Save( eip );
    };


EditInPlace.Save = function ( eip )
    {
    eip.element.innerHTML = eip.inputElement.value;
    eip.editElement.style.display = 'none';
    eip.element.style.display = '';
    EditInPlace.DeYellowfy( eip );
    if ( eip.callback != null )
	eip.callback();
    };

EditInPlace.Cancel = function ( eip )
    {
    eip.editElement.style.display = 'none';
    eip.element.style.display = '';
    EditInPlace.DeYellowfy( eip );
    };


// This returns a function closure that calls the given routine with the
// specified arg.
EditInPlace.MakeCaller = function ( func, arg )
    {
    return function () { func( arg ); };
    };
