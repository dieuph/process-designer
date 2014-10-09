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
		omit-xml-declaration="yes" xslt:indent-amount="4"
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
	    <xsl:if test="./@name != ''">
            <name>
	            <xsl:value-of select="./@name" />
	        </name>
	    </xsl:if>
	    <!-- <description>Something like description</description> -->
		<xsl:if test="./@*[2] > 0">
			<version>
	            <xsl:value-of select="./@*[2]" />
	        </version>
		</xsl:if>
		
		<xsl:apply-templates select="*" />
	</xsl:template>

	<!-- ******* Template for bpmn2:startEvent ******* -->
	<xsl:template match="bpmn2:startEvent">
		<state>
		    <xsl:if test="./@name != ''">
		        <name>
                    <xsl:value-of select="./@name" />
                </name>
		    </xsl:if>
		    <xsl:if test="./bpmn2:documentation">
		        <metadata>
	                <xsl:call-template name="metadata">
	                    <xsl:with-param name="docContent" select="./bpmn2:documentation" />
	                </xsl:call-template>
	            </metadata>
		    </xsl:if>
			<initial>
				<xsl:value-of select="./@*[3]" />
			</initial>
			<xsl:if test="./bpmn2:extensionElements//*/@scriptFormat = 'notification'
                       or ./bpmn2:extensionElements//*/@scriptFormat = 'action'">
                <actions>
                    <xsl:for-each select="./bpmn2:extensionElements/*">
                        <xsl:variable name="propertyType" select="@scriptFormat" />
                        <xsl:if test="string($propertyType) = 'notification'">
                            <xsl:call-template name="notification">
                                <xsl:with-param name="notiContent" select="current()" />
                            </xsl:call-template>
                        </xsl:if>
                        <xsl:if test="string($propertyType) = 'action'">
                            <xsl:call-template name="action">
                                <xsl:with-param name="actionContent" select="current()" />
                            </xsl:call-template>
                        </xsl:if>
                    </xsl:for-each>
                </actions>
            </xsl:if>
            <xsl:if test="./bpmn2:extensionElements//*/@scriptFormat = 'role'
                       or ./bpmn2:extensionElements//*/@scriptFormat = 'scriptedassignment'">
                <assignments>
                    <xsl:for-each select="./bpmn2:extensionElements/*">
                        <xsl:variable name="propertyType" select="@scriptFormat" />
                        <xsl:if test="string($propertyType) = 'role'">
                            <xsl:call-template name="role">
                                <xsl:with-param name="roleContent" select="current()" />
                            </xsl:call-template>
                        </xsl:if>
                        <xsl:if test="string($propertyType) = 'scriptedassignment'">
                            <xsl:call-template name="scriptedassignment">
                                <xsl:with-param name="scriptedContent" select="current()" />
                            </xsl:call-template>
                        </xsl:if>
                    </xsl:for-each>
                </assignments>
            </xsl:if>
			<xsl:if test="./bpmn2:outgoing">
                <transitions>
                    <xsl:for-each select="./bpmn2:outgoing">
                        <xsl:call-template name="transitionOut">
                            <xsl:with-param name="outgoingId" select="current()" />
                        </xsl:call-template>
                    </xsl:for-each>
                </transitions>
            </xsl:if>
		</state>
	</xsl:template>

	<!-- ******* Template for bpmn2:task ******* -->
	<xsl:template match="bpmn2:task">
		<task>
			<xsl:if test="./@name != ''">
                <name>
                    <xsl:value-of select="./@name" />
                </name>
            </xsl:if>
			<xsl:if test="./bpmn2:documentation">
                <metadata>
                    <xsl:call-template name="metadata">
                        <xsl:with-param name="docContent" select="./bpmn2:documentation" />
                    </xsl:call-template>
                </metadata>
            </xsl:if>
			<xsl:if test="./bpmn2:extensionElements//*/@scriptFormat = 'notification'
                       or ./bpmn2:extensionElements//*/@scriptFormat = 'action'">
                <actions>
                    <xsl:for-each select="./bpmn2:extensionElements/*">
                        <xsl:variable name="propertyType" select="@scriptFormat" />
                        <xsl:if test="string($propertyType) = 'notification'">
                            <xsl:call-template name="notification">
                                <xsl:with-param name="notiContent" select="current()" />
                            </xsl:call-template>
                        </xsl:if>
                        <xsl:if test="string($propertyType) = 'action'">
                            <xsl:call-template name="action">
                                <xsl:with-param name="actionContent" select="current()" />
                            </xsl:call-template>
                        </xsl:if>
                    </xsl:for-each>
                </actions>
            </xsl:if>
            <xsl:if test="./bpmn2:extensionElements//*/@scriptFormat = 'role'
                       or ./bpmn2:extensionElements//*/@scriptFormat = 'scriptedassignment'">
                <assignments>
                    <xsl:for-each select="./bpmn2:extensionElements/*">
                        <xsl:variable name="propertyType" select="@scriptFormat" />
                        <xsl:if test="string($propertyType) = 'role'">
                            <xsl:call-template name="role">
                                <xsl:with-param name="roleContent" select="current()" />
                            </xsl:call-template>
                        </xsl:if>
                        <xsl:if test="string($propertyType) = 'scriptedassignment'">
                            <xsl:call-template name="scriptedassignment">
                                <xsl:with-param name="scriptedContent" select="current()" />
                            </xsl:call-template>
                        </xsl:if>
                    </xsl:for-each>
                </assignments>
            </xsl:if>
			<xsl:if test="./bpmn2:outgoing">
                <transitions>
                    <xsl:for-each select="./bpmn2:outgoing">
                        <xsl:call-template name="transitionOut">
                            <xsl:with-param name="outgoingId" select="current()" />
                        </xsl:call-template>
                    </xsl:for-each>
                </transitions>
            </xsl:if>
		</task>
	</xsl:template>

	<!-- ******* Template for bpmn2:inclusiveGateway ******* -->
	<xsl:template match="bpmn2:inclusiveGateway">
		<condition>
		    <xsl:if test="./@name != ''">
                <name>
                    <xsl:value-of select="./@name" />
                </name>
            </xsl:if>
            <xsl:if test="./bpmn2:extensionElements/*">
            <!-- looking for script and script-language -->
	            <xsl:for-each select="./bpmn2:extensionElements/*">
					<xsl:variable name="propertyType" select="@scriptFormat" />
					<xsl:if test="string($propertyType) = 'beanshell' 
					            or string($propertyType) = 'drl' 
					            or string($propertyType) = 'groovy' 
					            or string($propertyType) = 'javascript' 
					            or string($propertyType) = 'python'
					            or string($propertyType) = 'ruby'">
						<xsl:call-template name="script">
							<xsl:with-param name="scriptContent" select="current()" />
						</xsl:call-template>
					</xsl:if>
				</xsl:for-each>
			</xsl:if>
			<xsl:if test="./bpmn2:extensionElements//*/@scriptFormat = 'notification'
			           or ./bpmn2:extensionElements//*/@scriptFormat = 'action'">
	            <actions>
	                <xsl:for-each select="./bpmn2:extensionElements/*">
	                    <xsl:variable name="propertyType" select="@scriptFormat" />
	                    <xsl:if test="string($propertyType) = 'notification'">
	                        <xsl:call-template name="notification">
	                            <xsl:with-param name="notiContent" select="current()" />
	                        </xsl:call-template>
	                    </xsl:if>
	                    <xsl:if test="string($propertyType) = 'action'">
	                        <xsl:call-template name="action">
	                            <xsl:with-param name="actionContent" select="current()" />
	                        </xsl:call-template>
	                    </xsl:if>
	                </xsl:for-each>
	            </actions>
            </xsl:if>
            <xsl:if test="./bpmn2:extensionElements//*/@scriptFormat = 'role'
                       or ./bpmn2:extensionElements//*/@scriptFormat = 'scriptedassignment'">
				<assignments>
					<xsl:for-each select="./bpmn2:extensionElements/*">
						<xsl:variable name="propertyType" select="@scriptFormat" />
						<xsl:if test="string($propertyType) = 'role'">
							<xsl:call-template name="role">
								<xsl:with-param name="roleContent" select="current()" />
							</xsl:call-template>
						</xsl:if>
						<xsl:if test="string($propertyType) = 'scriptedassignment'">
							<xsl:call-template name="scriptedassignment">
								<xsl:with-param name="scriptedContent" select="current()" />
							</xsl:call-template>
						</xsl:if>
					</xsl:for-each>
				</assignments>
			</xsl:if>
			<xsl:if test="./bpmn2:outgoing">
				<transitions>
	                <xsl:for-each select="./bpmn2:outgoing">
	                    <xsl:call-template name="transitionOut">
	                        <xsl:with-param name="outgoingId" select="current()" />
	                    </xsl:call-template>
	                </xsl:for-each>
	            </transitions>
            </xsl:if>
		</condition>
	</xsl:template>

	<!-- ******* Template for bpmn2:parallelGateway ******* -->
	<xsl:template match="bpmn2:parallelGateway">
		<xsl:if test="string(./@gatewayDirection) = 'Diverging'">
			<xsl:call-template name="fork" />
		</xsl:if>
        <xsl:if test="string(./@gatewayDirection) = 'Converging'">
            <xsl:call-template name="join" />
        </xsl:if>
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
                    <xsl:variable name="propertyType" select="@scriptFormat" />
                    <xsl:if test="string($propertyType) = 'notification'">
                        <xsl:call-template name="notification">
                            <xsl:with-param name="notiContent" select="current()" />
                        </xsl:call-template>
                    </xsl:if>
                    <xsl:if test="string($propertyType) = 'action'">
                        <xsl:call-template name="action">
                            <xsl:with-param name="actionContent" select="current()" />
                        </xsl:call-template>
                    </xsl:if>
                </xsl:for-each>
			</actions>
		</state>
	</xsl:template>

	<!-- ********************* [[[[ NOW IS THE TIME FOR FUNCTION POWER ]]]] ********************* -->

	<!-- ******* Function for bpmn2:documentation - metadata ******* -->
	<xsl:template name="metadata">
		<xsl:param name="docContent" />
		<xsl:variable name="normalContent" select="normalize-space($docContent)" />
		<xsl:text disable-output-escaping="yes">&lt;![CDATA[</xsl:text>
		<xsl:value-of select="$normalContent" />
		<xsl:text disable-output-escaping="yes">]]&gt;</xsl:text>
	</xsl:template>

	<!-- ******* Function looking for bpmn2:outgoing - transition ******* -->
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

	<!-- ******* Function looking for bpmn2:incoming - transition ******* -->
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
    
    <!-- ******* Function for bpmn2:extensionElements - notification ******* -->
    <xsl:template name="notification">
        <xsl:param name="notiContent" />
        <xsl:if test="count($notiContent) > 0">
            <xsl:variable name="notiSplited">
                <xsl:call-template name="split">
                    <xsl:with-param name="text" select="$notiContent" />
                    <xsl:with-param name="delim" select="'`'" />
                </xsl:call-template>
            </xsl:variable>
            <xsl:variable name="notiSplitedArray" select="ext:node-set($notiSplited)/*" />
            <xsl:for-each select="$notiSplitedArray">
                <xsl:variable name="notiArray">
	                <xsl:call-template name="split">
	                    <xsl:with-param name="text" select="current()" />
	                    <xsl:with-param name="delim" select="':'" />
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
	                <execution-type>
	                    <xsl:value-of select="$notiElement[5]" />
	                </execution-type>
	                <xsl:if test="count($notiElement[6]) > 0">
	                <description>
	                    <xsl:value-of select="$notiElement[6]" />
	                </description>
	                </xsl:if>
	            </notification>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>

    <!-- ******* Function for bpmn2:extensionElements - action ******* -->
    <xsl:template name="action">
        <xsl:param name="actionContent" />
        <xsl:if test="count($actionContent) > 0">
            <xsl:variable name="actionSplited">
                <xsl:call-template name="split">
                    <xsl:with-param name="text" select="$actionContent" />
                    <xsl:with-param name="delim" select="'`'" />
                </xsl:call-template>
            </xsl:variable>
            <xsl:variable name="actionSplitedArray" select="ext:node-set($actionSplited)/*" />
            <xsl:for-each select="$actionSplitedArray">
                <xsl:variable name="actionArray">
	                <xsl:call-template name="split">
	                    <xsl:with-param name="text" select="current()" />
	                    <xsl:with-param name="delim" select="':'" />
	                </xsl:call-template>
	            </xsl:variable>
	            <xsl:variable name="actionElement" select="ext:node-set($actionArray)/*" />
	            <action>
	                <name>
	                    <xsl:value-of select="$actionElement[1]" />
	                </name>
	                <script>
	                    <xsl:text disable-output-escaping="yes">&#xa;&#x9;&#x9;&#x9;&#x9;&lt;![CDATA[&#xa;</xsl:text>
	                    <xsl:text>&#x9;&#x9;&#x9;&#x9;</xsl:text>
					    <xsl:value-of select="$actionElement[2]" />
					    <xsl:text disable-output-escaping="yes">&#xa;&#x9;&#x9;&#x9;&#x9;]]&gt;&#xa;</xsl:text>
					    <xsl:text>&#x9;&#x9;&#x9;&#x9;</xsl:text>
	                </script>
	                <script-language>
	                    <xsl:value-of select="$actionElement[3]" />
	                </script-language>
	                <execution-type>
	                    <xsl:value-of select="$actionElement[4]" />
	                </execution-type>
	                <xsl:if test="count($actionElement[5]) > 0">
                    <priority>
                        <xsl:value-of select="$actionElement[5]" />
                    </priority>	                
	                </xsl:if>
	                <xsl:if test="count($actionElement[6]) > 0">
	                <description>
	                    <xsl:value-of select="$actionElement[6]" />
	                </description>
	                </xsl:if>
	            </action>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>
    
    <!-- ******* Function for bpmn2:extensionElements - role ******* -->
    <xsl:template name="role">
        <xsl:param name="roleContent" />
        <xsl:if test="count($roleContent) > 0">
            <roles>
            <xsl:variable name="roleSpited">
                <xsl:call-template name="split">
                    <xsl:with-param name="text" select="$roleContent" />
                    <xsl:with-param name="delim" select="'`'" />
                </xsl:call-template>
            </xsl:variable>
            <xsl:variable name="roleSpitedArray" select="ext:node-set($roleSpited)/*" />
            <xsl:for-each select="$roleSpitedArray">
                <xsl:variable name="roleArray">
                    <xsl:call-template name="split">
                        <xsl:with-param name="text" select="current()" />
                        <xsl:with-param name="delim" select="':'" />
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="roleElement" select="ext:node-set($roleArray)/*" />
                <role>
                    <role-type>
                        <xsl:value-of select="$roleElement[1]"/>
                    </role-type>
                    <name>
                        <xsl:value-of select="$roleElement[2]"/>
                    </name>
                </role>
            </xsl:for-each>
            </roles>
        </xsl:if>
    </xsl:template>

    <!-- ******* Function for bpmn2:extensionElements - scriptassignment ******* -->
    <xsl:template name="scriptedassignment">
        <xsl:param name="scriptedContent" />
        <xsl:if test="count($scriptedContent) > 0">
            <scripted-assignment>
            <xsl:variable name="scriptedSplited">
                <xsl:call-template name="split">
                    <xsl:with-param name="text" select="$scriptedContent" />
                    <xsl:with-param name="delim" select="'`'" />
                </xsl:call-template>
            </xsl:variable>
            <xsl:variable name="scriptedSpitedArray" select="ext:node-set($scriptedSplited)/*" />
            <xsl:for-each select="$scriptedSpitedArray">
                <xsl:variable name="scriptedArray">
                    <xsl:call-template name="split">
                        <xsl:with-param name="text" select="current()" />
                        <xsl:with-param name="delim" select="':'" />
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="scriptedElement" select="ext:node-set($scriptedArray)/*" />
                <script>
                    <xsl:value-of select="$scriptedElement[1]"/>
                </script>
                <script-language>
                    <xsl:value-of select="$scriptedElement[2]"/>
                </script-language>               
            </xsl:for-each>
            </scripted-assignment>
        </xsl:if>
    </xsl:template>
    
    <!-- ******* Split function ******* -->
    <xsl:template name="split">
        <xsl:param name="text" />
        <xsl:param name="delim" />
        <xsl:param name="elementName" select="'item'" />
        <xsl:if test="string-length($text)">
            <xsl:element name="{$elementName}">
                <xsl:value-of select="substring-before(concat($text, $delim), $delim)" />
            </xsl:element>
            <xsl:call-template name="split">
                <xsl:with-param name="text" select="substring-after($text, $delim)" />
                <xsl:with-param name="delim" select="$delim" />
            </xsl:call-template>            
        </xsl:if>
    </xsl:template>
    
    <!-- ******* Function for bpmn2:parallelGateway - fork ******* -->
    <xsl:template name="fork">
	    <fork>
			<name>
				<xsl:value-of select="./@name" />
			</name>
			<xsl:if test="./bpmn2:extensionElements/*">
			<actions>
                <xsl:for-each select="./bpmn2:extensionElements/*">
                    <xsl:variable name="propertyType" select="@scriptFormat" />
                    <xsl:if test="string($propertyType) = 'notification'">
                        <xsl:call-template name="notification">
                            <xsl:with-param name="notiContent" select="current()" />
                        </xsl:call-template>
                    </xsl:if>
                    <xsl:if test="string($propertyType) = 'action'">
                        <xsl:call-template name="action">
                            <xsl:with-param name="actionContent" select="current()" />
                        </xsl:call-template>
                    </xsl:if>
                </xsl:for-each>
            </actions>
            <assignments>
                <xsl:for-each select="./bpmn2:extensionElements/*">
                    <xsl:variable name="propertyType" select="@scriptFormat" />
                    <xsl:if test="string($propertyType) = 'role'">
                        <xsl:call-template name="role">
                            <xsl:with-param name="roleContent" select="current()" />
                        </xsl:call-template>
                    </xsl:if>
                    <xsl:if test="string($propertyType) = 'scriptedassignment'">
                        <xsl:call-template name="scriptedassignment">
                            <xsl:with-param name="scriptedContent" select="current()" />
                        </xsl:call-template>
                    </xsl:if>
                </xsl:for-each>
            </assignments>
            </xsl:if>
			<transitions>
				<xsl:for-each select="./bpmn2:outgoing">
					<xsl:call-template name="transitionOut">
						<xsl:with-param name="outgoingId" select="current()" />
					</xsl:call-template>
				</xsl:for-each>
			</transitions>
		</fork>
    </xsl:template>
    
    <!-- ******* Function for bpmn2:parallelGateway - join ******* -->
    <xsl:template name="join">
        <join>
            <name>
                <xsl:value-of select="./@name" />
            </name>
            <xsl:if test="./bpmn2:extensionElements/*">
            <actions>
                <xsl:for-each select="./bpmn2:extensionElements/*">
                    <xsl:variable name="propertyType" select="@scriptFormat" />
                    <xsl:if test="string($propertyType) = 'notification'">
                        <xsl:call-template name="notification">
                            <xsl:with-param name="notiContent" select="current()" />
                        </xsl:call-template>
                    </xsl:if>
                    <xsl:if test="string($propertyType) = 'action'">
                        <xsl:call-template name="action">
                            <xsl:with-param name="actionContent" select="current()" />
                        </xsl:call-template>
                    </xsl:if>
                </xsl:for-each>
            </actions>
            <assignments>
                <xsl:for-each select="./bpmn2:extensionElements/*">
                    <xsl:variable name="propertyType" select="@scriptFormat" />
                    <xsl:if test="string($propertyType) = 'role'">
                        <xsl:call-template name="role">
                            <xsl:with-param name="roleContent" select="current()" />
                        </xsl:call-template>
                    </xsl:if>
                    <xsl:if test="string($propertyType) = 'scriptedassignment'">
                        <xsl:call-template name="scriptedassignment">
                            <xsl:with-param name="scriptedContent" select="current()" />
                        </xsl:call-template>
                    </xsl:if>
                </xsl:for-each>
            </assignments>
            </xsl:if>
            <transitions>
                <xsl:for-each select="./bpmn2:outgoing">
                    <xsl:call-template name="transitionOut">
                        <xsl:with-param name="outgoingId" select="current()" />
                    </xsl:call-template>
                </xsl:for-each>
            </transitions>
        </join>
    </xsl:template>
    
    <!-- ******* Function for bpmn2:parallelGateway - join ******* -->
    <xsl:template name="script">
        <xsl:param name="scriptContent" />
        <xsl:if test="count($scriptContent) > 0">
            <script>
	            <xsl:text disable-output-escaping="yes">&#xa;&#x9;&#x9;&#x9;&lt;![CDATA[&#xa;</xsl:text>
	            <xsl:text>&#x9;&#x9;&#x9;</xsl:text>
	            <xsl:value-of select="$scriptContent" />
	            <xsl:text disable-output-escaping="yes">]]&gt;&#xa;</xsl:text>
	            <xsl:text>&#x9;&#x9;</xsl:text>
	        </script>
	        <script-language>
	            <xsl:value-of select="@scriptFormat"/>
	        </script-language>        
        </xsl:if>
    </xsl:template>
    
	<!-- ******* XSLT output formating: removing line breaks, bland output lines 
		n something like that ******* -->
	<xsl:template match="*/text()[normalize-space()]">
		<xsl:value-of select="normalize-space()" />
	</xsl:template>

	<xsl:template match="*/text()[not(normalize-space())]" />
</xsl:stylesheet>