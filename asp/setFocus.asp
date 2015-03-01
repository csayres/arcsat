<%@ LANGUAGE="JSCRIPT" %>
<script language="JScript" type="text/jscript" runat="server">
    Response.ContentType = "text/json";
    function endResponse() {
        Response.Write("\n----\n");
        Response.End();
    }

    function updateFilterStateFile(absMoveVal){
        // update FilterState.txt in Public\Public Documents\ACP Config
        // with this absolute focus position
        // ACP looks here automatically when taking a new exposure
        // file is 3 lines long, with the 2nd line being
        // the focus value
        var i; // iterator
        var ForReading = 1;
        var filterStateFilePath = "C:\\Users\\Public\\Documents\\ACP Config\\FilterState.txt";
        var fso = new ActiveXObject("Scripting.FileSystemObject");
        Response.Write("1");
        Response.Write(fso.FileExists(filterStateFilePath));
        Response.Write("2");
        if (fso.FileExists(filterStateFilePath)){
            var fileLines = [];
            var fromFile = fso.OpenTextFile(filterStateFilePath, ForReading);
            while (!fromFile.AtEndOfStream){
                var line = fromFile.ReadLine();
                fileLines.push(line);
                }
            fromFile.Close();
        }
        else{
            // file didn't exist fake the entries
            var fileLines = ["?", String(absMoveVal), "?"];
        }
        // overrite file with new
        var toFile = fso.CreateTextFile(filterStateFilePath, true);
        for(i=0; i<3; i++){
            if(i==1){
                // insert our own focus value on second line
                toFile.WriteLine(absMoveVal);
            }
            else{
                toFile.WriteLine(fileLines[i]);
            }
        }
        toFile.Close();

    }

    try {
        // note this focuser is an absolute focuser.
        // incremantal focus changes must be computed
        var FC = new ActiveXObject("FocusMax.FocusControl");
        var F = new ActiveXObject("FocusMax.Focuser");
        var maxStep = F.MaxStep
        // Console.PrintLint("here!");
        var splitLine = String(Request.ServerVariables("QUERY_STRING")).split("=");
        var cmd = splitLine[0];
        function executeMove(absMoveVal){
            // check bounds of move
            if(absMoveVal>=0 && absMoveVal<maxStep){
                FC.Move(absMoveVal);
                updateFilterStateFile(absMoveVal);
            }
            else{
                // move is out of bounds
                Response.Write("Error: Cannot move to position "+absMoveVal+", must in [0, "+maxStep+"]");
            }
        }
        if (cmd=="stop"){
            FC.Halt();
            // Response.Write("sending a stop")
        }
        else if(cmd=="absMove"){
            var absMoveVal = parseInt(splitLine[1]);
            executeMove(absMoveVal);
        }
        else if(cmd=="offsetMove"){
            var offsetMoveVal = parseInt(splitLine[1]);
            var currentPos = parseInt(FC.Position);
            var absMoveVal = currentPos + offsetMoveVal;
            executeMove(absMoveVal);
        }
        else{
            Response.Write("Error: unrecoginzed command: " + cmd);
        }

        // Response.Write("request: " + String(cmd));
        // Console.PrintLine(String(Request.Form));
        // Response.Write(String(Request.Form));
    }
    catch(ex) {
        Response.Write("Error: " + ex.Message);
        endResponse();
    }


</script>