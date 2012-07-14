<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns="http://www.w3.org/1999/xhtml"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main"
	xmlns:rels="http://schemas.openxmlformats.org/package/2006/relationships"
	xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships"
	xmlns:v="urn:schemas-microsoft-com:vml">
    
  <xsl:output method="xml" omit-xml-declaration="no" indent="yes" encoding="utf-8" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd" />
  <!-- <xsl:param name="Library" select="'BCL'" /> -->
 
  <xsl:template match="/">  
	<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="de" lang="de">
	<head></head>
	<body>
	<xsl:apply-templates /> 
    <!-- <xsl:apply-templates select="//Types[@Library=$Library]" mode="types" />
    <xsl:apply-templates select="//Types[@Library=$Library]" mode="index" /> -->
	</body>
	</html>
  </xsl:template>
  
  <xsl:template match="w:document">
	<xsl:apply-templates select="w:body" />
  </xsl:template>
  
  <xsl:template match="w:body">
	<xsl:apply-templates />
  </xsl:template>
  <xsl:preserve-space elements="p" />
  <xsl:preserve-space elements="body" />
  <xsl:preserve-space elements="w:body" />
  
  <xsl:template match="w:p">
	<p><!--<xsl:value-of select="." />--><xsl:apply-templates /> </p>
  </xsl:template>
  
  <xsl:template match="w:br">
	<br />
  </xsl:template>
  
  
  <xsl:template match="w:p[w:pPr/w:pStyle/@w:val='title']">
	<h1><!--<xsl:value-of select="." />--><xsl:apply-templates mode="headline" /></h1>
  </xsl:template>
  
  <xsl:template match="w:p[w:pPr/w:pStyle/@w:val='author']">
	<h4><xsl:apply-templates /></h4>
  </xsl:template>
  
  <xsl:template match="w:p[w:pPr/w:pStyle/@w:val='email']">
	<h4><xsl:apply-templates /></h4>
  </xsl:template>
  
  <xsl:template match="w:p[w:pPr/w:pStyle/@w:val='heading1'] | w:p[w:pPr/w:pStyle/@w:val='berschrift1'] | w:p[w:pPr/w:pStyle/@w:val='berschrift1keinInhalt'] ">
	<h2><xsl:apply-templates mode="headline" /></h2>
  </xsl:template>
  
  <xsl:template match="w:p[w:pPr/w:pStyle/@w:val='heading2'] | w:p[w:pPr/w:pStyle/@w:val='berschrift2']">
	<h3><xsl:apply-templates mode="headline" /></h3>
  </xsl:template>
  
  <xsl:template match="w:p[w:pPr/w:pStyle/@w:val='heading3'] | w:p[w:pPr/w:pStyle/@w:val='berschrift3']">
	<h4><xsl:apply-templates mode="headline" /></h4>
  </xsl:template>
  
  <xsl:template match="w:p[w:pPr/w:pStyle/@w:val='heading4'] | w:p[w:pPr/w:pStyle/@w:val='berschrift4']">
	<h5><xsl:apply-templates mode="headline" /></h5>
  </xsl:template>
  
  <xsl:template match="w:p[w:pPr/w:pStyle/@w:val='Listenabsatz']">
	<xsl:if test="not(preceding-sibling::w:p[1][w:pPr/w:pStyle/@w:val='Listenabsatz'])"><xsl:text disable-output-escaping="yes">&lt;ul></xsl:text></xsl:if>
	<li><xsl:apply-templates /></li>
	<xsl:if test="not(following-sibling::w:p[1][w:pPr/w:pStyle/@w:val='Listenabsatz'])"><xsl:text disable-output-escaping="yes">&lt;/ul></xsl:text></xsl:if>
  </xsl:template>
  
  <xsl:template match="w:r[w:rPr/w:b]"><strong><xsl:apply-templates /></strong></xsl:template>
  
  <xsl:template match="w:r[w:rPr/w:i]"><em><xsl:apply-templates /></em></xsl:template>
  
  <xsl:template match="w:instrText" />
  
  <xsl:template match="w:fldChar[@w:fldCharType='separate']"> </xsl:template>
  
  <xsl:template name="image">
    <xsl:param name="imageId">false()</xsl:param>
    <img src="{document('word/_rels/document.xml.rels')/rels:Relationships/rels:Relationship[@Id=$imageId]/@Target}.png" />
	<!-- substring-after(, 'media/') -->
  </xsl:template>
  
  <xsl:template match="w:object">
  <!-- document('word/_rels/document.xml.rels')/rels:Relationships/rels:Relationship/@Id 
  RelIds: <xsl:value-of select="document('word/_rels/document.xml.rels')/rels:Relationships/rels:Relationship/@Id" />
  -->
	<!--<img src="{document('word/_rels/document.xml.rels')/rels:Relationships/rels:Relationship/@Id[=./v:shape/v:imagedata/@r:id]/@Target}" />-->
	<xsl:call-template name="image">
	  <xsl:with-param name="imageId"><xsl:value-of select="v:shape/v:imagedata/@r:id" /></xsl:with-param>
    </xsl:call-template>
  </xsl:template>
  
  
  <!-- <xsl:template match="*" mode="types">
    <xsl:for-each select="./Type">
      <xsl:result-document href="{$Library}\{@FullName}.html">
        <html xmlns="http://www.w3.org/1999/xhtml">
        <head>
          <title><xsl:value-of select="@FullName" /></title>
          <style type="text/css">
            .block {background-color: gray; margin: 1em; padding: 1em;}
            .para, .span {}
            .todo { background-color: red; margin: 1em; }
            pre.code, div.code {font-family: monospace; background-color: lightgray; margin: 1em; padding: 1em;}
            table, td, th { border: 1px solid black; }
            .c { display: inline; font-family: monospace; }
            .paramref { text-decoration: underline; }
            .term { display: inline; font-family: sans-serif; font-style: italic; }
          </style>
        </head>
        <body><h1><xsl:value-of select="@FullName" /></h1>
          <xsl:call-template name="baseclass" />
          <xsl:call-template name="Docs" />
          <p><a href="index.html">Back to index</a></p>
        </body>
        </html>
      </xsl:result-document>
    </xsl:for-each>
  </xsl:template> -->
