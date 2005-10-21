<%@ include file="/taglibs.jsp" %><%@ include file="/theme/header.jsp" %>
<%@ page import="org.roller.pojos.*" %>
<%@ page import="org.roller.presentation.weblog.formbeans.WeblogEntryFormEx" %>
<%@ page import="org.roller.presentation.weblog.actions.WeblogEntryPageModel" %>
<%@ page import="org.roller.presentation.RollerRequest" %>
<%
WeblogEntryPageModel model = (WeblogEntryPageModel)request.getAttribute("model");
try {
%>
<script type="text/javascript">
<!--
function postWeblogEntry() {
    document.weblogEntryFormEx.submit();
}
function spellCheck() {
    document.weblogEntryFormEx.method.value = "spellCheck";
    postWeblogEntry();
}
function previewMode() {
    document.weblogEntryFormEx.method.value = "preview";
    postWeblogEntry();
}
function returnToEditMode() {
    document.weblogEntryFormEx.method.value = "returnToEditMode";
    postWeblogEntry();
}
function submitSpellingCorrections() {
    document.weblogEntryFormEx.method.value = "correctSpelling";
    postWeblogEntry();
}
function deleteWeblogEntry() {
    document.weblogEntryFormEx.method.value = "removeOk";
    postWeblogEntry();
}
function updateComments() {
    document.weblogEntryFormEx.method.value = "updateComments";
    postWeblogEntry();
}
function sendTrackback() {
    document.weblogEntryFormEx.method.value = "sendTrackback";
    postWeblogEntry();
}
function saveDraft() {
    document.weblogEntryFormEx.publishEntry.value = "false";
    document.weblogEntryFormEx.method.value = "save";
    postWeblogEntry();
}
function publish() {
    document.weblogEntryFormEx.publishEntry.value = "true";
    document.weblogEntryFormEx.method.value = "save";
    postWeblogEntry();
}
-->
</script>

<h1><fmt:message key="weblogEdit.pageTitle" /></h1>

<html:form action="/editor/weblog" method="post" focus="title">

    <html:hidden property="day"/>
    <html:hidden property="id"/>
    <html:hidden property="anchor"/>
    <html:hidden property="updateTime"/>
    <html:hidden property="publishEntry"/>
    <html:hidden name="method" property="method" value="save"/>

   <%-- ================================================================== --%>
   <%-- weblog entry fields: title, link, category, etc. --%>

   <div class="row">
        <label style="width:10%; float:left;" for="title"><fmt:message key="weblogEdit.title" /></label>
        <c:if test="${!empty weblogEntryFormEx.id}">
        <a href="#trackbacks" style="float:right"><fmt:message key="weblogEdit.trackbacks" /></a>
        </c:if>
        <html:text property="title" size="70" maxlength="255" tabindex="1" />
    </div>

    <div class="row">
        <label style="width:10%; float:left;" for="link"><fmt:message key="weblogEdit.link" /></label>
        <c:if test="${model.editMode && !empty model.comments}" >
        <a href="#comments" style="float:right"><fmt:message key="weblogEdit.comments" /></a>
        </c:if>
        <html:text property="link" size="70" maxlength="255" tabindex="2" />
    </div>

    <div class="row">
        <label style="width:10%; float:left;" for="categoryId"><fmt:message key="weblogEdit.category" /></label>
        <html:select property="categoryId" size="1" tabindex="4">
            <html:optionsCollection name="model" property="categories" value="id" label="path"  />
        </html:select>
    </div>

    <c:if test="${!empty weblogEntryFormEx.id}">
        <div class="row">
            <label style="width:10%; float:left;" for="categoryId">
               <fmt:message key="weblogEdit.permaLink" />
            </label>
            <a href='<c:out value="${model.permaLink}" />'>
               <c:out value="${model.permaLink}" />
            </a>
        </div>
    </c:if>

    <div class="row">
        <label style="width:10%; float:left;" for="title">
           <fmt:message key="weblogEdit.status" />
        </label>
        <c:if test="${!empty weblogEntryFormEx.id}">
            <c:if test="${weblogEntryFormEx.publishEntry}">
                <span style="color:green; font-weight:bold">
                   <fmt:message key="weblogEdit.published" />
                   (<fmt:message key="weblogEdit.updateTime" />
                   <fmt:formatDate value="${weblogEntryFormEx.updateTime}" type="both"
                      dateStyle="short" timeStyle="short" />)
                </span>
            </c:if>
            <c:if test="${!weblogEntryFormEx.publishEntry}">
                <span style="color:orange; font-weight:bold">
                   <fmt:message key="weblogEdit.draft" />
                   (<fmt:message key="weblogEdit.updateTime" />
                   <fmt:formatDate value="${weblogEntryFormEx.updateTime}" type="both"
                      dateStyle="short" timeStyle="short" />)
                </span>
            </c:if>
        </c:if>
        <c:if test="${empty weblogEntryFormEx.id}">
           <span style="color:red; font-weight:bold"><fmt:message key="weblogEdit.unsaved" /></span>
        </c:if>
    </div>

    <%-- ================================================================== --%>
    <%-- Weblog edit, preview, or spell check area --%>

    <%-- EDIT MODE --%>
    <c:if test="${model.editMode}">

    <div style="width: 100%;"> <%-- need this div to control text-area size in IE 6 --%>

       <%-- include edit page --%>
       <div style="clear:both">
            <jsp:include page="<%= model.getEditorPage() %>" />
       </div>

     </div>

    </c:if>

    <%-- PREVIEW MODE --%>
    <c:if test="${model.previewMode}" >
        <br />
        <div class="centerTitle"><fmt:message key="weblogEdit.previewMode" /></div>
        <html:hidden property="text" />
        <div class="previewEntry">
           <roller:ApplyPlugins name="model" property="weblogEntry" skipFlag="true" />
        </div>
    </c:if>

    <%-- SPELLCHECK MODE --%>
    <c:if test="${model.spellMode}" >
        <br />
        <div class="centerTitle"><fmt:message key="weblogEdit.spellMode" /></div>
        <html:hidden property="text" />
        <div class="previewEntry">
           <c:out value="${model.spellCheckHtml}" escapeXml="false" />
        </div>
    </c:if>

   <%-- ================================================================== --%>
   <%-- the button box --%>

   <br />
   <div class="control">

        <%-- save draft and post buttons: only in edit and preview mode --%>
        <c:if test="${model.editMode || model.previewMode}" >

            <input type="button" name="post"
                   value='<fmt:message key="weblogEdit.post" />'
                   onclick="publish()" />

            <input type="button" name="draft"
                   value='<fmt:message key="weblogEdit.save" />'
                   onclick="saveDraft()" />

            <%-- if entry has been saved, then show delete button --%>
            <c:if test="${!empty weblogEntryFormEx.id}">
                <input type="button" name="draft"
                       value='<fmt:message key="weblogEdit.deleteEntry" />'
                       onclick="deleteWeblogEntry()" />
            </c:if>

        </c:if>

        <%-- edit mode buttons --%>
        <c:if test="${model.editMode}" >

            <input type="button" name="preview"
                   value='<fmt:message key="weblogEdit.previewMode" />'
                   onclick="previewMode()" />

            <input type="button" name="spelling"
                   value='<fmt:message key="weblogEdit.check" />'
                   onclick="spellCheck()" />

        </c:if>

        <%-- preview mode buttons --%>
        <c:if test="${model.previewMode}" >
            <input type="button" name="edit" value='<fmt:message key="weblogEdit.returnToEditMode" />'
                   onclick="returnToEditMode()" />
        </c:if>

        <%-- spell mode buttons --%>
        <c:if test="${model.spellMode}" >

            <input type="button" name="correctSpelling"
                   value='<fmt:message key="weblogEdit.correctSpelling" />'
                   onclick="submitSpellingCorrections()"  />

            <input type="button" name="cancelSpelling"
                   value='<fmt:message key="weblogEdit.cancelSpelling" />'
                   onclick="returnToEditMode()" />

        </c:if>
    </div>
    <br />
    
  <%-- ================================================================== --%>
  <%-- publish time --%>

  <div id="dateControlToggle" class="controlToggle">
     <span id="idateControl">+</span>
     <a class="controlToggle" onclick="javascript:toggleControl('dateControlToggle','dateControl')">
        <fmt:message key="weblogEdit.pubTime" />
     </a>
  </div>
  <div id="dateControl" class="control" style="display:none">
           <html:select property="hours">
               <html:options name="model" property="hoursList" />
            </html:select>
           :
           <html:select property="minutes" >
               <html:options name="model" property="minutesList" />
           </html:select>
           :
           <html:select property="seconds">
               <html:options name="model" property="secondsList" />
           </html:select>
           &nbsp;&nbsp;
           <roller:Date property="dateString" dateFormat='<%= model.getShortDateFormat() %>' />
           <c:out value="${model.weblogEntry.website.timezone}" />
  </div>
  <script type="text/javascript">
  <!--
  toggleControl('dateControlToggle','dateControl');
  -->
  </script>

  <%-- ================================================================== --%>
  <%-- comment settings --%>

  <div id="commentControlToggle" class="controlToggle">
  <span id="icommentControl">+</span>
  <a class="controlToggle" onclick="javascript:toggleControl('commentControlToggle','commentControl')">
     <fmt:message key="weblogEdit.commentSettings" />
  </a>
  </div>
  <div id="commentControl" class="control" style="display:none">
     <html:checkbox property="allowComments" onchange="onAllowCommentsChange()" />
     <fmt:message key="weblogEdit.allowComments" />
     <fmt:message key="weblogEdit.commentDays" />
     <html:select property="commentDays">
         <html:option key="weblogEdit.unlimitedCommentDays" value="0"  />
         <html:option key="weblogEdit.days1" value="1"  />
         <html:option key="weblogEdit.days2" value="2"  />
         <html:option key="weblogEdit.days3" value="3"  />
         <html:option key="weblogEdit.days4" value="4"  />
         <html:option key="weblogEdit.days5" value="5"  />
         <html:option key="weblogEdit.days7" value="7"  />
         <html:option key="weblogEdit.days10" value="10"  />
         <html:option key="weblogEdit.days20" value="20"  />
         <html:option key="weblogEdit.days30" value="30"  />
         <html:option key="weblogEdit.days60" value="60"  />
         <html:option key="weblogEdit.days90" value="90"  />
     </html:select>
     <br />
  </div>

  <%-- ================================================================== --%>
  <%-- plugin chooser --%>

  <c:if test="${model.hasPagePlugins}">
      <div id="pluginControlToggle" class="controlToggle">
      <span id="ipluginControl">+</span>
      <a class="controlToggle" onclick="javascript:toggleControl('pluginControlToggle','pluginControl')">
         <fmt:message key="weblogEdit.pluginsToApply" /></a>
      </div>
      <div id="pluginControl" class="control" style="display:none">
        <logic:iterate id="plugin" type="org.roller.presentation.velocity.PagePlugin"
            collection="<%= org.roller.presentation.velocity.ContextLoader.getPagePlugins() %>">
            <html:multibox property="pluginsArray"
                 title="<%= plugin.getName() %>" value="<%= plugin.getName() %>"
                 styleId="<%= plugin.getName() %>"/></input>
            <label for="<%= plugin.getName() %>"><%= plugin.getName() %></label>
            <a href="javascript:void(0);" onmouseout="return nd();"
            onmouseover="return overlib('<%= plugin.getDescription() %>', STICKY, MOUSEOFF, TIMEOUT, 3000);">?</a>
            <br />
        </logic:iterate>
      </div>
  </c:if>

  <%-- ================================================================== --%>
  <%-- misc settings  --%>

  <div id="miscControlToggle" class="controlToggle">
  <span id="imiscControl">+</span>
  <a class="controlToggle" onclick="javascript:toggleControl('miscControlToggle','miscControl')">
     <fmt:message key="weblogEdit.miscSettings" /></a>
  </div>
  <div id="miscControl" class="control" style="display:none">

     <html:checkbox property="rightToLeft" />
     <fmt:message key="weblogEdit.rightToLeft" />
     <br />

     <c:if test="${model.isAdmin}">
         <html:checkbox property="pinnedToMain" />
         <fmt:message key="weblogEdit.pinnedToMain" />
         <br />
     </c:if>
     <c:if test="${!model.isAdmin}">
         <html:hidden property="pinnedToMain" />
     </c:if>

  </div>

  <%-- ================================================================== --%>
  <%-- MediaCast settings  --%>

  <div id="mediaCastControlToggle" class="controlToggle">
  <span id="imediaCastControl">+</span>
  <a class="controlToggle" onclick="javascript:toggleControl('mediaCastControlToggle','mediaCastControl')">
     MediaCast Settings</a>
  </div>
  <div id="mediaCastControl" class="control" style="display:none">
  <%
  WeblogEntryFormEx form = model.getWeblogEntryForm();
  String att_url = (String)form.getAttributes().get("att_mediacast_url");
  att_url = (att_url == null) ? "" : att_url;
  %>
     <b>URL:</b> <input name="att_mediacast_url" type="text" size="80" maxlength="255" value='<%= att_url %>' />
<%
  String att_type = (String)form.getAttributes().get("att_mediacast_type");
  String att_length = (String)form.getAttributes().get("att_mediacast_length");
%>
<% if (att_url != null && att_type != null && att_length != null) { %>
     <b>Type:</b> <%= att_type %>
     <b>Length:</b> <%= att_length %>
<% } else if (att_url != null && att_url.trim().length()!=0) { %>
     <span style="color:red">MediaCast URL is invalid</span>
<% } %>
  </div>

    <%-- ================================================================== --%>
    <%-- Trackback control --%>
    <c:if test="${!empty weblogEntryFormEx.id}">
        <br />
        <br />
        <a name="trackbacks"></a>
        <h1><fmt:message key="weblogEdit.trackback" /></h1>
        <fmt:message key="weblogEdit.trackbackUrl" /><br />
        <html:text property="trackbackUrl" size="80" maxlength="255" />

        <input type="button" name="draft"
            value='<fmt:message key="weblogEdit.sendTrackback" />'
            onclick="sendTrackback()" />

    </c:if>

    <%-- ================================================================== --%>
    <%-- Comments of this weblog entry --%>

    <c:if test="${model.editMode && !empty model.comments}" >
        <br />
        <br />
        <a name="comments"></a>
        <h1><fmt:message key="weblogEdit.comments" /></h1>
        <br />
        <table class="rollertable">
            <tr>
                <th class="rollertable"><fmt:message key="weblogEdit.commentDelete" /></th>
                <th class="rollertable"><fmt:message key="weblogEdit.commentSpam" /></th>
                <th class="rollertable"><fmt:message key="weblogEdit.comment" /></th>
            <tr>
            <c:forEach var="comment" items="${model.comments}">
                <tr>

                    <td class="rollertable_entry" >
                        <html:multibox property="deleteComments">
                            <c:out value="${comment.id}" />
                        </html:multibox>
                    </td>

                    <td class="rollertable_entry" >
                        <html:multibox property="spamComments">
                            <c:out value="${comment.id}" />
                        </html:multibox>
                    </td>

                    <td class="rollertable_entry" valign="top" >
                        <span class="entryDetails">
                           <fmt:message key="weblogEdit.commenterName" />
                               [<c:out value="${comment.name}" />] |
                           <fmt:formatDate value="${comment.postTime}" type="both"
                               dateStyle="medium" timeStyle="medium" /><br />
                           <fmt:message key="weblogEdit.commenterEmail" />:
                               <c:out value="${comment.email}" /><br />
                           <fmt:message key="weblogEdit.commenterUrl" />:
                               <c:out value="${comment.url}" /><br />
                        </span>
                        <br />
                        <c:out value="${comment.content}" />
                    </td>

                </tr>
            </c:forEach>
         </table>

         <br />
         <input type="button" name="post"
               value='<fmt:message key="weblogEdit.updateComments" />'
             onclick="updateComments(true)" />
    </c:if>

</html:form>

<%--
Add this back in once it has been properly internationalized
<iframe id="keepalive" width="100%" height="25" style="border: none;"
        src="<%= request.getContextPath() %>/keepalive.jsp" ></iframe>
--%>

<%@ include file="/theme/footer.jsp" %>

<script type="text/javascript">
<!--
try {Start();} catch (e) {};
-->
</script>

<% } catch (Throwable e) { e.printStackTrace(); } %>


