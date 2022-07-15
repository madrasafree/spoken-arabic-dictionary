<html>
    <head>
        <title>.NET Server Time Script</title>
        <script runat='server' language='VB'>
            sub Page_Load(s as Object,e as EventArgs)
                lblTime.Text = DateTime.Now.ToString()
            End sub
        </script>
    </head>
    <body>
        <asp:Label runat='server' id='lblTime' />
    </body>
</html>