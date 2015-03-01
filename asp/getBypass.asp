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
    Response.ContentType = "text/json";
    try {
        var line;
        var bypass = "?";
        var tel = "?";
        var fso = new ActiveXObject("Scripting.FileSystemObject");
        var textFile = fso.OpenTextFile("C:\\Users\\Public\\Documents\\ACP Web Data\\Doc Root\\files\\config.dat", 1); // 1 is for reading
        // loop over lines in file, ignoring comments
        while(!textFile.AtEndOfStream) {
            line = String(textFile.ReadLine());
            if (!(line.charAt(0)==";")){
                    if (line.search("no")>0){
                        bypass = "no";
                    }
                    if (line.search("yes")>0){
                        bypass = "yes";
                    }
                    if (line.search("3.5")>0){
                        tel = "3.5";
                    }
                    if (line.search("2.5")>0){
                        tel = "2.5"
                    }

            }
        }
        textFile.Close();
        Response.Write(bypass + "," + tel);

    }
    catch(ex) {
        Response.Write("Failed: " + (ex.message ? ex.message : ex));
        endResponse();                                          // End response here
    }



</script>