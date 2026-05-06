<!--#include file="_config_menu.asp"-->
<%
Sub DrawMenu(intLevel, strSelected)
  Dim strPrefix, a, b
  strPrefix = PrefixLevels(intLevel-1, "../")

  For a = 0 to UBound(aryMenuButtons)
    If IsArray(aryMenuButtons(a)(2)) Then
      For b = 0 to UBound(aryMenuButtons(a)(2))
        If StrComp(aryMenuButtons(a)(2)(b)(1), strSelected)=0 Then
          aryMenuButtons(a)(3)=vbTrue
          aryMenuButtons(a)(2)(b)(2)=vbTrue
        End If
      Next
    Else
      If StrComp(aryMenuButtons(a)(1), strSelected)=0 Then
        aryMenuButtons(a)(3)=vbTrue
      End If
    End If
  Next
%>
<ul class="navbar-nav mr-auto">
<%
  For Each Button in aryMenuButtons
    If Button(0)="" Then %>

  <li class="spacer">&nbsp;</li><%

    ElseIf IsArray(Button(2)) Then %>

  <li class="nav-item dropdown">
    <a href="#" class="nav-link dropdown-toggle<% If Button(3) Then %> active <% End If %>" data-toggle="dropdown"><%=Server.HTMLEncode(Button(0))%></a>
    <div class="dropdown-menu"> <%
        For Each MenuItem in Button(2) %>
      <a href="<%=strPrefix & MenuItem(1)%>" class="dropdown-item <% If MenuItem(2) Then %> active <% End If %>"><%=Server.HTMLEncode(MenuItem(0))%></a><%
        Next %>
    </div>
  </li>

  <%
    Else %>

  <li class="nav-item <% If Button(3) Then %> active <% End If %><% If Len(Button(4))>0 Then %> <%=Button(4)%> <% End If %>">
    <a class="nav-link" href="<%=strPrefix & Button(1)%>" <% If Button(1)="" Then %><% End If %>><%=Server.HTMLEncode(Button(0))%></a>
  </li><%

    End If

  Next %>

</ul><%

End Sub

Private Function PrefixLevels (intQty, strPrefix)
  PrefixLevels = ""
  Dim a
  For a = 1 to intQty
    PrefixLevels = PrefixLevels & strPrefix
  Next
End Function

%>
