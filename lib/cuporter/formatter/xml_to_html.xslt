<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output method="xml"
    indent="yes"
    />


  <xsl:template match="/">
    <xsl:apply-templates select="//report"/>
  </xsl:template>

  <xsl:template match="report">
    <xsl:element name="div">
      <xsl:attribute name="class">report</xsl:attribute>
      <xsl:attribute name="title"><xsl:value-of select="@title"/></xsl:attribute>
      <xsl:element name="ul">

        <xsl:choose>
          <xsl:when test="//tag">
            <xsl:apply-templates select="//tag"/>
          </xsl:when>
          <xsl:when test="//dir">
            <xsl:apply-templates select="//dir"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates select="//feature"/>
          </xsl:otherwise>
        </xsl:choose>

      </xsl:element>
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

      <xsl:element name='ul'>
        <xsl:attribute name="class">children</xsl:attribute>
        <xsl:apply-templates select="feature"/>
      </xsl:element>
    </xsl:element>
  </xsl:template>

  <xsl:template match="dir">  <!-- Boh! -->
    <xsl:element name="li">
      <xsl:attribute name="class">dir</xsl:attribute>
      <xsl:element name="div">
        <xsl:attribute name="class">properties</xsl:attribute>
        <xsl:apply-templates select="@cuke_name"/>
        <xsl:apply-templates select="@total"/>
      </xsl:element>

      <xsl:element name='ul'>
        <xsl:attribute name="class">children</xsl:attribute>
        <xsl:if test="./dir">
          <xsl:apply-templates select="./dir"/>
        </xsl:if>
        <xsl:if test="feature">
          <xsl:apply-templates select="./feature"/>
        </xsl:if>
      </xsl:element>
    </xsl:element>
  </xsl:template>

  <xsl:template match="feature">
    <xsl:element name="li">
      <xsl:attribute name="class">feature</xsl:attribute>
      <xsl:element name="div">
        <xsl:attribute name="class">properties</xsl:attribute>
        <xsl:apply-templates select="@cuke_name"/>
        <xsl:apply-templates select="@total"/>
        <xsl:apply-templates select="@tags"/>
        <xsl:element name="span">
          <xsl:attribute name="class">file</xsl:attribute>
          <xsl:value-of select="@file"/>
        </xsl:element>
      </xsl:element>

      <xsl:if test="scenario | scenario_outline"> <!-- TODO:  remove this test if possible. seems redundant since we'll always have at least 1 child -->
        <xsl:element name='ul'>
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
    </xsl:element>
    <xsl:element name="ul">
      <xsl:attribute name="class">children</xsl:attribute>
      <xsl:apply-templates select="examples"/>
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
          <xsl:apply-templates select="example[1]"/>
        </xsl:element>
        <xsl:element name="tbody">
          <xsl:apply-templates select="example[@number]"/>
        </xsl:element>
      </xsl:element>
    </xsl:element>
  </xsl:template>

  <xsl:template match="@cuke_name">
    <xsl:element name="span">
      <xsl:attribute name="class">cuke_name</xsl:attribute>
      <xsl:value-of select="."/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="@tags">
    <xsl:element name="span">
      <xsl:attribute name="class">tags</xsl:attribute>
      <xsl:value-of select="."/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="@total">
    <xsl:element name="span">
      <xsl:attribute name="class">total</xsl:attribute>
      <xsl:text>[</xsl:text>
      <xsl:value-of select="."/>
      <xsl:text>]</xsl:text>
    </xsl:element>
  </xsl:template>

  <xsl:template match="@number">
    <xsl:element name="span">
      <xsl:attribute name="class">number</xsl:attribute>
      <xsl:value-of select="."/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="example[1]">
    <xsl:element name="tr">
      <xsl:attribute name="class">example</xsl:attribute>
      <xsl:element name="th"> <xsl:attribute name="class">number</xsl:attribute> </xsl:element>
      <xsl:apply-templates select="span"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="example[@number]">
    <xsl:element name="tr">
      <xsl:attribute name="class">example</xsl:attribute>
      <xsl:element name="td"> <xsl:attribute name="class">number</xsl:attribute> <xsl:value-of select="@number"/> </xsl:element>
      <xsl:apply-templates select="span"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="example[1]/span">
    <xsl:element name="th">
      <xsl:value-of select="."/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="example[@number]/span">
    <xsl:element name="td">
      <xsl:value-of select="."/>
    </xsl:element>
  </xsl:template>

</xsl:stylesheet>

