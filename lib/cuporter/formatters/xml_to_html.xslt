<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output method="xml" indent="yes" />

  <xsl:template match="/">
    <xsl:apply-templates select="//report"/>
  </xsl:template>

  <xsl:template match="report">
    <xsl:element name="div">
      <xsl:attribute name="class">report</xsl:attribute>
      <xsl:attribute name="title"><xsl:value-of select="@title"/></xsl:attribute>
      <xsl:call-template name="cuporter_header"/> 
      <xsl:element name="ul">
        <xsl:attribute name="class">children</xsl:attribute>
        <xsl:apply-templates select="./tag | ./dir | ./feature"/>
      </xsl:element>
    </xsl:element>
  </xsl:template>

  <xsl:template name="cuporter_header">
    <xsl:element name="div">
      <xsl:attribute name="class">cuporter_header</xsl:attribute>

      <xsl:apply-templates select="../filter_summary"/>

      <xsl:element name="div">
        <xsl:attribute name="id">summary</xsl:attribute>
        <xsl:choose>
          <xsl:when test="@view='tag'">
            <xsl:element name="div">
              <xsl:attribute name="id">expand-collapse</xsl:attribute>
              <xsl:element name="p">
                <xsl:attribute name="id">expand_tags</xsl:attribute>
                <xsl:text>Expand Tags</xsl:text> 
              </xsl:element>
              <xsl:element name="p">
                <xsl:attribute name="id">expand_all</xsl:attribute>
                <xsl:text>Expand Features</xsl:text> 
              </xsl:element>
              <xsl:element name="p">
                <xsl:attribute name="id">collapser</xsl:attribute>
                <xsl:text>Collapse All</xsl:text> 
              </xsl:element>
            </xsl:element>
          </xsl:when>
          <xsl:when test="@view='tree'">
            <xsl:element name="p">
              <xsl:attribute name="id">total</xsl:attribute>
              <xsl:value-of select="@total"/>
              <xsl:text> Scenarios</xsl:text> 
            </xsl:element>
            <xsl:element name="div">
              <xsl:attribute name="id">expand-collapse</xsl:attribute>
              <xsl:element name="a">
                <xsl:attribute name="href">?#</xsl:attribute>
                <xsl:attribute name="id">collapse_features</xsl:attribute>
                <xsl:text>Collapse All</xsl:text> 
              </xsl:element>
              <xsl:element name="a">
                <xsl:attribute name="href">?#</xsl:attribute>
                <xsl:attribute name="id">expand_features</xsl:attribute>
                <xsl:text>Expand All</xsl:text> 
              </xsl:element>
            </xsl:element>
          </xsl:when>
          <xsl:otherwise>
            <xsl:element name="p">
              <xsl:attribute name="id">total</xsl:attribute>
              <xsl:value-of select="@total"/>
              <xsl:text> Scenarios</xsl:text> 
            </xsl:element>
            <xsl:element name="div">
              <xsl:attribute name="id">expand-collapse</xsl:attribute>
              <xsl:element name="p">
                <xsl:attribute name="id">collapse_features</xsl:attribute>
                <xsl:text>Collapse All</xsl:text> 
              </xsl:element>
              <xsl:element name="p">
                <xsl:attribute name="id">expand_features</xsl:attribute>
                <xsl:text>Expand All</xsl:text> 
              </xsl:element>
            </xsl:element>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:element>

      <xsl:element name="div">
        <xsl:attribute name="id">label</xsl:attribute>
        <xsl:element name="h1">
          <xsl:value-of select="@title"/>
        </xsl:element>
      </xsl:element>
    </xsl:element>
  </xsl:template>

  <xsl:template match="filter_summary">
    <xsl:element name="div">
      <xsl:attribute name="id">filter_summary</xsl:attribute>
      <xsl:element name="span">Filtering:</xsl:element>
      <xsl:apply-templates select="all | any | none"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="all">
    <xsl:element name="p">
      <xsl:attribute name="class">all</xsl:attribute>
      <xsl:text>Include: </xsl:text>
      <xsl:value-of select="@tags"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="any">
    <xsl:element name="p">
      <xsl:attribute name="class">any</xsl:attribute>
      <xsl:text>Include: </xsl:text>
      <xsl:value-of select="@tags"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="none">
    <xsl:element name="p">
      <xsl:attribute name="class">none</xsl:attribute>
      <xsl:text>Exclude: </xsl:text>
      <xsl:value-of select="@tags"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="tag">
    <xsl:element name="li">
      <xsl:attribute name="class">tag</xsl:attribute>
      <xsl:element name="div">
        <xsl:attribute name="class">properties</xsl:attribute>
        <xsl:apply-templates select="@cuke_name"/>
        <xsl:apply-templates select="@total"/>
      </xsl:element>

      <xsl:element name="ul">
        <xsl:attribute name="class">children</xsl:attribute>
        <xsl:apply-templates select="feature"/>
      </xsl:element>
    </xsl:element>
  </xsl:template>

  <xsl:template match="dir">
    <xsl:element name="li">
      <xsl:attribute name="class">dir</xsl:attribute>
      <xsl:element name="span">
        <xsl:attribute name="class">properties</xsl:attribute>
        <xsl:apply-templates select="@total"/>
        <xsl:apply-templates select="@fs_name"/>
      </xsl:element>

      <xsl:element name="ul">
        <xsl:attribute name="class">children</xsl:attribute>
        <xsl:apply-templates select="./dir | ./file | ./feature"/>
      </xsl:element>
    </xsl:element>
  </xsl:template>

  <xsl:template match="file">
    <xsl:element name="li">
      <xsl:attribute name="class">file</xsl:attribute>
      <xsl:element name="span">
        <xsl:attribute name="class">properties</xsl:attribute>
        <xsl:apply-templates select="@total"/>
        <xsl:apply-templates select="@fs_name"/>
      </xsl:element>

      <xsl:element name="ul">
        <xsl:apply-templates select="./feature"/>
      </xsl:element>
    </xsl:element>
  </xsl:template>

  <xsl:template match="feature">
    <xsl:element name="li">
      <xsl:attribute name="class">feature</xsl:attribute>
      <xsl:element name="div">
        <xsl:attribute name="class">properties</xsl:attribute>
        <xsl:apply-templates select="@cuke_name"/>
        <xsl:apply-templates select="@tags"/>
        <xsl:apply-templates select="@file_path"/>
        <xsl:apply-templates select="@total"/>
      </xsl:element>

      <xsl:if test="scenario | scenario_outline"> <!-- TODO:  remove this test if possible. seems redundant since we'll always have at least 1 child -->
        <xsl:element name="ul">
          <xsl:attribute name="class">children</xsl:attribute>
          <xsl:apply-templates select="scenario | scenario_outline"/>
        </xsl:element>
      </xsl:if>
    </xsl:element>
  </xsl:template>

  <xsl:template match="scenario">
    <xsl:element name="li">
      <xsl:attribute name="class">scenario</xsl:attribute>
      <xsl:element name="div">
        <xsl:attribute name="class">properties</xsl:attribute>
        <xsl:apply-templates select="@number"/>
        <xsl:apply-templates select="@cuke_name"/>
        <xsl:apply-templates select="@tags"/>
      </xsl:element>
    </xsl:element>
  </xsl:template>

  <xsl:template match="scenario_outline">
    <xsl:element name="li">
      <xsl:attribute name="class">scenario_outline</xsl:attribute>
      <xsl:element name="div">
        <xsl:attribute name="class">properties</xsl:attribute>
        <xsl:apply-templates select="@cuke_name"/>
        <xsl:apply-templates select="@tags"/>
      </xsl:element>
      <xsl:element name="ul">
        <xsl:attribute name="class">children</xsl:attribute>
        <xsl:apply-templates select="examples"/>
      </xsl:element>
    </xsl:element>
  </xsl:template>

  <xsl:template match="examples">
    <xsl:element name="li">
      <xsl:attribute name="class">examples</xsl:attribute>
      <xsl:element name="div">
        <xsl:attribute name="class">properties</xsl:attribute>
        <xsl:apply-templates select="@cuke_name"/>
        <xsl:apply-templates select="@tags"/>
      </xsl:element>
      <xsl:element name="table">
        <xsl:attribute name="class">children</xsl:attribute>
        <xsl:element name="thead">
          <xsl:apply-templates select="example_header"/>
        </xsl:element>
        <xsl:element name="tbody">
          <xsl:apply-templates select="example"/>
        </xsl:element>
      </xsl:element>
    </xsl:element>
  </xsl:template>

  <xsl:template match="@cuke_name">
    <xsl:element name="span">
      <xsl:attribute name="class">cuke_name</xsl:attribute>
      <xsl:value-of select="." disable-output-escaping="yes"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="@fs_name">
    <xsl:element name="span">
      <xsl:attribute name="class">fs_name</xsl:attribute>
      <xsl:value-of select="."/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="@tags">
    <xsl:element name="span">
      <xsl:attribute name="class">tags</xsl:attribute>
      <xsl:value-of select="."/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="@file_path">
    <xsl:element name="span">
      <xsl:attribute name="class">file_path</xsl:attribute>
      <xsl:value-of select="."/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="@total">
    <xsl:element name="span">
      <xsl:attribute name="class">total</xsl:attribute>
      <xsl:text>[</xsl:text>
      <xsl:value-of select="format-number(.,'00')"/>
      <xsl:text>]</xsl:text>
    </xsl:element>
  </xsl:template>

  <xsl:template match="@number">
    <xsl:element name="span">
      <xsl:attribute name="class">number</xsl:attribute>
      <xsl:value-of select="."/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="example_header">
    <xsl:element name="tr">
      <xsl:attribute name="class">example</xsl:attribute>
      <xsl:element name="th"> <xsl:attribute name="class">number</xsl:attribute> </xsl:element>
      <xsl:apply-templates select="span"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="example">
    <xsl:element name="tr">
      <xsl:attribute name="class">example</xsl:attribute>
      <xsl:element name="td"> <xsl:attribute name="class">number</xsl:attribute> <xsl:value-of select="@number"/> </xsl:element>
      <xsl:apply-templates select="span"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="example_header/span">
    <xsl:element name="th">
      <xsl:value-of select="."/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="example/span">
    <xsl:element name="td">
      <xsl:value-of select="."/>
    </xsl:element>
  </xsl:template>

</xsl:stylesheet>

