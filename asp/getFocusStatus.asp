<%@ LANGUAGE="JSCRIPT" %>
<script language="JScript" type="text/jscript" runat="server">
    function endResponse() {
        Response.Write("\n----\n");
        Response.End();
    }
    Response.ContentType = "text/json";
    try {
        // var F = new ActiveXObject("FocusMax.Focuser");
        var F = new ActiveXObject("FocusMax.FocusControl");
        // var Fx = new ActiveXObject("FocusMax.Focuser"); //direct focuser commands
        var pos = String(F.Position);
        var isBusy = String(F.IsBusy);
        Response.Write(pos + "," + isBusy);
    }
    catch(ex) {
        Response.Write("Error: " + ex.Message);
        endResponse();
    }


</script>