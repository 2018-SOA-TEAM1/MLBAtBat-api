$('#datepicker').datepicker({
    uiLibrary: 'bootstrap4'
});

function storeDate() {
    var date = document.getElementById("datepicker").value;
    document.cookie = "date=" + date
}

var click = 0
function addTeamName(team_name) {
    if (click % 2 == 0) {
        var myNode = document.getElementById("team-name-input");
        while (myNode.firstChild) {
            myNode.removeChild(myNode.firstChild);
        }

        var option = document.createElement("option");
        option.selected = true;
        option.innerHTML = "Choose...";
        document.getElementById("team-name-input").appendChild(option);
        var len = team_name.length
        for (i = 0; i < len; i++) {
            var option = document.createElement("option");
            option.value = i;
            option.innerHTML = team_name[i];
            document.getElementById("team-name-input").appendChild(option);
        }
    }
    click += 1
}