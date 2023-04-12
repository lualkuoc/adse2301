// Javascript document to be used at the template for our JS files.
// Use the new JS syntax of "use strict"

(function()
{    
    "use strict";

    // Create a variable that will hold the id of the container div
    var container = document.getElementById("container");
    // Create a div that will hold the content of this document
    var selectionDiv = document.createElement("div")
    let age = 20, votingStatus = "";

    if(age >= 20)
        votingStatus = "You are" + age + "Years old, hence you can vote";
    else
        votingStatus = "You are" + age + "Years old, hence you cannot vote";

    //Add the voting status message to the selectionDiv
    selectionDiv.innerHTML = votingStatus;
    // Add the contents of the selectionDiv to the container div
    container.appendChild(selectionDiv)
}());