<!--  
  <xsl:template match="*" mode="index">
    <xsl:result-document href="{$Library}\index.html">
      <html xmlns="http://www.w3.org/1999/xhtml">
      <head>
        <title><xsl:value-of select="@FullName" /></title>
        <style type="text/css">
        </style>
      </head>
      <body>
        <h1>Classes in <xsl:value-of select="$Library" /></h1>
        <ul>
          <xsl:for-each select="./Type">
            <li><a href="{@FullName}.html"><xsl:value-of select="@FullName" /></a></li>
          </xsl:for-each>
        </ul>
      </body>
      </html>
    </xsl:result-document>
  </xsl:template>
  
<xsl:template name="Docs" match="Docs">
  <xsl:call-template name="DocsSummary" />
  <xsl:call-template name="DocsRemarks" />
  <xsl:call-template name="DocsExample" />
</xsl:template>

<xsl:template name="DocsContent">
  <xsl:param name="Content" />
  <xsl:for-each select="$Content/*|$Content/text()">
    <xsl:choose>
      <xsl:when test="string(node-name(.))='para'">
        <div class="para">
          <xsl:call-template name="DocsContent">
            <xsl:with-param name="Content" select="." />
          </xsl:call-template>
        </div>
      </xsl:when>
      <xsl:when test="string(node-name(.))='block'">
        <div class="block">
          <xsl:call-template name="DocsContent">
            <xsl:with-param name="Content" select="." />
          </xsl:call-template>
        </div>
      </xsl:when>
      <xsl:when test="string(node-name(.))='code'">
        <pre class="code">
          <xsl:call-template name="DocsContent">
            <xsl:with-param name="Content" select="." />
          </xsl:call-template>
        </pre>
      </xsl:when>
      <xsl:when test="string(node-name(.))='list'">
        <xsl:choose>
          <xsl:when test="string(@type) = 'table'">
            <table>
              <xsl:call-template name="tablecontent">
                <xsl:with-param name="Content" select="./*" />
              </xsl:call-template>
            </table>
          </xsl:when>
          <xsl:when test="string(@type='bullet')">
            <ul>
              <xsl:call-template name="listcontent">
                <xsl:with-param name="Content" select="./*" />
              </xsl:call-template>
            </ul>
          </xsl:when>
          <xsl:otherwise><span class="todo">LIST: <xsl:value-of select="@type" /></span></xsl:otherwise>
        </xsl:choose>        
      </xsl:when>
      <xsl:when test="string(node-name(.))='see'">
        <xsl:if test="@cref">
            <xsl:call-template name="linktoclass">
            <xsl:with-param name="classname" select="substring(string(@cref), 3)" />
          </xsl:call-template>
        </xsl:if>
        <xsl:if test="@langword">
          <var><xsl:value-of select="@langword" /></var>
        </xsl:if>
      </xsl:when>
      <xsl:when test="string(node-name(.))='c'">
        <div class="c"><xsl:call-template name="DocsContent">
          <xsl:with-param name="Content" select="." />
          </xsl:call-template>
        </div>
      </xsl:when>
      <xsl:when test="string(node-name(.))='term'">
        <div class="term"><xsl:call-template name="DocsContent">
          <xsl:with-param name="Content" select="." />
        </xsl:call-template></div>
      </xsl:when>
      <xsl:when test="string(node-name(.))='paramref'">
        <span class="paramref"><xsl:value-of select="@name" /></span>
      </xsl:when>
      <xsl:when test="string(node-name(.))='SPAN'">
        <div class="span"><xsl:call-template name="DocsContent">
          <xsl:with-param name="Content" select="." />
        </xsl:call-template></div>
      </xsl:when>
      <xsl:when test="string(node-name(.))='sup'">
        <sup><xsl:call-template name="DocsContent">
          <xsl:with-param name="Content" select="." />
          </xsl:call-template></sup>
      </xsl:when>
      <xsl:when test="string(node-name(.))='superscript'">
        <sup><xsl:value-of select="@term" /></sup>
      </xsl:when>
      <xsl:when test="string(node-name(.))=''">
        <xsl:value-of select="." />
      </xsl:when>
      <xsl:otherwise><span class="todo"><xsl:value-of select="string(node-name(.))" /></span></xsl:otherwise>
    </xsl:choose>
  </xsl:for-each>
