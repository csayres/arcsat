<%@ LANGUAGE="JSCRIPT" %>
<script language="JScript" type="text/jscript" runat="server">
    Response.ContentType = "text/json";
    function endResponse() {
        Response.Write("\n----\n");
        Response.End();
    }

    function formatDateString(dateObj){
        // from a JS dateObj, format and return a date string

        // helper functions
        function zeropad(aNumber){
            // if the number is less than 10
            // add a leading 0
            // return a string
            if (aNumber<10){
                return "0" + String(aNumber);
            }
            else{
                return String(aNumber);
            }
        }

        function hoursFromMilitary(hour){
            // convert hour on a 0-23 hour clock
            // to hours on 1-12 hour clock
            // return a string
            // 0 hours is actually 12 AM
            if(hour==0){
                hour=12;
            }
            if(hour>12){
                hour = hour - 12;
            }
            return String(hour);
        }

        var year = String(dateObj.getFullYear()); //YYYY
        var month = String(dateObj.getMonth() + 1); // getMonth range 0-11
        var day = String(dateObj.getDate()); // range 1-31
        var hour = dateObj.getHours(); // range 0-23
        var minute = zeropad(dateObj.getMinutes());
        var second = zeropad(dateObj.getSeconds());
        var amOrPm = "AM";
        if(hour>11){
            amOrPm = "PM";
        }
        // convert hour to 12 hour clock
        hour = hoursFromMilitary(hour);
        var dateStr = month + "/" +
                      day + "/" +
                      year + " " +
                      hour + ":" +
                      minute + ":" +
                      second + " " +
                      amOrPm;
        return dateStr;
    }

    function updateFilterStateFile(absMoveVal){
        // update FilterState.txt in Public\Public Documents\ACP Config
        // with this absolute focus position
        // ACP looks here automatically when taking a new exposure
        // file is 3 lines long, with the 2nd line being
        // the focus value
        var filterStateFilePath = "C:\\Users\\Public\\Documents\\ACP Config\\FilterState.txt";
        // get current filter position
        var fwPos = String(Camera.Filter); // this was just dumb luck that it worked...
        // get current date
        var dateNow = new Date();
        var timeStamp = formatDateString(dateNow);
        // write the file, overwrite if exists already
        var fso = new ActiveXObject("Scripting.FileSystemObject");
        var toFile = fso.CreateTextFile(filterStateFilePath, true);
        toFile.WriteLine(fwPos);
        toFile.WriteLine(absMoveVal);
        toFile.WriteLine(timeStamp);
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
                Response.Write("DONE?!!?");
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