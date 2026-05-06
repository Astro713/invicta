<!--#include file="FileLastMod.asp"-->

    </div>
    <!-- /.container -->

    <div id="footer" class="footer rounded-bottom border border-default">
      <div class="container">
        <div class="row text-center">
          <div class="text-muted small col">&copy;<%=Year(Now())%> <a href="https://cmsworldwide.com/" target="_blank">Conference Management Services, Inc.</a></div>
          <div class="text-muted small col">Last updated <%=FileLastMod()%></div>
        </div><!--/.row-->
        <div class="row text-center">
          <div class="text-muted small col">Contact: <a href="mailto:<%=strWebSupport%>"><%=strWebSupport%></a> Host: <a href="https://cmsworldwide.com/" target="_blank">https://cmsworldwide.com/</a></div>
        </div><!--/.row-->
      </div><!--/.container-->
    </div>

  </body>

</html>