</xsl:template>


<xsl:template name="listcontent">
  <xsl:param name="Content" />
  <xsl:for-each select="./item">
    <li><xsl:call-template name="DocsContent">
      <xsl:with-param name="Content" select="." />
    </xsl:call-template></li>
  </xsl:for-each>
</xsl:template>

<xsl:template name="tablecontent">
  <xsl:param name="Content" />
  <xsl:if test="exists(./listheader)">
    <tr>
      <xsl:for-each select="./listheader/*">
        <th><xsl:call-template name="DocsContent">
          <xsl:with-param name="Content" select="." />
          </xsl:call-template></th>
      </xsl:for-each>
    </tr>
  </xsl:if>
  <xsl:for-each select="./item">
    <tr>
      <xsl:for-each select="./*">
        <td><xsl:call-template name="DocsContent">
          <xsl:with-param name="Content" select="." />
          </xsl:call-template></td>
      </xsl:for-each>
    </tr>
  </xsl:for-each>
</xsl:template>

<xsl:template name="DocsSummary">
  <xsl:if test="count(Docs/summary) > 0">
    <h2>Summary</h2>
    <xsl:call-template name="DocsContent">
      <xsl:with-param name="Content" select="Docs/summary" />
    </xsl:call-template>
  </xsl:if>
</xsl:template>

<xsl:template name="DocsRemarks">
  <xsl:if test="count(Docs/remarks) > 0">
    <h2>Remarks</h2>
    <xsl:call-template name="DocsContent">
      <xsl:with-param name="Content" select="Docs/remarks" />
    </xsl:call-template>
  </xsl:if>
</xsl:template>

<xsl:template name="DocsExample">
  <xsl:if test="count(Docs/example) > 0">
    <h2>Example</h2>
    <xsl:call-template name="DocsContent">
      <xsl:with-param name="Content" select="Docs/example" />
    </xsl:call-template>
  </xsl:if>
</xsl:template>

<xsl:template name="baseclass">
  <p>Baseclass:
    <xsl:call-template name="linktoclass">
      <xsl:with-param name="classname" select="Base/BaseTypeName" />
    </xsl:call-template>
  </p>
</xsl:template>

<xsl:template name="linktoclass">
  <xsl:param name="classname" />
  <xsl:choose>
    <xsl:when test="exists(//Types[@Library=$Library]/Type[@FullName=$classname])">
      <a href="{$classname}.html"><xsl:value-of select="$classname" /></a>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$classname" />
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>-->
    
</xsl:stylesheet>