<%@ LANGUAGE="JSCRIPT" %>
<script language="JScript" type="text/jscript" runat="server">
    //
    //
    function endResponse() {
        Response.Write("\n----\n");
        Response.End();
    }
    //
    // Main script
    //
    Response.ContentType = "text/plain";
    Response.Write("\n----\n");
    try {
        var fso = new ActiveXObject("Scripting.FileSystemObject");
        var fromFile = fso.GetFile("C:\\Users\\Public\\Documents\\ACP Config\\domeflat.txt")
        var toFile = "C:\\Users\\Public\\Documents\\ACP Config\\AutoFlatConfig.txt"
        fromFile.Copy(toFile)
        Response.Write("Dome Flat Config File Set")
    } catch(ex) {
        Response.Write("Failed: " + (ex.message ? ex.message : ex));
        endResponse();                                          // End response here
    }



</script>