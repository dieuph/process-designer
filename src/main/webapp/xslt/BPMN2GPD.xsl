<?xml version="1.0"?>
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:bpmn2="http://www.omg.org/spec/BPMN/20100524/MODEL"
	xmlns="urn:liferay.com:liferay-workflow_6.2.0"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:ext="http://exslt.org/common"
	exclude-result-prefixes="xsl bpmn2 ext">

    <!-- @author Ph.D -->
	<xsl:output method="xml" indent="yes" encoding="UTF-8"
		omit-xml-declaration="yes" xslt:indent-amount="3"
		xmlns:xslt="http://xml.apache.org/xslt" />
	<xsl:strip-space elements="*" />

	<!-- ******* Template for root - bpmn2:definitions ******* -->
	<xsl:template match="/">
		<workflow-definition
			xsi:schemaLocation="urn:liferay.com:liferay-workflow_6.2.0 http://www.liferay.com/dtd/liferay-workflow-definition_6_2_0.xsd">

			<xsl:apply-templates />
		</workflow-definition>
	</xsl:template>

	<!-- ******* Template for bpmn2:process ******* -->
	<xsl:template match="bpmn2:process">
		<name>
			<xsl:value-of select="./@name" />
		</name>
		<description>Something like description</description>
		<version>
			<xsl:value-of select="./@*[2]" />
		</version>
		<xsl:apply-templates select="*" />
	</xsl:template>

	<!-- ******* Template for bpmn2:startEvent ******* -->
	<xsl:template match="bpmn2:startEvent">
		<state>
			<name>
				<xsl:value-of select="./@name" />
			</name>
			<metadata>
				<xsl:call-template name="metadata">
					<xsl:with-param name="docContent" select="./bpmn2:documentation" />
				</xsl:call-template>
			</metadata>
			<initial>
				<xsl:value-of select="./@*[3]" />
			</initial>
			<transitions>
				<xsl:call-template name="transitionOut">
					<xsl:with-param name="outgoingId" select="./bpmn2:outgoing" />
				</xsl:call-template>
			</transitions>
		</state>
	</xsl:template>

	<!-- ******* Template for bpmn2:task ******* -->
	<xsl:template match="bpmn2:task">
		<task>
			<name>
				<xsl:value-of select="@name" />
			</name>
			<metadata>
				<xsl:call-template name="metadata">
					<xsl:with-param name="docContent" select="./bpmn2:documentation" />
				</xsl:call-template>
			</metadata>
			<actions>
                <xsl:for-each select="./bpmn2:extensionElements/*">
                        <xsl:variable name="nodeName" select="substring-before(substring-after(name(.), ':'), '-')" />
                        <xsl:call-template name="notification">
                            <xsl:with-param name="notiInfo" select="current()" />
                            <xsl:with-param name="notiType" select="$nodeName" />
                        </xsl:call-template>
                </xsl:for-each>
			</actions>
			<assignments>
			    <xsl:call-template name="roles">
			        <xsl:with-param name="ioSpecId" select="./bpmn2:ioSpecification/@id" />
			    </xsl:call-template>
			</assignments>
			<transitions>
				<xsl:for-each select="./bpmn2:outgoing">
					<xsl:call-template name="transitionOut">
						<xsl:with-param name="outgoingId" select="current()" />
					</xsl:call-template>
				</xsl:for-each>
			</transitions>
		</task>
	</xsl:template>

	<!-- ******* Template for bpmn2:exclusiveGateway ******* -->
	<xsl:template match="bpmn2:exclusiveGateway">
		<fork>
			<name>
				<xsl:value-of select="./@name" />
			</name>
			<transitions>
				<xsl:for-each select="./bpmn2:outgoing">
					<xsl:call-template name="transitionOut">
						<xsl:with-param name="outgoingId" select="current()" />
					</xsl:call-template>
				</xsl:for-each>
			</transitions>
		</fork>
	</xsl:template>

	<!-- ******* Template for bpmn2:parallelGateway ******* -->
	<xsl:template match="bpmn2:parallelGateway">
		<join>
			<name>
				<xsl:value-of select="./@name" />
			</name>
			<transitions>
				<xsl:for-each select="./bpmn2:outgoing">
					<xsl:call-template name="transitionOut">
						<xsl:with-param name="outgoingId" select="current()" />
					</xsl:call-template>
				</xsl:for-each>
			</transitions>
		</join>
	</xsl:template>

	<!-- ******* Template for bpmn2:endEvent ******* -->
	<xsl:template match="bpmn2:endEvent">
		<state>
			<name>
				<xsl:value-of select="./@name" />
			</name>
			<metadata>
				<xsl:call-template name="metadata">
					<xsl:with-param name="docContent" select="./bpmn2:documentation" />
				</xsl:call-template>
			</metadata>
			<actions>
				<xsl:for-each select="./bpmn2:extensionElements/*">
                        <xsl:variable name="nodeName" select="substring-before(substring-after(name(.), ':'), '-')" />
                        <xsl:call-template name="action">
                            <xsl:with-param name="notiInfo" select="current()" />
                            <xsl:with-param name="notiType" select="$nodeName" />
                        </xsl:call-template>
                </xsl:for-each>
			</actions>
		</state>
	</xsl:template>

	<!-- ********************* [[[[ NOW IS THE TIME FOR FUNCTION POWER ]]]] ********************* -->

	<!-- ******* Function for metadata - bpmn2:documentation ******* -->
	<xsl:template name="metadata">
		<xsl:param name="docContent" />
		<xsl:variable name="normalContent" select="normalize-space($docContent)" />
		<xsl:text disable-output-escaping="yes">&lt;![CDATA[</xsl:text>
		<xsl:value-of select="$normalContent" />
		<xsl:text disable-output-escaping="yes">]]&gt;</xsl:text>
	</xsl:template>

	<!-- ******* Function looking for transition - bpmn2:outgoing ******* -->
	<xsl:template name="transitionOut">
		<xsl:param name="outgoingId" />
		<xsl:variable name="sequenceFlowId" select="normalize-space($outgoingId)" />
		<xsl:if test="count($outgoingId) > 0">
			<xsl:for-each select="//bpmn2:sequenceFlow">
				<xsl:if test="string(@id) = string($sequenceFlowId)">
					<transition>
						<name>
							<xsl:value-of select="./@name" />
						</name>
						<target>
							<xsl:call-template name="targetRefName">
								<xsl:with-param name="targetId" select="./@targetRef" />
							</xsl:call-template>
						</target>
						<xsl:choose>
							<xsl:when test="@isImmediate = 'true'">
								<default>true</default>
							</xsl:when>
							<xsl:otherwise>
								<default>false</default>
							</xsl:otherwise>
						</xsl:choose>
					</transition>
				</xsl:if>
			</xsl:for-each>
		</xsl:if>
	</xsl:template>

	<!-- ******* Function looking for transition - bpmn2:incoming ******* -->
	<xsl:template name="transitionIn">
		<xsl:param name="incomingId" />
		<xsl:variable name="sequenceFlowId" select="normalize-space($incomingId)" />
		<xsl:if test="count($incomingId) > 0">
			<xsl:for-each select="//bpmn2:sequenceFlow">
				<xsl:if test="string(@id) = string($sequenceFlowId)">
					<xsl:value-of select="./@name" />
				</xsl:if>
			</xsl:for-each>
		</xsl:if>
	</xsl:template>

	<!-- ******* Function looking for @name of @targetRef ******* -->
	<xsl:template name="targetRefName">
		<xsl:param name="targetId" />
		<xsl:for-each select="//*">
			<xsl:if test="string(@id) = string($targetId)">
				<xsl:value-of select="./@name" />
			</xsl:if>
		</xsl:for-each>
	</xsl:template>
    
    <!-- ******* Function for notification - bpmn2:extensionElements ******* -->
    <xsl:template name="notification">
        <xsl:param name="notiInfo" />
        <xsl:param name="notiType" />
        <xsl:if test="count($notiInfo) > 0">
            <xsl:variable name="notiArray">
                <xsl:call-template name="split">
	                <xsl:with-param name="text" select="$notiInfo" />
	            </xsl:call-template>
            </xsl:variable>
            <xsl:variable name="notiElement" select="ext:node-set($notiArray)/*" />
            <notification>
	            <name>
                    <xsl:value-of select="$notiElement[1]" />
	            </name>
	            <template>
	                <xsl:value-of select="$notiElement[2]" />
	            </template>
	            <template-language>
                    <xsl:value-of select="$notiElement[3]" />
                </template-language>
	            <notification-type>
	                <xsl:value-of select="$notiElement[4]" />
	            </notification-type>
	            <xsl:if test="string($notiType) = string('onEntry')">
	                <execution-type>onAssignment</execution-type>
	            </xsl:if>
	            <xsl:if test="string($notiType) = string('onExit')">
	                <execution-type>onExit</execution-type>
	            </xsl:if>
	        </notification>
        </xsl:if>
    </xsl:template>

    <!-- ******* Function for action of End Event - bpmn2:extensionElements ******* -->
    <xsl:template name="action">
        <xsl:param name="notiInfo" />
        <xsl:param name="notiType" />
        <xsl:if test="count($notiInfo) > 0">
            <xsl:variable name="notiArray">
                <xsl:call-template name="split">
                    <xsl:with-param name="text" select="$notiInfo" />
                </xsl:call-template>
            </xsl:variable>
            <xsl:variable name="notiElement" select="ext:node-set($notiArray)/*" />
            <action>
                <name>
                    <xsl:value-of select="$notiElement[1]" />
                </name>
                <script>
                    <xsl:value-of select="$notiElement[2]" />
                </script>
                <script-language>
                    <xsl:value-of select="$notiElement[3]" />
                </script-language>
                <execution-type>onEntry</execution-type>
            </action>
        </xsl:if>
    </xsl:template>
    
    <!-- ******* Split function ******* -->
    <xsl:template name="split">
        <xsl:param name="text" />
        <xsl:param name="elementName" select="'word'" />
        <xsl:if test="string-length($text)">
            <xsl:element name="{$elementName}">
                <xsl:value-of select="substring-before(concat($text, ':'), ':')" />
            </xsl:element>
            <xsl:call-template name="split">
                <xsl:with-param name="text" select="substring-after($text, ':')" />
            </xsl:call-template>            
        </xsl:if>
    </xsl:template>
    
    <!-- ******* Function for roles ******* -->
    <xsl:template name="roles">
        <xsl:param name="ioSpecId" />
        <xsl:variable name="v_ioSpecId" select="normalize-space($ioSpecId)" />
        <xsl:choose>
            <xsl:when test="string-length($v_ioSpecId)">
	            <xsl:for-each select="//*">
	                <xsl:if test="string(@id) = string($ioSpecId)">
	                    <roles>
	                        <xsl:for-each select="./bpmn2:dataInput">
	                            <role>
	                               <name>
	                                   <xsl:value-of select="@name" />
	                               </name>
	                            </role>
	                        </xsl:for-each>
	                    </roles>
	                </xsl:if>
	            </xsl:for-each>        
	        </xsl:when>
	        <xsl:otherwise>
	           <user />
	        </xsl:otherwise>
        </xsl:choose>
        
    </xsl:template>
    
	<!-- ******* XSLT output formating: removing line breaks, bland output lines 
		n something like that ******* -->
	<xsl:template match="*/text()[normalize-space()]">
		<xsl:value-of select="normalize-space()" />
	</xsl:template>

	<xsl:template match="*/text()[not(normalize-space())]" />
</xsl:stylesheet>